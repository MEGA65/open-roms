//
// Utility to generate various floating points constants
// in a Commodore-specific variable format
//

#include "common.h"

#include <unistd.h>

#include <cmath>
#include <cstdio>
#include <fstream>
#include <iomanip>
#include <vector>

//
// Basic types definition
//

typedef struct ConstEntry
{
	ConstEntry(const std::string &constName, double constValue) :
		constName(constName),
		constValue(constValue),
		outString(".error \"not generated\"")
	{
	};

	const std::string constName;
	const double      constValue;

	std::string       outString;

} ConstEntry;

//
// Constants to output
//

std::vector<ConstEntry> GLOBAL_constants =
{
	// Constants from:
	// - https://www.c64-wiki.com/wiki/BASIC-ROM
	// Computes Mapping the Commodore 64, pages 103, 105, 113, 114, 116

	ConstEntry(   "QUARTER",      0.25            ),
	ConstEntry(      "HALF",      0.5             ),
	ConstEntry(  "NEG_HALF",     -0.5             ),
	ConstEntry(       "ONE",      1.0             ),
	ConstEntry(       "TEN",     10.0             ),
	ConstEntry( "NEG_32768", -32768.0             ),

	ConstEntry(   "HALF_PI", M_PI / 2.0           ),
	ConstEntry(        "PI", M_PI                 ),
	ConstEntry( "DOUBLE_PI", M_PI * 2.0           ),
	ConstEntry(     "SQR_2", std::sqrt(2.0)       ),
	ConstEntry( "INV_SQR_2", 1.0 / std::sqrt(2.0) ),
	ConstEntry(     "LOG_2", std::log(2.0)        ),
	ConstEntry( "INV_LOG_2", 1.0 / std::log(2.0)  ),

	// Constants for exp approximation, taken from https://www.c64-wiki.com/wiki/POLY1
	// original source is probably "Computer Approximations" by John Fraser Hart et al. (ISBN 0-88275-642-7)
	ConstEntry( "POLY_EXP_1", 2.1498763701e-5 ),
	ConstEntry( "POLY_EXP_2", 1.4352314037e-4 ),
	ConstEntry( "POLY_EXP_3", 1.3422634825e-3 ),
	ConstEntry( "POLY_EXP_4", 9.6140170135e-3 ),
	ConstEntry( "POLY_EXP_5", 5.5505126860e-2 ),
	ConstEntry( "POLY_EXP_6", 0.24022638460   ),
	ConstEntry( "POLY_EXP_7", 0.69314718618   ),
	ConstEntry( "POLY_EXP_8", 1.0             ),

    // Constants for sin approximation, source as for exp above
	ConstEntry( "POLY_SIN_1", -14.381390672 ),
	ConstEntry( "POLY_SIN_2", 42.007797122  ),
	ConstEntry( "POLY_SIN_3", -76.704170257 ),
	ConstEntry( "POLY_SIN_4", 81.605223686  ),
	ConstEntry( "POLY_SIN_5", -41.341702104 ),
	ConstEntry( "POLY_SIN_6", 6.2831853069  ),

    // Constants for log approximation, source as for exp above
    ConstEntry( "POLY_LOG_1", 0.43425594189   ),
    ConstEntry( "POLY_LOG_2", 0.57658454124   ),
    ConstEntry( "POLY_LOG_3", 0.96180075919   ),
    ConstEntry( "POLY_LOG_4", 2.8853900731    ),

    // Constants for atn approximation, source as for exp above
    ConstEntry( "POLY_ATN_1", -6.8479391189e-4 ),
    ConstEntry( "POLY_ATN_2", 4.8509421558e-3  ),
    ConstEntry( "POLY_ATN_3", -1.6111701843e-2 ),
    ConstEntry( "POLY_ATN_4", 3.4209638048e-2  ),
    ConstEntry( "POLY_ATN_5", -5.4279132761e-2 ),
    ConstEntry( "POLY_ATN_6", 7.2457196540e-2  ),
    ConstEntry( "POLY_ATN_7", -8.9802395378e-2 ),
    ConstEntry( "POLY_ATN_8", 0.11093241343    ),
    ConstEntry( "POLY_ATN_9", -0.14283980767   ),
    ConstEntry( "POLY_ATN_10", 0.19999912049   ),
    ConstEntry( "POLY_ATN_11", -0.33333331568  ),
    ConstEntry( "POLY_ATN_12", 1.0             ),
};

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
        "usage: generate_constants [-o <out file>]" << "\n\n";
}

