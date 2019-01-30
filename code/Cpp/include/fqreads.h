#ifndef ont_fqreads
#define ont_fqreads
#include "read.h"
using namespace std;
using namespace seqan;

class FqReads
{
	private: 
		map<string,Read> _reads; 
		long long unsigned _totSeqLen = 0;
		long long unsigned _totAlnLen = 0;
	public:
		const map<string,Read>& All() const { return _reads; }
		void GetFqRecords(SeqFileIn &seqFqFileIn,const int minBpsLen = 0, const bool keepSeq=false)
		{
		        CharString id;
	        	Dna5String seq;
        		CharString qual;
		        while (!atEnd(seqFqFileIn))
        		{
                		readRecord(id, seq, qual, seqFqFileIn);
                                Read read;
                                read.seqLen = (int)length(seq);
				if( read.seqLen < minBpsLen )
					continue; 
				if ( keepSeq ) read.seq = seq; 
                                read.SetStrandName(toCString(id));
		                unsigned qualSum = 0;
		        	for (unsigned i=0; i<(int)length(qual); ++i)
        		                qualSum += (qual[i]-33);
		        	read.seqPhred = qualSum > 0 ? (float)qualSum/(float)read.seqLen : 0; 
        		        _reads[read.qName] = read;
		        }
		}
		void UpdateRead(string altName, string qName, float score)
                {
                        if(_reads.count(qName)>0)
                        {
                                _reads[qName].altName=altName;
                                _reads[qName].seqScore=score;
                        }
                }
		void CalculateSummary(const bool simple=false, const int minbps=0)
		{
			LongRead total;
		        for(auto const itr : _reads) 
				if (itr.second.seqLen >= minbps) 
					total.AddToSummary(itr.second);
			total.PrintSummary(simple,minbps);
		}
		void WriteToFasta(const string pathToFaFile)
		{
		        ofstream outFile;
		        outFile.open(pathToFaFile);
		        if (!outFile.is_open()) throw std::invalid_argument( "ERROR: Could not open .fa file: "+ pathToFaFile );
			for(auto const itr : _reads)
		        {
				Read it = itr.second;
				outFile << ">" << it.qName << endl \
					<< it.seq << endl;
			}
			outFile.close();
		}
};
bool ImportFastq(SeqFileIn &seqFqFileIn, CharString pathToFqFile)
{
	if (!open(seqFqFileIn, toCString(pathToFqFile)))
	{
		cerr << "ERROR: Seqan could not open input file: " << pathToFqFile << endl;
                return false;
        }
	return true;
}
#endif
