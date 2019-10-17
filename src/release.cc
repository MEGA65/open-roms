//
// Utility to prepare a release with automatically
// assigned version numbers
//

#include "common.h"

#include <stdlib.h>
#include <unistd.h>

#include <algorithm>
#include <list>

//
// Command and enviroment line settings
//

std::string CMD_inDir   = "./build";
std::string CMD_outDir  = "./bin";

std::list<std::string> CMD_fileList;

std::string ENV_developerId;

//
// Common helper functions
//

void printUsage()
{
    std::cout << "\n" <<
        "usage: release [-i <input (build) directory>] [-o <output (release) directory>]" << "\n" <<
        "               <file list>" << "\n\n";
}

//
// Top-level functions
//

void parseCommandLine(int argc, char **argv)
{
    int opt;

    // Retrieve command line options

    while ((opt = getopt(argc, argv, "i:o:")) != -1)
    {
        switch(opt)
        {
            case 'i': CMD_inDir    = optarg; break;
            case 'o': CMD_outDir   = optarg; break;
            default: printUsage(); ERROR();
        }
    }

    // Retrieve file/directory list

    for (int idx = optind; idx < argc; idx++)
    {
        CMD_fileList.push_back(argv[idx]);
    }

    if (CMD_fileList.empty()) { printUsage(); ERROR("empty file list"); }
}

void getEnvironmentSettings()
{
	const char* id = getenv("OPEN_ROMS_DEVELOPER_ID");

	// Check whether the developer ID is suitable

	if (id == nullptr)
	{
		ERROR("environment variable OPEN_ROMS_DEVELOPER_ID not set");
	}

	ENV_developerId = id;

	if (ENV_developerId.length() < 2 || ENV_developerId.length() > 3)
	{
		ERROR("OPEN_ROMS_DEVELOPER_ID has to be 2 or 3 characters long");
	}

	for (const char &c : ENV_developerId)
	{
		if (!(c >= 'A' && c <= 'Z'))
		{
			ERROR("OPEN_ROMS_DEVELOPER_ID can only contain uppercase letters");
		}
	}
}

void printBanner()
{
    printBannerLineTop();
    std::cout << "// Preparing ROM set release by '" << ENV_developerId << "'\n";
    printBannerLineBottom();
}

void readFiles()
{
	// XXX
}

void embedVersionString()
{
	// XXX
}

void writeFiles()
{
	// XXX
}

//
// Class definitions
//

class ROMFile
{
public:

    ROMFile(const std::string &baseFileName);

private:

    std::string baseFileName;

    std::vector<uint8_t> srcFile;
    std::vector<uint8_t> dstFile;
}

//
// Main function
//

int main(int argc, char **argv)
{
    parseCommandLine(argc, argv);
    getEnvironmentSettings();

    printBanner();

    readFiles();
    embedVersionString();
    writeFiles();

    ERROR("This tool is not finished yet");

    return 0;
}

//
// Class 'ROMFile'
//

ROMFile::ROMFile(const std::string &baseFileName)
{
    // XXX

}
