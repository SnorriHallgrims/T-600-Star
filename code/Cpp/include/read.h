#ifndef ont_read
#define ont_read
#include <seqan/bam_io.h>
#include <seqan/seq_io.h>

using namespace std;
using namespace seqan;

const char CIGAR_ALNMATCH = 'M';    // alignment match (can be a sequence match or mismatch)
const char CIGAR_INSERTION = 'I';   // insertion to the reference
const char CIGAR_DELETION = 'D';    // deletion from the reference
const char CIGAR_SKIPPED = 'N';     // skipped region from the reference
const char CIGAR_SOFTCLIP = 'S';    // soft clipping (clipped sequences present in SEQ)
const char CIGAR_HARDCLIP = 'H';    // hard clipping (clipped sequences NOT present in SEQ)
const char CIGAR_PADDING = 'P';     // padding (silent deletion from padded reference)
const char CIGAR_SEQMATCH = '=';    // sequence match
const char CIGAR_SEQMISMATCH = 'X'; // sequence mismatch
class Read
{
	public :
	string qName;  // TODO make this const
	Dna5String seq = NULL; 
	//CharString qual;
	string Type = "unaligned"; 
	int nFragments = 0; 
	string altName = ""; 	 
	string contig = "";
	unsigned seqLen = 0, alnLen = 0;
	double seqPhred = 0, seqScore = 0, mapQual=-1;
	unsigned nDel = 0, nIns = 0, nMis = 0;
	bool supplementary=false;
        int posRefBeg=0, posSeqBeg=0, posSeqEnd=0, posRefEnd=0;
	string orientation = "NA"; 
	void SetStrandName(string str)
	{ 
        	qName = str.substr(0,str.find(' ')); // first word
	        qName = qName.substr(0,qName.find(".fast5")); // remove extension
		 
		// Scrappie FASTA:  { "normalised_score" : 0.327284,  "nblock" : 2638,  "sequence_length" : 1280,  "blocks_per_base" : 2.060937, "nsample" : 13555, "trim" : [ 200, 13390 ] }
		int pos = str.find("\"normalised_score\"");
		if(pos != std::string::npos) 
		{
			string score = str.substr(pos);
			pos = score.find(":")+1;
			int epos = score.find(",");
			score = score.substr(pos,epos-pos);
			seqScore = stod(score);
			return;
		}
		// Sloika FASTA: score -5253, 81690 samples to 10737 bases
		pos = str.find("score"); 
		if(pos != std::string::npos)
		{
			string score = str.substr(pos);
                        pos = score.find(" ")+1;
                        int epos = score.find(",");
			score = score.substr(pos,epos-pos);
                        seqScore = stod(score);
			return;
		}
	};
	void ComputeError(BamAlignmentRecord& record)
	{
		if (hasFlagUnmapped(record)) return;
		if (hasFlagSecondary(record)) return;
		if (length(record.seq)==0) return;
		mapQual = record.mapQ; 
		orientation = hasFlagRC(record) ? "RC" : "F" ;
		posRefBeg = record.beginPos;
		posSeqBeg = 0;
		posSeqEnd = posSeqBeg;
		posRefEnd = posRefBeg + getAlignmentLengthInRef(record);
		supplementary = hasFlagSupplementary(record);
		for (unsigned i=0; i<length(record.cigar); ++i)
		{
			CigarElement<> cigar = record.cigar[i];
			if (i == 0 && cigar.operation == CIGAR_SOFTCLIP)
			{
				posSeqBeg = record.cigar[0].count;
				posSeqEnd = posSeqBeg;
			}
			if (cigar.operation == CIGAR_ALNMATCH || cigar.operation == CIGAR_INSERTION)
				posSeqEnd += record.cigar[i].count;
			switch(cigar.operation)
			{	
				case CIGAR_DELETION:
					nDel += record.cigar[i].count;break;
				case CIGAR_INSERTION:
					nIns += record.cigar[i].count;break;
			}
		}
		alnLen = posSeqEnd - posSeqBeg;
		
		BamTagsDict tagsDict(record.tags);
		unsigned editDistIdx = 0;
		int editDistVal = 0;
		if (!findTagKey(editDistIdx, tagsDict, "NM"))
		{
			cerr << "ERROR: Edit distance tag (NM) not provided for: " << record.qName << endl;
			nMis = nDel + nIns;
		}
		else
		{
			if (!extractTagValue(editDistVal, tagsDict, editDistIdx))
			{
				cerr << "ERROR: There was an error extracting edit distance (NM) from tags in read: " << record.qName << endl;
				nMis = nDel + nIns;
			}
			else nMis = editDistVal - (nDel + nIns);
		}
		if (editDistVal < nDel + nIns)
			cerr << "The edit distance is less than the sum of inserts and deletions, this should not happen: " << record.qName << endl;
		
		if (seqLen==0)
			cerr << "ERROR: Read length is 0 for read: " << record.qName << endl;
	}
};
class LongRead
{
	private :
        long long unsigned nDel = 0, nIns = 0, nMis = 0, alnLen = 0; 
        long double seqPhred = 0, seqScore = 0, alnMapQual = 0;
        vector<unsigned> lengths;

