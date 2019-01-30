#ifndef ont_strand
#define ont_strand
#include <boost/algorithm/string/classification.hpp> // Include boost::for is_any_of
#include <boost/algorithm/string/split.hpp> // Include for boost::split
#include <boost/range/algorithm/remove_if.hpp> // Include for boost::remove_if
using namespace std;
class Strand
{
	public :
	string name; 
	int channel, run, read; 
	void SetStrandName(string str)
	{
		// case 1 : MINION3_20170606_FNFAF18231_MN19418_mux_scan_IWXJYQX_71081_ch100_read11_strand
		// case 2 : MINION11_20170630_FN_MN21518_sequencing_run_14014_read_1003_ch_429_strand
		name = str;
		replace( str.begin(), str.end(), '_', ' '); 
		vector<string> words;
		boost::split(words, str, boost::is_any_of(" "), boost::token_compress_on);
		for (int i=0; i<words.size(); ++i)
		{
			string word = words[i]; 
			if (word.find("ch") == 0 )
			{
				if(word.size()>2) // case 1
				{
					channel = stoi(word.substr(2));
					run = stoi(words[i-1]); 									
				}
				else // case 2
				{
					channel = stoi(words[++i]);
				}
			}
			else if (word.find("read") == 0 )
			{
				if(word.size()>4) // case 1
				{
					read = stoi(word.substr(4));
				}
				else // case 2
				{
					run = stoi(words[i-1]);
					read = stoi(words[++i]);
				}
			}
		}
	}
};
#endif
