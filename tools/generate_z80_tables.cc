//
// Utility to generate various tables for the Z80 emulation
//

#include "common.h"

#include <unistd.h>

#include <cstdio>
#include <fstream>
#include <iomanip>

// Global variables

uint8_t GLOBAL_Parity[256];

//
// Constants
//

static const uint8_t Z80_SF = 0x80; // sign 
static const uint8_t Z80_ZF = 0x40; // zero
static const uint8_t Z80_YF = 0x20; // bit 5 result
static const uint8_t Z80_HF = 0x10; // half carry
static const uint8_t Z80_XF = 0x08; // bit 3 result
static const uint8_t Z80_PF = 0x04; // parity
static const uint8_t Z80_VF = 0x04; // overflow
static const uint8_t Z80_NF = 0x02; // add/subtract
static const uint8_t Z80_CF = 0x01; // carry



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
	std::string outStr = "!macro PUT_Z80_FTABLE_PARITY {\n";

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
			GLOBAL_Parity[idx] = 4;
			outStr += std::string("\t!byte %00000100 ; ") + idxInBin + "\n";
		}
		else
		{
			GLOBAL_Parity[idx] = 0;
			outStr += std::string("\t!byte %00000000 ; ") + idxInBin + "\n";
		}
	}

	return outStr + "}\n\n\n";
} 

std::string generateDisplacementTable(void)
{
	std::stringstream outStr;
	outStr << "!macro PUT_Z80_OTABLE_DISPLACEMENT {\n";

	for (uint16_t idx = 0; idx < 0x100; idx++)
	{
		outStr << "\t!byte $" << std::hex << std::setw(2) << std::setfill('0');

		if (idx < 128)
		{
		    outStr << int(idx + 128) << "\n";
		}
		else
		{
		    outStr << int(idx - 128) << "\n";
		}
	}

	return outStr.str() + "}\n\n\n";
}

std::string generateIncTable(void)
{
	std::stringstream outStr;
	outStr << "!macro PUT_Z80_FTABLE_INC {\n";

	for (uint16_t idx = 0; idx < 0x100; idx++)
	{
		uint8_t flags = 0;

		if (idx >= 0x7F && idx != 0xFF) flags |= Z80_SF; // for negative result
		if (idx == 0xFF)                flags |= Z80_ZF; // for result equal 0
		if ((idx & 0x0F) == 0x0F)       flags |= Z80_HF;
		if (idx == 0x7F)                flags |= Z80_VF;

		outStr << "\t!byte $" << std::hex << std::setw(2) << std::setfill('0') << int(flags) << "\n";
	}

	return outStr.str() + "}\n\n\n";
}

std::string generateDecTable(void)
{
	std::stringstream outStr;
	outStr << "!macro PUT_Z80_FTABLE_DEC {\n";

	for (uint16_t idx = 0; idx < 0x100; idx++)
	{
		uint8_t flags = Z80_NF;

		if (idx >= 0x81 || idx == 0x00) flags |= Z80_SF; // for negative result
		if (idx == 0x01)                flags |= Z80_ZF; // for result equal 0
		if ((idx & 0x0F) == 0x00)       flags |= Z80_HF;
		if (idx == 0x80)                flags |= Z80_VF;

		outStr << "\t!byte $" << std::hex << std::setw(2) << std::setfill('0') << int(flags) << "\n";
	}

	return outStr.str() + "}\n\n\n";
} 

std::string generateAndTable(void)
{
	std::stringstream outStr;
	outStr << "!macro PUT_Z80_FTABLE_AND {\n";

	for (uint16_t idx = 0; idx < 0x100; idx++)
	{
		uint8_t flags = Z80_HF | GLOBAL_Parity[idx];
		if (idx >= 0x80) flags |= Z80_SF; // for negative result
		if (idx == 0)    flags |= Z80_ZF; // for result equal 0
		if (idx & 0x08)  flags |= Z80_XF; // 3rd bit of the result
		if (idx & 0x20)  flags |= Z80_YF; // 5th bit of the result

		outStr << "\t!byte $" << std::hex << std::setw(2) << std::setfill('0') << int(flags) << "\n";
	}

	return outStr.str() + "}\n\n\n";
}