	double Coverage(long long unsigned &totalBasepairs)
	{
        	return (double)totalBasepairs/(double)3000000000;
	}
	unsigned ComputeN50(vector<unsigned>& readLengths, long long unsigned& totalBasepairs)
	{
        	sort(readLengths.begin(), readLengths.end(), greater<unsigned>());
	        long long unsigned bpCovered = 0;
        	long long unsigned limit = ceil(totalBasepairs/2);
	        for (unsigned i = 0; i<readLengths.size(); ++i)
        	{
                	bpCovered += readLengths[i];
	                if (bpCovered > limit)
        	                return readLengths[i];
	        }
        	return readLengths[readLengths.size()-1];
	}

        public :
	long long unsigned seqLen = 0;
	unsigned N50, nReads, nAlnReads=0;  
	double coverage, avgPhred, avgScore, avgMapQual; 
	double errDel, errIns, errMis, errSum, pctAln;
	unsigned nUltra = 0, whale=0, baitfish = UINT_MAX; 
        void AddToSummary(const Read add)
        {
                lengths.push_back(add.seqLen);
                seqLen += add.seqLen;
		if (add.seqPhred > 0) seqPhred += add.seqPhred;
		seqScore += add.seqScore; 
		if (add.seqLen > whale) whale = add.seqLen;
                if (add.seqLen >= 100000) nUltra++;
		if (add.seqLen < baitfish) baitfish = add.seqLen;

		if (add.alnLen == 0) return; 
		nAlnReads+=1;
		alnMapQual += add.mapQual;
		alnLen += add.alnLen;
                nDel += add.nDel;
                nIns += add.nIns;
                nMis += add.nMis;
        }
	void PrintSummary(const bool simple=false, const int minbps=0)
        {
		nReads = lengths.size();
	       	if (nReads == 0)
	       	{
			cerr << "Error: No reads to summarise." << endl; 
			throw std::invalid_argument( "No reads to summarise" );
			return;
		}
		N50 = ComputeN50(lengths, seqLen);	
		avgPhred = seqPhred > 0 ? seqPhred/(long double)nReads : 0;
		avgScore = seqScore > 0 ? seqScore/(long double)nReads : 0; 
		avgMapQual = alnMapQual > 0 ? alnMapQual/(long double)nAlnReads : 0;
		pctAln = (double)100 * (alnLen/(double)seqLen);
		errDel = (double)100 * (nDel/(double)alnLen);
		errIns = (double)100 * (nIns/(double)alnLen);
		errMis = (double)100 * (nMis/(double)alnLen);
		errSum = (double)100 * ((nDel + nIns + nMis)/(double)alnLen);
		coverage = Coverage(seqLen);
		const char sep = (simple ? '=' : '\t'); 
                cout    << (simple ? "minReadLen" : "Minimum length of reads:") << sep << minbps << (simple ? "" : "bp") << endl \
			<< (simple ? "nReads" : "Total number of reads:") << sep << nReads << endl \
                        << (simple ? "nBps" : "Total number of basePairs:") << sep << seqLen << endl;
		cout	<< (simple ? "N50" : "N50:" ) << sep << N50 << endl \
			<< (simple ? "nUltra" : "Total number of ultralong reads (>100kb):") << sep << nUltra << endl \
			<< (simple ? "Whale" : "Largest read:") << sep << whale << endl \
			<< (simple ? "Baitfish" : "Smallest read:") << sep << baitfish << endl \
                        << (simple ? "Cov" : "Coverage:" ) << sep << coverage << (simple ? "" : "X") << endl;
                if (nAlnReads == 0) {
			cout << (simple ? "muScore" : "Mean quality score:") << sep << (avgPhred > avgScore ? avgPhred : avgScore) << endl;
			return;
		}	
	 	cout    << (simple ? "nAlnReads" : "Total number of aligned reads:") << sep << nAlnReads << endl \
			<< (simple ? "muMap" : "Mean mapping quality:") << sep << avgMapQual << endl \
			<< (simple ? "PctAln" : "Percentage of aligned basePairs:" ) << sep << pctAln << (simple ? "" : "%" ) << endl \
                        << (simple ? "ErrDel" : "Deletion error:" ) << sep << errDel << (simple ? "" : "%" ) << endl \
                        << (simple ? "ErrIns" : "Insertion error:" ) << sep << errIns << (simple ? "" : "%" ) << endl \
                        << (simple ? "ErrMis" : "Mismatch error:" ) << sep << errMis << (simple ? "" : "%" ) << endl \
                        << (simple ? "ErrSum" : "Error sum:" ) << sep << errSum << (simple ? "" : "%" ) << endl \
                        << (simple ? "nBpsAln" : "Total number of aligned basePairs:") << sep << alnLen << endl \
			<< (simple ? "nBpsDel" : "Total number of deleted basePairs:") << sep << nDel << endl \
			<< (simple ? "nBpsIns" : "Total number of inserted basePairs:") << sep << nIns << endl \
                        << (simple ? "nBpsMis" : "Total number of mismatched basePairs:") << sep << nMis << endl;
        }
};
#endif
