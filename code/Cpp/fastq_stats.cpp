#include <seqan/arg_parse.h>
#include "include/read.h"
#include "include/fqreads.h"
#include "include/csv.h"
using namespace std;

FqReads FastqQuality(CharString &pathToFqFile, const int minBpsLen, const bool keepSeq)
{
	seqan::SeqFileIn seqFqFileIn;
	if(!ImportFastq(seqFqFileIn,pathToFqFile)) throw invalid_argument( "ERROR: Cannot import reads" );
	FqReads reads; 
	reads.GetFqRecords(seqFqFileIn,minBpsLen,keepSeq); 
	return reads; 
}

void UpdateReadName(string &pathToCsvFile, FqReads &reads)
{
	vector<CSVRow> db = readCsvFile(pathToCsvFile,'\t');
	CSVRow header = db.at(0);
	const int ixFile = FindElem(header, "filename"); 	
	const int ixName = FindElem(header, "read_id");
	const int ixScore = FindElem(header, "mean_qscore_template"); 
	for(auto it = db.begin()+1; it!=db.end(); ++it)
	{
		CSVRow row = *it; 
		string filename = row[ixFile].substr(0,row[ixFile].find(".fast5"));
		string qName = row[ixName]; 
		float score = stof(row[ixScore]);
		reads.UpdateRead(filename,qName,score); 
	}
}

void WriteCSVSummary(FqReads &reads, string &pathToCsvFile)
{
	ofstream outFile;
	outFile.open(pathToCsvFile);
	if (!outFile.is_open()) throw std::invalid_argument( "ERROR: Could not open .csv file: "+ pathToCsvFile );
	const char sep = '\t';
        outFile << "readName" << sep << "readLen" << sep << "meanQual" << endl; // header
	for(auto const itr : reads.All())
	{
		Read it = itr.second;
		outFile << it.qName << sep \
			<< it.seqLen << sep \
			<< it.seqPhred << endl; 
	}
	outFile.close();
}

struct prog_options{
	public :
		CharString pathToFqFile; 
		string pathToCsvFile, pathToFaFile;
		string sequencingSummary; 
		int minBpsLen;
		prog_options(): pathToFqFile(""),pathToFaFile(""),pathToCsvFile(""),sequencingSummary(""),minBpsLen(3000){};
};
prog_options ParseArguments(int argc, const char** argv)
{
	prog_options O;
	ArgumentParser parser(argv[0]);
	addUsageLine(parser, "\"\\fIreads.fq\\fP\"");
	addDescription(parser, "Summarise read lengths and quality for FASTQ files");
	// mandatory arguments
	addArgument(parser, ArgParseArgument(ArgParseArgument::STRING, "reads"));
	// optional arguments
	addOption(parser, ArgParseOption("o", "readsummary", \
		"if provided, writes read summary from [reads.fq] to file as tab-separated values", \
		ArgParseArgument::STRING, "STRING"));
        addOption(parser, ArgParseOption("f", "fastafile", \
                "if provided, writes a fasta version of [reads.fq] filtered w.r.t. read length determined by [minBpsLen]", \
                ArgParseArgument::STRING, "STRING"));
	addOption(parser, ArgParseOption("s", "sequencing_summary", \
                "necessary for albacore due to renaming of query names", \
                ArgParseArgument::STRING, "STRING"));
	addOption(parser, ArgParseOption("l", "minBpsLen", \
                "limit reads based on minimum length of basepairs", \
                ArgParseArgument::INTEGER, "INTEGER"));
        setDefaultValue( parser, "l", O.minBpsLen );
	// sanity check
	ArgumentParser::ParseResult res = parse(parser, argc, argv);
	if (res != ArgumentParser::PARSE_OK) throw std::invalid_argument( "ERROR: Cannot parse arguments" );
	// get values 
	getArgumentValue( O.pathToFqFile, parser, 0);
	if(isSet(parser,"o")) getOptionValue( O.pathToCsvFile, parser, "o");
        if(isSet(parser,"f")) getOptionValue( O.pathToFaFile, parser, "f");
	if(isSet(parser,"s")) getOptionValue( O.sequencingSummary, parser, "s");
        if(isSet(parser,"l")) getOptionValue( O.minBpsLen, parser, "l");
	return O;
}
int main(int argc, const char *argv[])
{
	try{
		prog_options opt = ParseArguments(argc,argv); 
		bool keepSeq = !opt.pathToFaFile.empty();
		FqReads reads = FastqQuality(opt.pathToFqFile,opt.minBpsLen,keepSeq);
                reads.CalculateSummary(true, opt.minBpsLen);
		if(!opt.sequencingSummary.empty())
			UpdateReadName(opt.sequencingSummary, reads);
		if (!opt.pathToCsvFile.empty()) 
			WriteCSVSummary(reads, opt.pathToCsvFile);
		if (keepSeq)
			reads.WriteToFasta(opt.pathToFaFile);
	} catch (const std::exception &e) {
                cerr << e.what() << std::endl;
                return 1;
        }
}