std::string generateInOrXorTable(void)
{
	std::stringstream outStr;
	outStr << "!macro PUT_Z80_FTABLE_IN_OR_XOR {\n";

	for (uint16_t idx = 0; idx < 0x100; idx++)
	{
		uint8_t flags = GLOBAL_Parity[idx];
		if (idx >= 0x80) flags |= Z80_SF; // for negative result
		if (idx == 0)    flags |= Z80_ZF; // for result equal 0
		if (idx & 0x08)  flags |= Z80_XF; // 3rd bit of the result
		if (idx & 0x20)  flags |= Z80_YF; // 5th bit of the result

		outStr << "\t!byte $" << std::hex << std::setw(2) << std::setfill('0') << int(flags) << "\n";
	}

	return outStr.str() + "}\n\n\n";
} 

std::string generateAddAdcTable(void)
{
	std::stringstream outStr;
	outStr << "!macro PUT_Z80_FTABLE_ADD_ADC {\n";

	for (uint16_t idx = 0; idx < 0x100; idx++)
	{
		uint8_t flags = 0;
		if (idx >= 0x80) flags |= Z80_SF; // for negative result
		if (idx == 0)    flags |= Z80_ZF; // for result equal 0
		if (idx & 0x08)  flags |= Z80_XF; // 3rd bit of the result
		if (idx & 0x20)  flags |= Z80_YF; // 5th bit of the result

		outStr << "\t!byte $" << std::hex << std::setw(2) << std::setfill('0') << int(flags) << "\n";
	}

	return outStr.str() + "}\n\n\n";
} 

std::string generateSubSbcTable(void)
{
	std::stringstream outStr;
	outStr << "!macro PUT_Z80_FTABLE_SUB_SBC {\n";

	for (uint16_t idx = 0; idx < 0x100; idx++)
	{
		uint8_t flags = Z80_NF;
		if (idx >= 0x80) flags |= Z80_SF; // for negative result
		if (idx == 0)    flags |= Z80_ZF; // for result equal 0
		if (idx & 0x08)  flags |= Z80_XF; // 3rd bit of the result
		if (idx & 0x20)  flags |= Z80_YF; // 5th bit of the result

		outStr << "\t!byte $" << std::hex << std::setw(2) << std::setfill('0') << int(flags) << "\n";
	}

	return outStr.str() + "}\n\n\n";
} 

std::string generateCpTable(void)
{
	std::stringstream outStr;
	outStr << "!macro PUT_Z80_FTABLE_CP {\n";

	for (uint16_t idx = 0; idx < 0x100; idx++)
	{
		uint8_t flags = Z80_NF;
		if (idx >= 0x80) flags |= Z80_SF; // for negative result
		if (idx == 0)    flags |= Z80_ZF; // for result equal 0

		outStr << "\t!byte $" << std::hex << std::setw(2) << std::setfill('0') << int(flags) << "\n";
	}

	return outStr.str() + "}\n\n\n";
} 

std::string generateNegTable(void)
{
	std::stringstream outStr;
	outStr << "!macro PUT_Z80_FTABLE_NEG {\n";

	for (uint16_t idx = 0; idx < 0x100; idx++)
	{
		uint8_t flags = Z80_NF;
		if (0 - idx >= 0x80)  flags |= Z80_SF;
		if (idx == 0)         flags |= Z80_ZF;
		if (idx != 0)         flags |= Z80_HF | Z80_CF;
		if (idx == 0x80)      flags |= Z80_VF;
		if ((0 - idx) & 0x08) flags |= Z80_XF;
		if ((0 - idx) & 0x20) flags |= Z80_YF;

		outStr << "\t!byte $" << std::hex << std::setw(2) << std::setfill('0') << int(flags) << "\n";
	}

	return outStr.str() + "}\n\n\n";
} 


