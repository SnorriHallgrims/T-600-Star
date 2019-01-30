#ifndef ont_alnreads
#define ont_alnreads
#include "read.h"
using namespace std;
using namespace seqan;

static bool customCompare(const Read & Left, const Read & Right)
{
	return Left.posSeqBeg < Right.posSeqBeg;
};
class AlignedReads 
{
	private :
		map<string,String<Read>> _supplementaryReads;
		map<string,Read> _combinedReads;
		bool notOverlapping(Read& current, Read& next)
		{
			return current.posSeqEnd < next.posSeqBeg;
		}
 
	public : 
		const map<string,Read>& All() const { return _combinedReads; }
		void GetBamRecords(BamFileIn &seqBamFileIn)
        	{
        		BamHeader header;
	                readHeader(header, seqBamFileIn);
        	        BamAlignmentRecord record;
	                while (!atEnd(seqBamFileIn))
        	        {
				readRecord(record, seqBamFileIn);
                        	Read read;
	                        read.SetStrandName(toCString(record.qName));
        	                read.seqLen = length(record.seq);
                	        read.ComputeError(record);
                        	if (read.alnLen > 0)
	                        {
        	                	read.contig = toCString(getContigName(record, seqBamFileIn));
                	              	appendValue(_supplementaryReads[read.qName], read);
				}
				else {
					_supplementaryReads[read.qName]=read;
				}
			}
			for(auto const it : _supplementaryReads)
			{
				string qName = it.first;
				vector<Read> parts(seqan::begin(it.second), seqan::end(it.second));
				sort(parts.begin(),parts.end(),customCompare);
			        Read combined = parts[0];
			        Read current  = parts[0];
				combined.nFragments++;		
			        for (unsigned i=1; i<length(parts); ++i)
			        {
			                if (notOverlapping(current, parts[i]))
		                	{
						combined.nFragments++; 
                		        	combined.alnLen+=parts[i].alnLen;
			                        combined.nDel  +=parts[i].nDel;
                        			combined.nIns  +=parts[i].nIns;
			                        combined.nMis  +=parts[i].nMis;
						combined.mapQual += parts[i].mapQual; 
						if(parts[i].posSeqBeg<combined.posSeqBeg) combined.posSeqBeg=parts[i].posSeqBeg; 
                                                if(parts[i].posSeqEnd>combined.posSeqEnd) combined.posSeqEnd=parts[i].posSeqEnd; 
                                                if(parts[i].posRefBeg<combined.posRefBeg) combined.posRefBeg=parts[i].posRefBeg; 
                                                if(parts[i].posRefEnd>combined.posRefEnd) combined.posRefEnd=parts[i].posRefEnd;
                        			current = parts[i];
			                }
			                if (parts[i].seqLen > combined.seqLen) combined.seqLen = parts[i].seqLen;
			        }
				if (combined.nFragments>1){ combined.mapQual /= combined.nFragments; }
				combined.Type = combined.alnLen == 0 ? "unaligned" : combined.nFragments > 1 ? "combined" : "noSuppl"; 
				_combinedReads[qName]=combined; 
			}
		}
		void CalculateSummary(const bool simple=false, const int minbps=0)
                {
                        LongRead total;
                        for(auto const itr : _combinedReads)
                                if (itr.second.seqLen >= minbps)
                                        total.AddToSummary(itr.second);
                        total.PrintSummary(simple,minbps);
                }
}; 
bool ImportBam(BamFileIn &seqBamFileIn, CharString pathToBamFile)
{
        if (!open(seqBamFileIn, toCString(pathToBamFile)))
        {
                cerr << "ERROR: Seqan could not open input file: " << pathToBamFile << endl;
                return false;
        }
        return true;
}
#endif
