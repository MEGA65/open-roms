//
// Utility to prepare a release with automatically
// assigned version numbers
//

#include "common.h"

#include <stdlib.h>
#include <time.h>
#include <unistd.h>

#include <algorithm>
#include <cstring>
#include <fstream>
#include <ios>
#include <list>
#include <vector>

const std::vector<uint8_t> STR_MEGABAS  = { 0x4D, 0x45, 0x47, 0x41, 0x42, 0x41, 0x53, 0x32 };
const std::vector<uint8_t> STR_OR       = { 0x4F, 0x52 };
const std::vector<uint8_t> STR_SNAPSHOT = { 0x28, 0x44, 0x45, 0x56, 0x45, 0x4C, 0x20, 0x53, 
                                            0x4E, 0x41, 0x50, 0x53, 0x48, 0x4F, 0x54, 0x29,
                                            0x00 };

//
// Command and enviroment line settings
//

std::string CMD_inDir   = "./build";
std::string CMD_outDir  = "./bin";

std::list<std::string> CMD_fileList;

std::string ENV_developerId;
std::string ENV_timeString;

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
// Class definitions
//

enum class ROMType
{
    ROM_UNKNOWN,
    ROM_BASIC,
    ROM_KERNAL
};

class ROMFile
{
public:

    ROMFile(const std::string &baseFileName);

private:

    void readSrcFile();
    void readDstFile();

    void recognizeFiles();

    std::string baseFileName;

    std::vector<uint8_t> srcFileContent;
    std::vector<uint8_t> dstFileContent;

    ROMType romType;
};

//
// Global variables
//

std::list<ROMFile> GLOBAL_ROMFiles;

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

void getDeveloperId()
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

void getDate()
{
    time_t t     = time(NULL);
    struct tm tm = *localtime(&t);

    const std::string year  = std::to_string(tm.tm_year % 100);
    const std::string month = std::to_string(tm.tm_mon + 1);
    const std::string day   = std::to_string(tm.tm_mday);

    const std::string zero  = "0";


    ENV_timeString = (year.size() == 2  ? year  : zero + year) +
                     (month.size() == 2 ? month : zero + month) +
                     (day.size() == 2   ? day   : zero + day);

    if (ENV_timeString.size() != 6) ERROR("could not retrieve date");
}

void printBanner()
{
    printBannerLineTop();
    std::cout << "// Preparing ROM set release " << ENV_timeString << "-" << ENV_developerId << "\n";
    printBannerLineBottom();
}

void readFiles()
{
    for (auto &fileName : CMD_fileList) GLOBAL_ROMFiles.push_back(ROMFile(fileName));
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
// Main function
//

int main(int argc, char **argv)
{
    parseCommandLine(argc, argv);
    getDeveloperId();
    getDate();

    printBanner();

    readFiles();
    embedVersionString();
    writeFiles();

    std::cout << "\n\nXXX This tool is not finished yet\n\n";

    return 1;
}

//
// Class 'ROMFile'
//

ROMFile::ROMFile(const std::string &baseFileName) :
    baseFileName(baseFileName),
    romType(ROMType::ROM_UNKNOWN)
{
    readSrcFile();
    readDstFile();

    recognizeFiles();
}

void ROMFile::readSrcFile()
{
    // Read the source file

    const std::string srcFileNamePath = CMD_inDir + DIR_SEPARATOR + baseFileName;

    std::ifstream srcFile;
    srcFile.open(srcFileNamePath, std::ios::in | std::ios::binary | std::ios::ate);

    if (!srcFile.good()) ERROR(std::string("unable to open ROM file '") + srcFileNamePath + "'");

    auto srcSize = srcFile.tellg();
    if (srcSize != 8192) ERROR(std::string("incorrect size of ROM file '") + srcFileNamePath + "'");

    srcFileContent.resize(8192);
    srcFile.seekg (0, srcFile.beg);
    srcFile.read((char *) srcFileContent.data(), srcFileContent.size());

    if (!srcFile.good()) ERROR(std::string("unable to read ROM file '") + srcFileNamePath + "'");
    srcFile.close();   
}

void ROMFile::readDstFile()
{
    // Read the destination file (if exists and it's size matches)

    const std::string dstFileNamePath = CMD_outDir + DIR_SEPARATOR + baseFileName;

    std::ifstream dstFile;
    dstFile.open(dstFileNamePath, std::ios::in | std::ios::binary | std::ios::ate);

    bool continueReading = dstFile.good();

    if (continueReading && dstFile.tellg() != 8192) continueReading = false;

    if (continueReading)
    {
        dstFileContent.resize(8192);
        dstFile.seekg (0, dstFile.beg);
        dstFile.read((char *) dstFileContent.data(), dstFileContent.size());       
    }

    if (!dstFile.good()) dstFileContent.resize(0);
    dstFile.close();
}

void ROMFile::recognizeFiles()
{
    // Recognize source file type

    std::cout << baseFileName << " ";

    if ((memcmp(&srcFileContent[0x0004], STR_MEGABAS.data(),  STR_MEGABAS.size())  == 0) &&
        (memcmp(&srcFileContent[0x1F52], STR_OR.data(),       STR_OR.size())       == 0) &&
        (memcmp(&srcFileContent[0x1F55], STR_SNAPSHOT.data(), STR_SNAPSHOT.size()) == 0))
    {
        romType = ROMType::ROM_BASIC;
    }
    else if (srcFileContent[0x1F80] == 0xF0 &&
             (memcmp(&srcFileContent[0x04B9], STR_OR.data(),       STR_OR.size())       == 0) &&
             (memcmp(&srcFileContent[0x04BC], STR_SNAPSHOT.data(), STR_SNAPSHOT.size()) == 0))
    {
        romType = ROMType::ROM_KERNAL;
    }
    else
    {
        ERROR(std::string("'") + CMD_inDir + DIR_SEPARATOR + baseFileName +
              "' is not a supported unversioned Open ROMs image");
    }

    // XXX

    std::cout << baseFileName << " ";
    std::cout << "\n";
}