typedef struct FlagsDAA
{
	uint8_t N = 0; // input/output
	uint8_t C = 0; // input/output
	uint8_t H = 0; // input/output
	uint8_t S = 0; // output
	uint8_t Z = 0; // output
	uint8_t P = 0; // output
	uint8_t X = 0; // output
	uint8_t Y = 0; // output

} Flags;


uint8_t calculateDAA(FlagsDAA &flags, uint8_t A)
{
	// Based on code by Rui Ribeiro, see the discussion here:
	// https://stackoverflow.com/questions/8119577/z80-daa-instruction

	int t = 0;
    
	if (flags.H || ((A & 0xF) > 9)) t++;
    
	if (flags.C || (A > 0x99))
	{
		t += 2;
		flags.C = 1;
	}

	if (flags.N && !flags.H)
	{	
    	flags.H = 0;
	}
	else
	{
    	if (flags.N && flags.H)
			flags.H = (((A & 0x0F)) < 6);
		else
			flags.H = ((A & 0x0F) >= 0x0A);
	}
    
    switch (t)
	{
		case 1: A += (flags.N) ? 0xFA : 0x06; break; // -6:6
		case 2: A += (flags.N) ? 0xA0 : 0x60; break; // -0x60:0x60
	    case 3: A += (flags.N) ? 0x9A : 0x66; break; // -0x66:0x66
    }

    flags.S = (A & 0x80);
	flags.Z = !A;
	flags.P = GLOBAL_Parity[A];
	flags.X = A & 0x20;
	flags.Y = A & 0x08;

	return A;
}

std::string generateDaaTables()
{
	std::string outStr;

	for (uint8_t NF : {0, 1}) for (uint8_t CF : {0, 1}) for (uint8_t HF : {0, 1})
	{
		std::string keyStr = std::string("_") + (NF ? "N1" : "N0") + (CF ? "C1" : "C0") + (HF ? "H1" : "H0");

		std::stringstream outStrF;
		outStrF << "!macro PUT_Z80_FTABLE_DAA" << keyStr << "  {\n";

		std::stringstream outStrO;
		outStrO << "!macro PUT_Z80_OTABLE_DAA" << keyStr << "  {\n";

		for (uint16_t idx = 0; idx < 0x100; idx++)
		{
			FlagsDAA flags;
			if (NF) flags.N = 1;
			if (CF) flags.C = 1;
			if (HF) flags.H = 1;

			outStrO << "\t!byte $" << std::hex << std::setw(2) << std::setfill('0') << (int) calculateDAA(flags, idx) << "\n";			
			
			int fResult = (flags.N ? Z80_NF : 0) +
			              (flags.C ? Z80_CF : 0) +
			              (flags.H ? Z80_HF : 0) +
			              (flags.S ? Z80_SF : 0) +
			              (flags.P ? Z80_PF : 0) +
			              (flags.Z ? Z80_ZF : 0) +
			              (flags.X ? Z80_XF : 0) +
			              (flags.Y ? Z80_YF : 0);
			
			outStrF << "\t!byte $" << std::hex << std::setw(2) << std::setfill('0') << fResult << "\n";		
		}

		outStr += outStrF.str() + "}\n\n\n" + outStrO.str() + "}\n\n\n";
	}

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

	outFile << generateParityTable();        // always put this one first!
	outFile << generateDisplacementTable();
	outFile << generateIncTable();
	outFile << generateDecTable();
	outFile << generateAndTable();
	outFile << generateInOrXorTable();
	outFile << generateAddAdcTable();
	outFile << generateSubSbcTable();
	outFile << generateCpTable();
	outFile << generateNegTable();
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
