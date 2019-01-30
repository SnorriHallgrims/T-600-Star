#include <seqan/arg_parse.h>
#include "include/read.h"
#include "include/alnreads.h"
#include <math.h> // isnan 
using namespace std;

const char sep = '\t';
void printToFile(ofstream &outFile, const Read r, bool &reportPos)
{
        outFile << r.qName << sep << r.seqLen << sep << r.alnLen << sep \
		<< r.nDel << sep << r.nIns << sep << r.nMis << sep \
		<< r.supplementary << sep << r.Type << sep \
		<< r.seqPhred;
	if(reportPos)
		outFile << sep << r.contig \
			<< sep << r.posRefBeg << sep << r.posRefEnd \
			<< sep << r.posSeqBeg << sep << r.posSeqEnd \
			<< sep << r.orientation << sep << r.mapQual; 
	outFile << endl;
}
void WriteCSVSummary(AlignedReads &reads, string &pathToCsvFile, bool &reportPos)
{
	ofstream outFile;
	outFile.open(pathToCsvFile);
	if (!outFile.is_open()) throw std::invalid_argument( "ERROR: Could not open .csv file: "+ pathToCsvFile );
	// header
	outFile << "qName" << sep << "seqLen" << sep << "alnLen" << sep << "nDel" << sep << "nIns" << sep << "nMis" << sep << "supplementary" << sep << "type" << sep << "meanPhred"; 
	if(reportPos) 
		outFile << sep << "contig" << sep << "posRefBeg" << sep << "posRefEnd" << sep << "posSeqBeg" << sep << "posSeqEnd" << sep << "orientation" << sep << "mapQual";
	outFile << endl;
	//Print rates for all aligned reads
	for (auto const & itr : reads.All())
	{
		string qName = itr.first;		
		Read combined = itr.second;
		if(combined.alnLen > 0) 
			printToFile(outFile, combined, reportPos);
	}
	//Print phred scores for unaligned reads at end of output file
	for (auto const & itr : reads.All())
	{
		string qName = itr.first;
		Read combined = itr.second;
                if(combined.alnLen == 0) 
			printToFile(outFile, combined, reportPos);
	}
	outFile.close();
}
struct prog_options{
        public :
                CharString pathToBamFile;
                string pathToCsvFile;
		bool reportPos;  
                int minbps;
                prog_options(): pathToBamFile(""),pathToCsvFile(""), reportPos(false),minbps(3000){};
};
prog_options ParseArguments(int argc, const char** argv)
{
        prog_options O;
        ArgumentParser parser(argv[0]);
        addUsageLine(parser, "\"\\fImappedreads.bam\\fP\"");
        addDescription(parser, "Summarise read lengths and error rates for BAM files");
        // mandatory arguments
        addArgument(parser, ArgParseArgument(ArgParseArgument::STRING, "mappedreads"));
       	// optional arguments
	addOption(parser, ArgParseOption("o", "readsummary", \
		"if provided, writes read summary from [mappedreads.bam] to file as tab-separated values", \
		ArgParseArgument::STRING, "STRING"));
	addOption(parser, ArgParseOption("r", "reportposistion",\
		"if provided, writes into read summary the begin and end positions in reference", \
		ArgParseArgument::INTEGER, "BOOLEAN"));
	addOption(parser, ArgParseOption("l", "minbps", \
                "limit reads based on minimum length of basepairs", \
                ArgParseArgument::INTEGER, "INTEGER"));
	setDefaultValue( parser, "r", O.reportPos );
        setDefaultValue( parser, "l", O.minbps );
	// sanity check
	ArgumentParser::ParseResult res = parse(parser, argc, argv);
	if (res != ArgumentParser::PARSE_OK) throw std::invalid_argument( "ERROR: Cannot parse arguments" );
	// get values 
	getArgumentValue( O.pathToBamFile, parser, 0);
	if(isSet(parser,"o")) getOptionValue( O.pathToCsvFile, parser, "o");
	int reportPos = 0;
	if(isSet(parser,"r")) getOptionValue( reportPos, parser, "r");
	O.reportPos = reportPos > 0;
        if(isSet(parser,"l")) getOptionValue( O.minbps, parser, "l"); 
	return O;
}

int main(int argc, char const ** argv)
{
	try {
		prog_options opt = ParseArguments(argc,argv); 
		AlignedReads reads; 
		BamFileIn inFile; 
		ImportBam(inFile,opt.pathToBamFile);
		reads.GetBamRecords(inFile);
		reads.CalculateSummary(true, opt.minbps);
		if (!opt.pathToCsvFile.empty()) 
			WriteCSVSummary(reads, opt.pathToCsvFile, opt.reportPos);
	} catch (const std::exception &e) {
                cerr << e.what() << std::endl;
                return 1;
        }
}
