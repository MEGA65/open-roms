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

typedef struct
{
    std::string romTypeName;
    size_t  fileSize;
    size_t  signatureOffset; // offset to 'OR' string
    bool    requireIdBASIC;
    bool    requireIdKERNAL;

} ROMTypeDescriptionEntry;

const std::vector<ROMTypeDescriptionEntry> ROM_DEFINITIONS =
{
    {
        "BASIC",
        8192,     // file size
        0x1F52,   // signature offset
        true,     // whether to require BASIC ID
        false     // whether to require KERNAL ID
    },
    
    {
        "KERNAL",
        8192,     // file size
        0x04B9,   // signature offset
        false,    // whether to require BASIC ID
        false     // whether to require KERNAL ID
    },
};

const uint16_t MAX_FILE_SIZE = 8192;

const std::vector<uint8_t> STR_MEGABAS  = { 0x4D, 0x45, 0x47, 0x41, 0x42, 0x41, 0x53, 0x32 };
const std::vector<uint8_t> STR_OR       = { 0x4F, 0x52 };
const std::vector<uint8_t> STR_SNAPSHOT = { 0x28, 0x44, 0x45, 0x56, 0x45, 0x4C, 0x20, 0x53, 
                                            0x4E, 0x41, 0x50, 0x53, 0x48, 0x4F, 0x54, 0x29,
                                            0x00 };

const std::string STR_DEV = "DEV.";

//
// Command and enviroment line settings
//

std::string CMD_inDir   = "./build";
std::string CMD_outDir  = "./bin";

std::list<std::string> CMD_fileList;

std::string ENV_developerId;
std::string ENV_dateString;

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

class ROMFile
{
public:

    ROMFile(const std::string &baseFileName);

    void embedRevisionStr(const std::string &newRevisionStr);
    void save();

    const ROMTypeDescriptionEntry *descPtr;

    bool    sameContent;
    bool    sameDeveloper;
    bool    sameDate;       // only set if sameDeveloper
    uint8_t oldDailyRelId;  // only set if sameDeveloper and sameDate

private:

    void readSrcFile();
    void readDstFile();

    void recognizeSrcFile();
    void dropUnmatchingDst();
    void analyzeContent();

    std::string baseFileName;

    std::vector<uint8_t> srcFileContent;
    std::vector<uint8_t> dstFileContent;
};

//
// Global variables
//

size_t             GLOBAL_maxFileNameLen    = 0;
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

    ENV_dateString = (year.size()  == 2 ? year  : zero + year) +
                     (month.size() == 2 ? month : zero + month) +
                     (day.size()   == 2 ? day   : zero + day);

    if (ENV_dateString.size() != 6) ERROR("could not retrieve date");
}

void printBanner()
{
    printBannerLineTop();
    std::cout << "// Preparing ROM set release" << "\n";
    printBannerLineBottom();
}

void readFiles()
{
    for (auto &fileName : CMD_fileList) GLOBAL_ROMFiles.push_back(ROMFile(fileName));
}

void decideIfUpdate()
{
    // Check if we have any file at all

    if (GLOBAL_ROMFiles.empty())
    {
        ERROR("no files to update");
    }

    // Check if we have at least one file with changed content

    bool sameContent = true;
    for (auto &file : GLOBAL_ROMFiles)
    {
        if (!file.sameContent)
        {
            sameContent = false;
            break;
        }
    }

    if (sameContent)
    {
        ERROR("same content in all the files");
    }
}

void saveFiles()
{
    // Determine a daily revision sequence ID

    uint8_t relId = 0;
    for (auto &file : GLOBAL_ROMFiles)
    {
        if (file.sameDeveloper && file.sameDate)
        {
            relId = std::max(file.oldDailyRelId, relId);
        }
    }
    relId++;

    if (relId > 9)
    {
        ERROR("too many releases this day");
    }

    // Create a new revision string

    const std::string newRevStr = STR_DEV + ENV_dateString + "." + ENV_developerId + "." + std::to_string(relId);

    for (auto &file : GLOBAL_ROMFiles)
    {
        file.embedRevisionStr(newRevStr);
    }

    std::cout << "Files for release '" << newRevStr << "':\n\n";

    // Save the files

    for (auto &file : GLOBAL_ROMFiles)
    {
        file.save();
    }
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
    decideIfUpdate();
    saveFiles();

    std::cout << "\n";

    return 0;
}

//
// Class 'ROMFile'
//

ROMFile::ROMFile(const std::string &baseFileName) :
    descPtr(nullptr),
    sameContent(false),
    sameDeveloper(false),
    sameDate(false),
    oldDailyRelId(0),
    baseFileName(baseFileName)
{
    GLOBAL_maxFileNameLen = std::max(GLOBAL_maxFileNameLen, baseFileName.length());

    readSrcFile();
    readDstFile();

    recognizeSrcFile();
    dropUnmatchingDst();
    analyzeContent();
}

void ROMFile::readSrcFile()
{
    // Read the source file

    const std::string srcFileNamePath = CMD_inDir + DIR_SEPARATOR + baseFileName;

    std::ifstream srcFile;
    srcFile.open(srcFileNamePath, std::ios::in | std::ios::binary | std::ios::ate);

    if (!srcFile.good()) ERROR(std::string("unable to open ROM file '") + srcFileNamePath + "'");

    auto srcSize = srcFile.tellg();
    if (srcSize > MAX_FILE_SIZE) ERROR(std::string("incorrect size of ROM file '") + srcFileNamePath + "'");

    srcFileContent.resize(srcSize);
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

    if (continueReading && dstFile.tellg() != unsigned(srcFileContent.size())) continueReading = false;

    if (continueReading)
    {
        dstFileContent.resize(srcFileContent.size());
        dstFile.seekg (0, dstFile.beg);
        dstFile.read((char *) dstFileContent.data(), dstFileContent.size());       
    }

    if (!dstFile.good()) dstFileContent.clear();
    dstFile.close();
}

