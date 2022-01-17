//
// Utility to generate compressed messages and BASIC keywords
//

#include "global.h"

#include "dataset.h"

#include <fstream>
#include <regex>
#include <unistd.h>


void printUsage()
{
    std::cout << "\n" <<
        "usage: generate_strings [-o <out file>] [-c <configuration file>]" << "\n\n";
}

void printBanner()
{
    printBannerLineTop();
    std::cout << "// Generating compressed messages and BASIC tokens\n";
    printBannerLineBottom();
}

void parseCommandLine(int argc, char **argv)
{
    int opt;

    // Retrieve command line options

    while ((opt = getopt(argc, argv, "o:c:")) != -1)
    {
        switch(opt)
        {
            case 'o': CMD_outFile   = optarg; break;
            case 'c': CMD_cnfFile   = optarg; break;
            default: printUsage(); ERROR();
        }
    }
}

void parseConfigFile()
{
    GLOBAL_ConfigOptions.clear();
   
    // Open the configuration file
   
    std::ifstream cnfFile;
    cnfFile.open(CMD_cnfFile);
    if (!cnfFile.good()) ERROR("unable to open config file");
   
    // Parse the file
   
    size_t lineNum = 0;
    while (!cnfFile.eof())
    {
        lineNum++;
        std::string workStr;
       
        // Read a single line, remove leading spaces and tabs

        std::getline(cnfFile, workStr);
        if (cnfFile.bad()) ERROR("error reading configuration file");
        workStr = std::regex_replace(workStr, std::regex("^[ \t]+"), "");

        // Split the line into tokens

        std::vector<std::string> tokens;

        std::istringstream workStream(workStr);
        std::string token;
        while(std::getline(workStream, token, ' '))
        {
            if (token.empty()) continue;
            tokens.push_back(token);
        }
        if (tokens.empty()) continue;

        // Only accept lines which are boolean config options set to YES

        if (tokens.size() < 4 ||
            tokens[0].compare(";;")       != 0 ||
            tokens[1].compare("#CONFIG#") != 0 ||
            tokens[3].compare("YES")      != 0)
        {
            continue;
        }

        // Add definitin to config option map

        if (tokens[2].empty()) ERROR(std::string("error parsing config file - line ") + std::to_string(lineNum));

        GLOBAL_ConfigOptions[tokens[2]] = true;
    }
   
    cnfFile.close();
}

void writeStrings()
{
    std::string outputString;
   
    if (GLOBAL_ConfigOptions["PLATFORM_COMMANDER_X16"])
    {
        DataSetX16 dataSetX16;

        // Add input data to computation objects
       
        dataSetX16.addStrings(GLOBAL_Keywords_V2);
        dataSetX16.addStrings(GLOBAL_Keywords_01);
        dataSetX16.addStrings(GLOBAL_Errors);
        dataSetX16.addStrings(GLOBAL_MiscStrings);

        // Retrieve the results
       
        outputString = dataSetX16.getOutput();
    }
    else if (GLOBAL_ConfigOptions["PLATFORM_COMMODORE_64"] && GLOBAL_ConfigOptions["MB_M65"])
    {
        DataSetM65 dataSetM65;

        // Add input data to computation objects

        dataSetM65.addStrings(GLOBAL_Keywords_V2);
        dataSetM65.addStrings(GLOBAL_Keywords_01);
        dataSetM65.addStrings(GLOBAL_Keywords_04);
        dataSetM65.addStrings(GLOBAL_Keywords_06);
        dataSetM65.addStrings(GLOBAL_Errors);
        dataSetM65.addStrings(GLOBAL_MiscStrings);
       
        // Retrieve the results
       
        outputString = dataSetM65.getOutput();
    }
    else if (GLOBAL_ConfigOptions["PLATFORM_COMMODORE_64"] && GLOBAL_ConfigOptions["ROM_CRT"])
    {
        DataSetCRT dataSetCRT;

        // Add input data to computation objects

        dataSetCRT.addStrings(GLOBAL_Keywords_V2);
        dataSetCRT.addStrings(GLOBAL_Keywords_01);
        dataSetCRT.addStrings(GLOBAL_Errors);
        dataSetCRT.addStrings(GLOBAL_MiscStrings);

        // Retrieve the results

        outputString = dataSetCRT.getOutput();   
    }
    else if (GLOBAL_ConfigOptions["PLATFORM_COMMODORE_64"] && GLOBAL_ConfigOptions["MB_U64"])
    {
        DataSetU64 dataSetU64;

        // Add input data to computation objects

        dataSetU64.addStrings(GLOBAL_Keywords_V2);
        dataSetU64.addStrings(GLOBAL_Keywords_01);
        dataSetU64.addStrings(GLOBAL_Errors);
        dataSetU64.addStrings(GLOBAL_MiscStrings);
       
        // Retrieve the results
       
        outputString = dataSetU64.getOutput();
    }
    else if (GLOBAL_ConfigOptions["PLATFORM_COMMODORE_64"])
    {
        DataSetSTD dataSetSTD;

        // Add input data to computation objects

        dataSetSTD.addStrings(GLOBAL_Keywords_V2);
        dataSetSTD.addStrings(GLOBAL_Keywords_01);
        dataSetSTD.addStrings(GLOBAL_Errors);
        dataSetSTD.addStrings(GLOBAL_MiscStrings);

        // Retrieve the results

        outputString = dataSetSTD.getOutput();   
    }
    else
    {
        ERROR("unable to determine string set");
    }
   
    // Remove old file

    unlink(CMD_outFile.c_str());

    // Open output file for writing

    std::ofstream outFile(CMD_outFile, std::fstream::out | std::fstream::trunc);
    if (!outFile.good()) ERROR(std::string("can't open oputput file '") + CMD_outFile + "'");

    // Write header

    outFile << ";\n; Generated file - do not edit\n;";

    // Write packed strings

    outFile << std::endl << std::endl;
    outFile << outputString;
    outFile << std::endl << std::endl;

    // Close the file
  
    outFile.close();

    std::cout << std::string("compressed strings written to: '") + CMD_outFile + "'\n\n";
}

//
// Main function
//

int main(int argc, char **argv)
{
    printBanner();
    parseCommandLine(argc, argv);

    parseConfigFile();

    writeStrings();

    return 0;
}
