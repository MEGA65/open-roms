//
// Utility to generate various tables for the Z80 emulation
//

#include "common.h"

#include <unistd.h>

#include <cstdio>
#include <fstream>
#include <iomanip>

//
// Command line settings
//

std::string CMD_outFile = "out.s";

//
// Common helper functions
//

void printUsage()
{
    std::cout << "\n" <<
        "usage: generate_z80_tables [-o <out file>]" << "\n\n";
}

void printBanner()
{
    printBannerLineTop();
    std::cout << "// Generating Z80 emulation tables" << "\n";
    printBannerLineBottom();
}

//
// Top-level functions
//

void parseCommandLine(int argc, char **argv)
{
    int opt;

    // Retrieve command line options

    while ((opt = getopt(argc, argv, "o:")) != -1)
    {
        switch(opt)
        {
            case 'o': CMD_outFile   = optarg; break;
            default: printUsage(); ERROR();
        }
    }
}

//
// Constants generation
//

std::string generateParityTable(void)
{
	std::string outStr = "!macro PUT_Z80_TABLE_PARITY {\n";;

	for (uint16_t idx = 0; idx < 0x100; idx++)
	{
		std::string idxInBin = "";

		bool even = false;
		for (uint16_t bit = 128; bit != 0; bit /= 2)
		{
			if ((idx & bit) != 0)
			{
				idxInBin += "1";
                even = !even;
			}
			else
			{
				idxInBin += "0";			
			}
		}

		if (even)
		{
			outStr += std::string("\t!byte %00000100 ; ") + idxInBin + "\n";
		}
		else
		{
			outStr += std::string("\t!byte %00000000 ; ") + idxInBin + "\n";
		}
	}

	return outStr + "}\n\n\n";;
} 

std::string generateDaaTables()
{
	std::string outStr;

	// iterate by SF, HF, CF flags

	// XXX
	// Check code by Rui Ribeiro, see https://stackoverflow.com/questions/8119577/z80-daa-instruction

	return outStr;
}

void writeTables()
{
    // Remove old file

    unlink(CMD_outFile.c_str());

    // Open output file for writing

    std::ofstream outFile(CMD_outFile, std::fstream::out | std::fstream::trunc);
    if (!outFile.good()) ERROR(std::string("can't open oputput file '") + CMD_outFile + "'");

    // Write header

    outFile << "//\n// Generated file - do not edit\n//\n\n";

    // Write tables

	outFile << generateParityTable();
	outFile << generateDaaTables();

	// XXX

    // Close the file
   
    outFile.close();

    std::cout << std::string("Z80 emulation tables written to: ") + CMD_outFile + "\n\n";
}

//
// Main function
//

int main(int argc, char **argv)
{
    parseCommandLine(argc, argv);

    printBanner();
    writeTables();

    return 0;
}