void ROMFile::recognizeSrcFile()
{
    // Recognize source file type

    for (auto &SPEC : ROM_DEFINITIONS)
    {
        if (srcFileContent.size() != SPEC.fileSize) continue;

        if (SPEC.requireIdBASIC && memcmp(&srcFileContent[0x0004], STR_MEGABAS.data(), STR_MEGABAS.size()) != 0)
        {
            continue;
        }

        if (SPEC.requireIdKERNAL && srcFileContent[0x1F80] != 0xF0)
        {
            continue;
        }

        if (memcmp(&srcFileContent[SPEC.signatureOffset], STR_OR.data(), STR_OR.size()) != 0)
        {
            continue;
        }

        auto snapshotStrOffset = SPEC.signatureOffset + STR_OR.size() + 1;
        if (memcmp(&srcFileContent[snapshotStrOffset], STR_SNAPSHOT.data(), STR_SNAPSHOT.size()) != 0)
        {
            continue;
        }

        auto zeroByteoffset = snapshotStrOffset + 0x10;
        if (srcFileContent[zeroByteoffset] != 0)
        {
            continue;
        }

        descPtr = &SPEC;
        break;
    }

    if (descPtr == nullptr)
    {
        ERROR(std::string("'") + CMD_inDir + DIR_SEPARATOR + baseFileName +
              "' is not a supported unversioned Open ROMs image");
    }
}

void ROMFile::dropUnmatchingDst()
{
    // Drop unmatching destination file data

    if (!dstFileContent.empty() && descPtr->requireIdBASIC &&
        memcmp(&dstFileContent[0x0004], STR_MEGABAS.data(), STR_MEGABAS.size()) != 0)
    {
        dstFileContent.clear();
    }

    if (!dstFileContent.empty() && descPtr->requireIdKERNAL && dstFileContent[0x1F80] != 0xF0)
    {
        dstFileContent.clear();
    }

    if (!dstFileContent.empty() &&
        memcmp(&dstFileContent[descPtr->signatureOffset], STR_OR.data(), STR_OR.size()) != 0)
    {
        dstFileContent.clear();
    }
}

void ROMFile::analyzeContent()
{
    auto revOffset = descPtr->signatureOffset + 3;

    if (dstFileContent.empty())
    {
        return;
    }

    // Check if meaningful file content is really different

    if ((memcmp(&srcFileContent[0x0000], &dstFileContent[0x0000], revOffset) == 0) &&
        (memcmp(&srcFileContent[revOffset + 0x10], &dstFileContent[revOffset + 0x10], 8192 - revOffset) == 0))
    {
        sameContent = true;
    }

    // Determine expected length of developer ID

    uint8_t devIdLen = ENV_developerId.length();

    // Determine if old version is a devel version compatible with this tool

    if (memcmp(&dstFileContent[revOffset], STR_DEV.data(), STR_DEV.size()) != 0)
    {
        return;
    }

    uint16_t idxDate  = revOffset + STR_DEV.size();
    uint16_t idxLimit = idxDate + ENV_dateString.length();

    uint16_t idx = idxDate;
    for (; idx < idxLimit; idx++)
    {
        if (dstFileContent[idx] < '0' || dstFileContent[idx] > '9')
        {
            return;
        }
    }

    if (dstFileContent[idx]                != '.' ||
        dstFileContent[idx + devIdLen + 1] != '.' ||
        dstFileContent[idx + devIdLen + 2]  < '0' ||
        dstFileContent[idx + devIdLen + 2]  > '9' ||
        dstFileContent[idx + devIdLen + 3] != 0)
    {
        return;
    }

    // Retrieve release data

    if (memcmp(&dstFileContent[idx + 1], ENV_developerId.data(), ENV_developerId.size()) != 0)
    {
        return; // different developer
    }

    sameDeveloper = true;

    if (memcmp(&dstFileContent[idxDate], ENV_dateString.data(), ENV_dateString.size()) != 0)
    {
        return; // different date
    }    
    
    sameDate = true;
    oldDailyRelId = dstFileContent[idx + devIdLen + 2] - '0';
}

void ROMFile::embedRevisionStr(const std::string &newRevisionStr)
{
    std::string revStr = newRevisionStr;

    while (revStr.length() < 16) revStr = revStr + '\0';

    memcpy(&srcFileContent[descPtr->signatureOffset + 3],
           revStr.data(), revStr.size());
}

void ROMFile::save()
{
    const std::string outFileNamePath = CMD_outDir + DIR_SEPARATOR + baseFileName;

    // Print out file name and metadata

    std::string spacing;
    spacing.resize(GLOBAL_maxFileNameLen + 4 - baseFileName.length(), ' ');

    std::cout << "    " << outFileNamePath << spacing << descPtr->romTypeName;

    if (sameContent)
    {
        spacing.resize(10 - descPtr->romTypeName.length());
        std::cout << spacing << "(unchanged)";
    }

    std::cout << "\n";

    std::ofstream outFile;
    outFile.open(outFileNamePath, std::ios::out | std::ios::binary | std::ios::trunc);

    if (!outFile.good()) ERROR(std::string("unable to open output file '") + outFileNamePath + "'");

    outFile.write((char *) srcFileContent.data(), srcFileContent.size());

    if (!outFile.good()) ERROR(std::string("unable to write file '") + outFileNamePath + "'");
    outFile.close();   
}
