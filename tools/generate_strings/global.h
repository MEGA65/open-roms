
#ifndef GLOBAL_H
#define GLOBAL_H

#include <map>
#include <vector>

#include "common.h"


//
// Command line settings
//

extern std::string CMD_outFile;
extern std::string CMD_cnfFile;

//
// Options from the configuration file
//

extern std::map<std::string, bool> GLOBAL_ConfigOptions;

//
// Type definition for strings/keywords to generate
//

typedef struct StringEntry
{
    bool        enabledSTD;     // whether enabled for standard build
    bool        enabledCRT;     // whether enabled for standard build with extra ROM cartridge
    bool        enabledM65;     // whether enabled for Mega 65 build
    bool        enabledU64;     // whether enabled for Ultimate 64 build
    bool        enabledX16;     // whether enabled for Commander X16 build
    std::string alias;          // alias, for the assembler
    std::string string;         // string/token
    uint8_t     abbrevLen = 0;  // length of token abbreviation
} StringEntry;

enum class ListType
{
    KEYWORDS,
    STRINGS_BASIC,
    DICTIONARY                  // for internal use only
};

typedef struct StringEntryList
{
    ListType                 type;
    std::string              name;
    std::vector<StringEntry> list;
} StringEntryList;

typedef std::vector<uint8_t>       StringEncoded;
typedef std::vector<StringEncoded> StringEncodedList;

//
// Open ROMs string definitions
//

extern const StringEntryList GLOBAL_Keywords_V2;
extern const StringEntryList GLOBAL_Keywords_01;
extern const StringEntryList GLOBAL_Keywords_04;
extern const StringEntryList GLOBAL_Keywords_06;
extern const StringEntryList GLOBAL_Errors;
extern const StringEntryList GLOBAL_MiscStrings;


#endif // GLOBAL_H
