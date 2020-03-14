//
// Utility to patch the character generator file to create
// font for Mega65 native mode and possibly other uses
//

#include "common.h"

#include <unistd.h>

#include <fstream>
#include <vector>

//
// Command line settings
//

std::string CMD_inFile  = "chargen.rom";
std::string CMD_outFile = "chargen-native.rom";
std::string CMD_name    = "CHARGEN";

//
// Common helper functions
//

void printUsage()
{
    std::cout << "\n" <<
        "usage: patch_chargen [-i <in file>] [-o <out file>] [-n name]" << "\n\n";
}

void printBanner()
{
    printBannerLineTop();
    std::cout << "// Generating patched font '" << CMD_name << "'" << "\n";
    printBannerLineBottom();
}

//
// Top-level functions
//

void parseCommandLine(int argc, char **argv)
{
    int opt;

    // Retrieve command line options

    while ((opt = getopt(argc, argv, "i:o:n:")) != -1)
    {
        switch(opt)
        {
            case 'i': CMD_inFile    = optarg; break;
            case 'o': CMD_outFile   = optarg; break;
            case 'n': CMD_name      = optarg; break;
            default: printUsage(); ERROR();
        }
    }
}

//
// Font processing
//

void processFont()
{
	std::vector<uint8_t> fileContent;
	
    // Read the source file

    std::ifstream srcFile;
    srcFile.open(CMD_inFile, std::ios::in | std::ios::binary | std::ios::ate);

    if (!srcFile.good()) ERROR(std::string("unable to open ROM file '") + CMD_inFile + "'");
	
    auto srcSize = srcFile.tellg();
    if (srcSize != 4096) ERROR(std::string("incorrect size of ROM file '") + CMD_inFile + "'");

	std::vector<uint8_t> srcFileContent;

    fileContent.resize(srcSize);
    srcFile.seekg (0, srcFile.beg);
    srcFile.read((char *) fileContent.data(), fileContent.size());

    if (!srcFile.good()) ERROR(std::string("unable to read ROM file '") + CMD_inFile + "'");
    srcFile.close();

	// Patch the font

	for (uint8_t idx = 0; idx < 8; idx++)
	{
        // VENDOR + M - 2px width on C64

		fileContent[0x67 * 8 +    0 + idx] = 0b00000001; // normal
		fileContent[0x67 * 8 + 2048 + idx] = 0b00000001; // upper/lower case
        fileContent[0xE7 * 8 +    0 + idx] = 0b11111110; // inversed
        fileContent[0xE7 * 8 + 2048 + idx] = 0b11111110; // upper/lower case, inversed

        // VENDOR + G - 2px width on C64

		fileContent[0x65 * 8 +    0 + idx] = 0b10000000; // normal
		fileContent[0x65 * 8 + 2048 + idx] = 0b10000000; // upper/lower case
        fileContent[0xE5 * 8 +    0 + idx] = 0b01111111; // inversed
        fileContent[0xE5 * 8 + 2048 + idx] = 0b01111111; // upper/lower case, inversed

        // PI character restoration for upper/lower case set

        fileContent[0x5E * 8 + 2048 + idx] = fileContent[0x5E * 8 + idx];
        fileContent[0xDE * 8 + 2048 + idx] = fileContent[0xDE * 8 + idx];
	}
	
    // Remove old file

    unlink(CMD_outFile.c_str());
	
	// Save the patched font
	
    std::ofstream outFile(CMD_outFile, std::fstream::out | std::ios::binary | std::fstream::trunc);
    if (!outFile.good()) ERROR(std::string("can't open oputput file '") + CMD_outFile + "'");

	outFile.write((const char*) fileContent.data(), fileContent.size());
	
    if (!outFile.good())
    {
    	outFile.close();
    	unlink(CMD_outFile.c_str());
    	ERROR(std::string("can't write oputput file '") + CMD_outFile + "'");
    }

    outFile.close();	
}

//
// Main function
//

int main(int argc, char **argv)
{
    parseCommandLine(argc, argv);

    printBanner();
    processFont();

    return 0;
}