void printBanner()
{
    printBannerLineTop();
    std::cout << "// Generating floating point constants" << "\n";
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

std::string toAssemblerString(const std::string &constName, double constValue)
{
	uint8_t outFloat[5] = { 0 };

	// Retrieve mantissa nad exponent

	int    exponent = -0x80;
	double mantissa = frexp(std::abs(constValue), &exponent);
	
	// Round the mantissa to output format precission

	const double coeff = 256.0 * 256.0 * 256.0 * 256.0;

	double intPart;
	if (modf(mantissa * coeff, &intPart) >= 0.5)
	{
		mantissa = (intPart + 1.0) / coeff;
	}
	else
	{
		mantissa = intPart / coeff;
	}

	if (mantissa >= 1.0)
	{
		mantissa = 0.5;
		exponent++;
	}

	// Add a bias to exponent

	exponent += 0x80;

	// Check if output format can contain such a number

	if (exponent > 0xFF)
	{
		ERROR(std::string("const '")  + constName + "' abs value too large");
	}
	else if (exponent <= 0)
	{
		ERROR(std::string("const '")  + constName + "' abs value too small");
	}

	// Set output constant exponent

	outFloat[0] = exponent;

	// Set output constant mantissa

	for (uint8_t idxByte = 1; idxByte <= 4; idxByte++)
	{
		for (uint8_t idxBit = 0; idxBit <= 7; idxBit++)
		{
			outFloat[idxByte] = outFloat[idxByte] << 1;
			if (mantissa >= 0.5)
			{
				outFloat[idxByte]++;
				mantissa -= 0.5;
			}

			mantissa *= 2;
		}
	}

	if (mantissa > 0.0)     ERROR(std::string("const '")  + constName + "' export error");
	if (outFloat[1] < 0x80) ERROR(std::string("const '")  + constName + "' not normalized");

	// Set output constant sign

	if (constValue >= 0.0)
	{
		outFloat[1] = outFloat[1] & 0x7F;
	}

	// Return the output constant as string for assembler

	char buf[256] = { 0 };
	snprintf(buf, sizeof(buf), "$%02X, $%02X, $%02X, $%02X, $%02X    // %22.10f",
		outFloat[0],
		outFloat[1],
		outFloat[2],
		outFloat[3],
		outFloat[4],
		constValue);

	std::string outDef = std::string("\n!macro PUT_CONST_") + constName + " {\n\t!byte " + buf + "\n}\n";

	return outDef;
} 


void writeConstants()
{
	// Convert constants to assembler strings

	for (auto &entry : GLOBAL_constants)
	{
		entry.outString = toAssemblerString(entry.constName, entry.constValue);
	}

    // Remove old file

    unlink(CMD_outFile.c_str());

    // Open output file for writing

    std::ofstream outFile(CMD_outFile, std::fstream::out | std::fstream::trunc);
    if (!outFile.good()) ERROR(std::string("can't open oputput file '") + CMD_outFile + "'");

    // Write header

    outFile << "//\n// Generated file - do not edit\n//\n\n";

    // Write constants

	for (auto &entry : GLOBAL_constants)
	{
		outFile << entry.outString;
	}

    if (!outFile.good())
    {
    	outFile.close();
    	unlink(CMD_outFile.c_str());
    	ERROR(std::string("can't write oputput file '") + CMD_outFile + "'");
    }

    // Close the file
   
    outFile.close();

    std::cout << std::string("floating point constants written to: ") + CMD_outFile + "\n\n";
}


//
// Main function
//

int main(int argc, char **argv)
{
    parseCommandLine(argc, argv);

    printBanner();
    writeConstants();

    return 0;
}
