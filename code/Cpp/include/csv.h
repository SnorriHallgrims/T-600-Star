#ifndef csv
#define csv
#include <iostream>
using namespace std;
typedef vector<string> CSVRow;
int FindElem(CSVRow v, string elem)
{
        return find(v.begin(), v.end(), elem) - v.begin();
}
vector<CSVRow> readCsvFile(string &pathToCsvFile, const char sep='\t')
{
	fstream inFile(pathToCsvFile, std::ios::in);
        if(!inFile.is_open()){
                cerr << "File " << pathToCsvFile << " not found!" << endl;
                throw invalid_argument( "ERROR: Cannot import reads" );
        }
	string csvLine;
	vector<CSVRow> db;
	// read every line from the stream
	while( std::getline(inFile, csvLine) ){
                std::istringstream csvStream(csvLine);
                CSVRow csvRow;
                string csvCol;
                // read every element from the line that is seperated by tab
                // and put it into the vector or strings
		while ( std::getline(csvStream, csvCol, sep) )
			csvRow.push_back(csvCol);
		db.push_back(csvRow);
	}
	inFile.close();
	return db;
}
#endif
