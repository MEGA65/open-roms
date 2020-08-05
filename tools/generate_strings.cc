//
// Utility to generate compressed messages and BASIC keywords
//

#include "common.h"

#include <unistd.h>

#include <algorithm>
#include <fstream>
#include <iomanip>
#include <regex>
#include <sstream>
#include <map>
#include <vector>

//
// Command line settings
//

std::string CMD_outFile = "out.s";
std::string CMD_cnfFile = "";

//
// Type definition for strings/keywords to generate
//

typedef struct StringEntry
{
    bool        enabledSTD;     // whether enabled for standard build
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

// http://www.classic-games.com/commodore64/cbmtoken.html
// https://www.c64-wiki.com/wiki/BASIC_token

// BASIC keywords - V2 dialect

/*
  The URLs here provide examples of other BASIC dialects that include the specified commands
  or keywords.
  All except VERIFY are known with certainty to be part of other BASIC dialects, and thus
  cannot be subject to copyright infringement when implemented on a C64.

  The VERIFY Command however appears in other programming languages, and as a single word,
  is the obvious complement to LOAD and SAVE when considering the following storage functions:

  1. Load a file from storage into memory.
  2. Save a file from memory to storage.
  3. Verify that a file has been correctly written from memory to storage.

  Note that verify is the key verb in the behaviour of this function. Therefore it is the
  obvious choice for the name for such a function, taking into account the convention of
  LOAD and SAVE. Indeed, that this is so is highlighted by the fact that it was used in the
  C64 ROM.  Therefore there is no exercise of creativity here, and a reasonable person would
  likely select this name independently. Also, single words cannot be copyright.

  Further, the list is a list of facts, and thus not copyrightable.

  We sourced the list from a public source, https://www.c64-wiki.com/wiki/BASIC, which has
  been public on the internet for a long time, as have many other similar sources.
  That website offers the page under the GFDL license, and we can therefore take the list
  under those license terms if we wish, should the need arise.

  Note that in providing these justifications above, we do not in any way acknowledge that
  without these conditions that the BASIC keyword list could be copyright, but provide this
  information as a further layer of defence against any claims that it could somehow
  infringe on the copyrights of the C64/C65/C128 etc ROMs.
*/

const StringEntryList GLOBAL_Keywords_V2 = { ListType::KEYWORDS, "keywords_V2",
{
    // STD    M65    U64    X16
    { true,  true,  true,  true,  "KV2_80",   "END",        2 }, // https://www.landsnail.com/a2ref.htm
    { true,  true,  true,  true,  "KV2_81",   "FOR",        2 }, // https://www.landsnail.com/a2ref.htm
    { true,  true,  true,  true,  "KV2_82",   "NEXT",       2 }, // https://www.landsnail.com/a2ref.htm
    { true,  true,  true,  true,  "KV2_83",   "DATA",       2 }, // https://www.landsnail.com/a2ref.htm
    { true,  true,  true,  true,  "KV2_84",   "INPUT#",     2 }, // https://www.atariarchives.org/creativeatari/Using_Disks_With_Atari_Basic.php
    { true,  true,  true,  true,  "KV2_85",   "INPUT",      0 }, // https://www.landsnail.com/a2ref.htm
    { true,  true,  true,  true,  "KV2_86",   "DIM",        2 }, // https://www.landsnail.com/a2ref.htm
    { true,  true,  true,  true,  "KV2_87",   "READ",       2 }, // https://www.landsnail.com/a2ref.htm
    { true,  true,  true,  true,  "KV2_88",   "LET",        2 }, // https://en.wikipedia.org/wiki/Atari_BASIC
    { true,  true,  true,  true,  "KV2_89",   "GOTO",       2 }, // https://www.landsnail.com/a2ref.htm
    { true,  true,  true,  true,  "KV2_8A",   "RUN",        2 }, // https://www.landsnail.com/a2ref.htm
    { true,  true,  true,  true,  "KV2_8B",   "IF",         0 }, // https://www.landsnail.com/a2ref.htm
    { true,  true,  true,  true,  "KV2_8C",   "RESTORE",    3 }, // https://www.landsnail.com/a2ref.htm
    { true,  true,  true,  true,  "KV2_8D",   "GOSUB",      3 }, // https://www.landsnail.com/a2ref.htm
    { true,  true,  true,  true,  "KV2_8E",   "RETURN",     3 }, // https://www.landsnail.com/a2ref.htm
    { true,  true,  true,  true,  "KV2_8F",   "REM",        0 }, // https://www.landsnail.com/a2ref.htm
    { true,  true,  true,  true,  "KV2_90",   "STOP",       2 }, // https://www.landsnail.com/a2ref.htm
    { true,  true,  true,  true,  "KV2_91",   "ON",         0 }, // https://www.landsnail.com/a2ref.htm
    { true,  true,  true,  true,  "KV2_92",   "WAIT",       2 }, // http://www.picaxe.com/BASIC-Commands/Time-Delays/wait/
    { true,  true,  true,  true,  "KV2_93",   "LOAD",       2 }, // https://www.landsnail.com/a2ref.htm
    { true,  true,  true,  true,  "KV2_94",   "SAVE",       2 }, // https://www.landsnail.com/a2ref.htm
    { true,  true,  true,  true,  "KV2_95",   "VERIFY",     2 }, // https://en.wikipedia.org/wiki/Sinclair_BASIC
    { true,  true,  true,  true,  "KV2_96",   "DEF",        2 }, // https://www.landsnail.com/a2ref.htm
    { true,  true,  true,  true,  "KV2_97",   "POKE",       2 }, // https://www.landsnail.com/a2ref.htm
    { true,  true,  true,  true,  "KV2_98",   "PRINT#",     2 }, // https://www.atariarchives.org/creativeatari/Using_Disks_With_Atari_Basic.php
    { true,  true,  true,  true,  "KV2_99",   "PRINT",      0 }, // https://www.landsnail.com/a2ref.htm
    { true,  true,  true,  true,  "KV2_9A",   "CONT",       2 }, // https://www.landsnail.com/a2ref.htm
    { true,  true,  true,  true,  "KV2_9B",   "LIST",       2 }, // https://www.landsnail.com/a2ref.htm
    { true,  true,  true,  true,  "KV2_9C",   "CLR",        2 }, // Apple I Replica Creation: Back to the Garage, p125
    { true,  true,  true,  true,  "KV2_9D",   "CMD",        2 }, // https://en.wikipedia.org/wiki/List_of_DOS_commands
    { true,  true,  true,  true,  "KV2_9E",   "SYS",        2 }, // https://www.lifewire.com/dos-commands-4070427
    { true,  true,  true,  true,  "KV2_9F",   "OPEN",       2 }, // https://www.atariarchives.org/creativeatari/Using_Disks_With_Atari_Basic.php
    // STD    M65    U64    X16
    { true,  true,  true,  true,  "KV2_A0",   "CLOSE",      3 }, // https://www.atariarchives.org/creativeatari/Using_Disks_With_Atari_Basic.php
    { true,  true,  true,  true,  "KV2_A1",   "GET",        2 }, // https://www.landsnail.com/a2ref.htm
    { true,  true,  true,  true,  "KV2_A2",   "NEW",        0 }, // https://www.landsnail.com/a2ref.htm
    { true,  true,  true,  true,  "KV2_A3",   "TAB(",       2 }, // http://www.antonis.de/qbebooks/gwbasman/tab.html
    { true,  true,  true,  true,  "KV2_A4",   "TO",         0 }, // https://www.landsnail.com/a2ref.htm
    { true,  true,  true,  true,  "KV2_A5",   "FN",         0 }, // https://www.landsnail.com/a2ref.htm
    { true,  true,  true,  true,  "KV2_A6",   "SPC(",       2 }, // http://www.antonis.de/qbebooks/gwbasman/spc.html
    { true,  true,  true,  true,  "KV2_A7",   "THEN",       2 }, // https://www.landsnail.com/a2ref.htm
    { true,  true,  true,  true,  "KV2_A8",   "NOT",        2 }, // https://www.landsnail.com/a2ref.htm
    { true,  true,  true,  true,  "KV2_A9",   "STEP",       2 }, // https://www.landsnail.com/a2ref.htm
    { true,  true,  true,  true,  "KV2_AA",   "+",          0 }, // https://www.landsnail.com/a2ref.htm
    { true,  true,  true,  true,  "KV2_AB",   "-",          0 }, // https://www.landsnail.com/a2ref.htm
    { true,  true,  true,  true,  "KV2_AC",   "*",          0 }, // https://www.landsnail.com/a2ref.htm
    { true,  true,  true,  true,  "KV2_AD",   "/",          0 }, // https://www.landsnail.com/a2ref.htm
    { true,  true,  true,  true,  "KV2_AE",   "^",          0 }, // https://www.landsnail.com/a2ref.htm
    { true,  true,  true,  true,  "KV2_AF",   "AND",        2 }, // https://www.landsnail.com/a2ref.htm
    { true,  true,  true,  true,  "KV2_B0",   "OR",         0 }, // https://www.landsnail.com/a2ref.htm
    { true,  true,  true,  true,  "KV2_B1",   ">",          0 }, // https://www.landsnail.com/a2ref.htm
    { true,  true,  true,  true,  "KV2_B2",   "=",          0 }, // https://www.landsnail.com/a2ref.htm
    { true,  true,  true,  true,  "KV2_B3",   "<",          0 }, // https://www.landsnail.com/a2ref.htm
    { true,  true,  true,  true,  "KV2_B4",   "SGN",        2 }, // https://www.landsnail.com/a2ref.htm
    { true,  true,  true,  true,  "KV2_B5",   "INT",        0 }, // https://www.landsnail.com/a2ref.htm
    { true,  true,  true,  true,  "KV2_B6",   "ABS",        2 }, // https://www.landsnail.com/a2ref.htm
    { true,  true,  true,  true,  "KV2_B7",   "USR",        2 }, // https://www.landsnail.com/a2ref.htm
    { true,  true,  true,  true,  "KV2_B8",   "FRE",        2 }, // http://www.antonis.de/qbebooks/gwbasman/fre.html
    { true,  true,  true,  true,  "KV2_B9",   "POS",        0 }, // http://www.antonis.de/qbebooks/gwbasman/pos.html
    { true,  true,  true,  true,  "KV2_BA",   "SQR",        2 }, // https://www.landsnail.com/a2ref.htm
    { true,  true,  true,  true,  "KV2_BB",   "RND",        2 }, // https://www.landsnail.com/a2ref.htm
    { true,  true,  true,  true,  "KV2_BC",   "LOG",        0 }, // https://www.landsnail.com/a2ref.htm
    { true,  true,  true,  true,  "KV2_BD",   "EXP",        2 }, // https://www.landsnail.com/a2ref.htm
    { true,  true,  true,  true,  "KV2_BE",   "COS",        0 }, // https://www.landsnail.com/a2ref.htm
    { true,  true,  true,  true,  "KV2_BF",   "SIN",        2 }, // https://www.landsnail.com/a2ref.htm
    // STD    M65    U64    X16
    { true,  true,  true,  true,  "KV2_C0",   "TAN",        0 }, // https://www.landsnail.com/a2ref.htm
    { true,  true,  true,  true,  "KV2_C1",   "ATN",        2 }, // https://www.landsnail.com/a2ref.htm
    { true,  true,  true,  true,  "KV2_C2",   "PEEK",       2 }, // https://www.landsnail.com/a2ref.htm
    { true,  true,  true,  true,  "KV2_C3",   "LEN",        0 }, // https://www.landsnail.com/a2ref.htm
    { true,  true,  true,  true,  "KV2_C4",   "STR$",       3 }, // https://www.landsnail.com/a2ref.htm
    { true,  true,  true,  true,  "KV2_C5",   "VAL",        2 }, // https://www.landsnail.com/a2ref.htm
    { true,  true,  true,  true,  "KV2_C6",   "ASC",        2 }, // https://www.landsnail.com/a2ref.htm
    { true,  true,  true,  true,  "KV2_C7",   "CHR$",       2 }, // https://www.landsnail.com/a2ref.htm
    { true,  true,  true,  true,  "KV2_C8",   "LEFT$",      3 }, // https://www.landsnail.com/a2ref.htm
    { true,  true,  true,  true,  "KV2_C9",   "RIGHT$",     2 }, // https://www.landsnail.com/a2ref.htm
    { true,  true,  true,  true,  "KV2_CA",   "MID$",       2 }, // https://www.landsnail.com/a2ref.htm
    { true,  true,  true,  true,  "KV2_CB",   "GO",         0 }, // https://en.wikipedia.org/wiki/Goto
} };

// extended BASIC keywords - list reserved for small BASIC commands, suitable for inclusion in non-extended ROMs

const StringEntryList GLOBAL_Keywords_01 =  { ListType::KEYWORDS, "keywords_01",
{
    // STD    M65    U64    X16
    { true,  true,  true,  true,  "K01_01",   "SLOW",         }, // https://en.wikipedia.org/wiki/Sinclair_BASIC - ZX81 variant
    { true,  true,  true,  true,  "K01_02",   "FAST",         }, // https://en.wikipedia.org/wiki/Sinclair_BASIC - ZX81 variant
    { true,  true,  true,  true,  "K01_03",   "OLD",          }, // Not present in CBM BASIC dialects, but common to some extensions (*)

    // (*) see https://sourceforge.net/p/vice-emu/code/HEAD/tree/trunk/vice/src/petcat.c

    // NOTE! These commands are temporarily placed here, they should be a part of list 02!

    { true,  true,  true,  true,  "K02_01",   "MERGE",        }, // Not present in CBM BASIC dialects, but common to some extensions (*)
    { true,  true,  true,  true,  "K02_02",   "BLOAD",        }, // http://www.antonis.de/qbebooks/gwbasman/bload.html
    { true,  true,  true,  true,  "K02_03",   "BSAVE",        }, // http://www.antonis.de/qbebooks/gwbasman/bsave.html
    { true,  true,  true,  true,  "K02_04",   "BVERIFY",      },
    { true,  true,  true,  true,  "K02_05",   "CLEAR",        }, // Not present in CBM BASIC dialects, Open ROMs specific
    { true,  true,  true,  true,  "K02_06",   "DISPOSE",      }, // Not present in CBM BASIC dialects, Open ROMs specific
} };

// extended BASIC keywords - list reserved for generic (mostly hardware independent) BASIC commands

const StringEntryList GLOBAL_Keywords_02 =  { ListType::KEYWORDS, "keywords_02",
{
    // STD    M65    U64    X16

    { false, true,  false, false, "K02_07",   "COLD",         }, // Not present in CBM BASIC dialects, but common to some extensions (*)
    { false, true,  false, false, "K02_08",   "MEM",          }, // Not present in CBM BASIC dialects, Open ROMs specific

    // (*) see https://sourceforge.net/p/vice-emu/code/HEAD/tree/trunk/vice/src/petcat.c
} };

// BASIC errors - all dialects

/*
  These error messages are generally so well known, that it seems silly to have to even point out that they are
  so widely used and known, if not completely genericised.
  The most of them are inherited from the MICROSOFT BASIC on which the C64's BASIC is based, so for those, there
  cannot even be any claim to copyright over them in any exclusive way.

  However, copyright of such short phrases that express ideas in short form cannot be copyrighted:
  https://fairuse.stanford.edu/2003/09/09/copyright_protection_for_short/
 */

const StringEntryList GLOBAL_Errors =  { ListType::STRINGS_BASIC, "errors",
{
    // STD    M65    U64    X16   --- error strings compatible with CBM BASIC V2
    { true,  true,  true,  true,  "EV2_01", "TOO MANY FILES"           },
    { true,  true,  true,  true,  "EV2_02", "FILE OPEN"                },
    { true,  true,  true,  true,  "EV2_03", "FILE NOT OPEN"            },
    { true,  true,  true,  true,  "EV2_04", "FILE NOT FOUND"           },
    { true,  true,  true,  true,  "EV2_05", "DEVICE NOT PRESENT"       },
    { true,  true,  true,  true,  "EV2_06", "NOT INPUT FILE"           },
    { true,  true,  true,  true,  "EV2_07", "NOT OUTPUT FILE"          },
    { true,  true,  true,  true,  "EV2_08", "MISSING FILENAME"         },
    { true,  true,  true,  true,  "EV2_09", "ILLEGAL DEVICE NUMBER"    },
    { true,  true,  true,  true,  "EV2_0A", "NEXT WITHOUT FOR"         },
    { true,  true,  true,  true,  "EV2_0B", "SYNTAX"                   },
    { true,  true,  true,  true,  "EV2_0C", "RETURN WITHOUT GOSUB"     },
    { true,  true,  true,  true,  "EV2_0D", "OUT OF DATA"              },
    { true,  true,  true,  true,  "EV2_0E", "ILLEGAL QUANTITY"         },
    { true,  true,  true,  true,  "EV2_0F", "OVERFLOW"                 },
    { true,  true,  true,  true,  "EV2_10", "OUT OF MEMORY"            },
    { true,  true,  true,  true,  "EV2_11", "UNDEF\'D STATEMENT"       },
    { true,  true,  true,  true,  "EV2_12", "BAD SUBSCRIPT"            },
    { true,  true,  true,  true,  "EV2_13", "REDIM\'D ARRAY"           },
    { true,  true,  true,  true,  "EV2_14", "DIVISION BY ZERO"         },
    { true,  true,  true,  true,  "EV2_15", "ILLEGAL DIRECT"           },
    { true,  true,  true,  true,  "EV2_16", "TYPE MISMATCH"            },
    { true,  true,  true,  true,  "EV2_17", "STRING TOO LONG"          },
    { true,  true,  true,  true,  "EV2_18", "FILE DATA"                },
    { true,  true,  true,  true,  "EV2_19", "FORMULA TOO COMPLEX"      },
    { true,  true,  true,  true,  "EV2_1A", "CAN\'T CONTINUE"          },
    { true,  true,  true,  true,  "EV2_1B", "UNDEF\'D FUNCTION"        },
    { true,  true,  true,  true,  "EV2_1C", "VERIFY"                   },
    { true,  true,  true,  true,  "EV2_1D", "LOAD"                     },
    { true,  true,  true,  true,  "EV2_1E", "BREAK"                    },
    // STD    M65    U64    X16   --- error strings compatible with CBM BASIC V7
    { false, false, false, false, "EV7_1F", "CAN'T RESUME"             }, // not used for now
    { false, false, false, false, "EV7_20", "LOOP NOT FOUND"           }, // not used for now
    { false, false, false, false, "EV7_21", "LOOP WITHOUT DO"          }, // not used for now
    { true,  true,  true,  true,  "EV7_22", "DIRECT MODE ONLY"         },
    { false, false, false, false, "EV7_23", "NO GRAPHICS AREA"         }, // not used for now
    { false, false, false, false, "EV7_24", "BAD DISK"                 }, // not used for now
    { false, false, false, false, "EV7_25", "BEND NOT FOUND"           }, // not used for now
    { true,  true,  true,  true,  "EV7_26", "LINE NUMBER TOO LARGE"    },
    { false, false, false, false, "EV7_27", "UNRESOLVED REFERENCE"     }, // not used for now
    { true,  true,  true,  true,  "EV7_28", "NOT IMPLEMENTED"          }, // this message actually differs from the CBM one
    { false, false, false, false, "EV7_29", "FILE READ"                }, // not used for now
    // STD    M65    U64    X16   --- error strings specific to Open ROMs, not present in CBM BASIC dialects
    { true,  true,  true,  true,  "EOR_2A", "MEMORY CORRUPT"           },   
} };

// BASIC errors - miscelaneous strings

const StringEntryList GLOBAL_MiscStrings =  { ListType::STRINGS_BASIC, "misc",
{
    // STD    M65    U64    X16   --- misc strings as on CBM machines
    { true,  true,  true,  true,  "STR_RET_QM",   "\r?"                },
    { true,  true,  true,  true,  "STR_BYTES",    " BASIC BYTES FREE"  }, // https://github.com/stefanhaustein/expressionparser
    { true,  true,  true,  true,  "STR_READY",    "\rREADY.\r"         }, // https://www.ibm.com/support/knowledgecenter/zosbasics/com.ibm.zos.zconcepts/zconc_whatistsonative.htm https://github.com/stefanhaustein/expressionparser
    { true,  true,  true,  true,  "STR_ERROR",    " ERROR"             }, // simply the word error that is attached to the other parts of messages https://fjkraan.home.xs4all.nl/comp/apple2faq/app2asoftfaq.html
    { true,  true,  true,  true,  "STR_IN",       " IN "               },
    { false, true,  false, false, "STR_IF_SURE",  "\rARE YOU SURE? "   }, // https://docs.microsoft.com/en-us/windows/win32/uxguide/mess-confirm
    // STD    M65    U64    X16   --- misc strings specific to Open ROMs, not present in CBM ROMs
    { true,  true,  true,  true,  "STR_BRK_AT",   "\rBRK AT $"         },
    { false, true,  false, false, "STR_MEM_HDR",  "\r\x12 AREA   START   SIZE  \r" },
    { false, true,  false, false, "STR_MEM_1",    "   $"               },
    { false, true,  false, false, "STR_MEM_2",    "   "                },
    { false, true,  false, false, "STR_MEM_TEXT", "\r TEXT"            },
    { false, true,  false, false, "STR_MEM_VARS", "\r VARS"            },
    { false, true,  false, false, "STR_MEM_ARRS", "\r ARRS"            },
    { false, true,  false, false, "STR_MEM_STRS", "\r STRS"            },
    { false, true,  false, false, "STR_MEM_FREE", "\r\r FREE"          },

    // Note: depending on configuration, additional strings will be added here
} };


/* NOTE: below are the BASIC V7/V10 keywords, see:
         - https://sites.google.com/site/h2obsession/CBM/basic/tokens
         - http://www.zimmers.net/anonftp/pub/cbm/programming/cbm-basic-tokens.txt

    "RGR"         // $CC
    "RCLR"        // $CD

    "JOY"         // $CF                         // https://www.qsl.net/hb9xch/computer/amstrad/locomotivebasic.html
    "RDOT"        // $D0
    "DEC"         // $D1                         // Amos Professional Manual, Command Index
    "HEX$"        // $D2                         // http://www.antonis.de/qbebooks/gwbasman/hexs.html
    "ERR$"        // $D3                         // Amos Professional Manual, Command Index
    "INSTR"       // $D4                         // Amos Professional Manual, Command Index
    "ELSE"        // $D5                         // Amos Professional Manual, Command Index
    "RESUME"      // $D6                         // Amos Professional Manual, Command Index
    "TRAP"        // $D7                         // Amos Professional Manual, Command Index
    "TRON"        // $D8                         // https://www.qsl.net/hb9xch/computer/amstrad/locomotivebasic.html
    "TROFF"       // $D9                         // https://www.qsl.net/hb9xch/computer/amstrad/locomotivebasic.html
    "SOUND"       // $DA                         // https://www.qsl.net/hb9xch/computer/amstrad/locomotivebasic.html
    "VOL"         // $DB
    "AUTO"        // $DC                         // http://www.antonis.de/qbebooks/gwbasman/auto.html
    "PUDEF"       // $DD
    "GRAPHIC"     // $DE
    "PAINT"       // $DF                         // Amos Professional Manual, Command Index
    "CHAR"        // $E0                         // https://www.c64-wiki.com/wiki/Screen_Graphics_64
    "BOX"         // $E1                         // Amos Professional Manual, Command Index
    "CIRCLE"      // $E2                         // https://en.wikipedia.org/wiki/Sinclair_BASIC
    "PASTE"       // $E3                         // Amos Professional Manual, Command Index
    "CUT"         // $E4
    "LINE"        // $E5                         // https://en.wikipedia.org/wiki/Sinclair_BASIC
    "LOCATE"      // $E6                         // https://www.qsl.net/hb9xch/computer/amstrad/locomotivebasic.html
    "COLOR"       // $E7
    "SCNCLR"      // $E8
    "SCALE"       // $E9                         // https://www.c64-wiki.com/wiki/Super_Expander_64
    "HELP"        // $EA                         // http://www.classic-games.com/commodore64/cbmtoken.html, Speech Basic 2.7
    "DO"          // $EB                         // Amos Professional Manual, Command Index
    "LOOP"        // $EC                         // Amos Professional Manual, Command Index
    "EXIT"        // $ED                         // Amos Professional Manual, Command Index
    "DIR"         // $EE                         // Amos Professional Manual, Command Index
    "DSAVE"       // $EF                         // http://www.classic-games.com/commodore64/cbmtoken.html, AtBasic (@Basic)
    "DLOAD"       // $F0                         // http://www.classic-games.com/commodore64/cbmtoken.html, AtBasic (@Basic)
    "HEADER"      // $F1                         // http://www.classic-games.com/commodore64/cbmtoken.html, AtBasic (@Basic)
    "SCRATCH"     // $F2                         // http://www.classic-games.com/commodore64/cbmtoken.html, AtBasic (@Basic)
    "COLLECT"     // $F3
    "COPY"        // $F4                         // https://en.wikipedia.org/wiki/Sinclair_BASIC
    "RENAME"      // $F5                         // Amos Professional Manual, Command Index
    "BACKUP"      // $F6                         // http://www.classic-games.com/commodore64/cbmtoken.html, AtBasic (@Basic)
    "DELETE"      // $F7                         // http://www.classic-games.com/commodore64/cbmtoken.html, AtBasic (@Basic)
    "RENUMBER"    // $F8                         // http://www.classic-games.com/commodore64/cbmtoken.html, AtBasic (@Basic)
    "KEY"         // $F9                         // https://www.qsl.net/hb9xch/computer/amstrad/locomotivebasic.html
    "MONITOR"     // $FA                         // Amos Professional Manual, Command Index
    "USING"       // $FB                         // http://www.antonis.de/qbebooks/gwbasman/printusing.html
    "UNTIL"       // $FC                         // Amos Professional Manual, Command Index
    "WHILE"       // $FD                         // https://www.qsl.net/hb9xch/computer/amstrad/locomotivebasic.html

    "POT"         // $CE $02
    "BUMP"        // $CE $03
    "PEN"         // $CE $04                     // https://www.qsl.net/hb9xch/computer/amstrad/locomotivebasic.html
    "RSPPOS"      // $CE $05                     // https://www.c64-wiki.com/wiki/Super_Expander_64
    "RSPRITE"     // $CE $06
    "RSPCOLOR"    // $CE $07
    "XOR"         // $CE $08
    "RWINDOW"     // $CE $09
    "POINTER"     // $CE $0A

    "BANK"        // $FE $02                     // Amos Professional Manual, Command Index
    "FILTER"      // $FE $03                     // https://www.c64-wiki.com/wiki/Super_Expander_64
    "PLAY"        // $FE $04                     // Amos Professional Manual, Command Index
    "TEMPO"       // $FE $05                     // Amos Professional Manual, Command Index
    "MOVSPR"      // $FE $06
    "SPRITE"      // $FE $07                     // Amos Professional Manual, Command Index
    "SPRCOLOR"    // $FE $08
    "RREG"        // $FE $09
    "ENVELOPE"    // $FE $0A
    "SLEEP"       // $FE $0B
    "CATALOG"     // $FE $0C                     // http://www.classic-games.com/commodore64/cbmtoken.html, AtBasic (@Basic)
    "DOPEN"       // $FE $0D
    "APPEND"      // $FE $0E                     // Amos Professional Manual, Command Index
    "DCLOSE"      // $FE $0F
    "BSAVE"       // $FE $10                     // http://www.antonis.de/qbebooks/gwbasman/bsave.html
    "BLOAD"       // $FE $11                     // http://www.antonis.de/qbebooks/gwbasman/bload.html
    "RECORD"      // $FE $12
    "CONCAT"      // $FE $13
    "DVERIFY"     // $FE $14                     // http://www.classic-games.com/commodore64/cbmtoken.html, AtBasic (@Basic)
    "DCLEAR"      // $FE $15
    "SPRSAV"      // $FE $16                     // https://www.c64-wiki.com/wiki/Super_Expander_64
    "COLLISION"   // $FE $17
    "BEGIN"       // $FE $18
    "BEND"        // $FE $19
    "WINDOW"      // $FE $1A                     // http://www.antonis.de/qbebooks/gwbasman/window.html
    "BOOT"        // $FE $1B
    "WIDTH"       // $FE $1C                     // http://www.antonis.de/qbebooks/gwbasman/width.html
    "SPRDEF"      // $FE $1D                     // https://www.c64-wiki.com/wiki/Super_Expander_64
    "QUIT"        // $FE $1E                     // http://www.classic-games.com/commodore64/cbmtoken.html, Speech Basic 2.7

    "STASH"       // $FE $1F - v7
    "FETCH"       // $FE $21 - v7
    "SWAP"        // $FE $23 - v7                // http://www.antonis.de/qbebooks/gwbasman/swap.html

    "DMA"         // $FE $17/$21/$23 - v10              

    "OFF"         // $FE $24                     // http://www.classic-games.com/commodore64/cbmtoken.html, Speech Basic 2.7
    "FAST"        // $FE $25                     // https://en.wikipedia.org/wiki/Sinclair_BASIC - ZX81 variant
    "SLOW"        // $FE $26                     // https://en.wikipedia.org/wiki/Sinclair_BASIC - ZX81 variant
    "TYPE"        // $FE $27               
    "BVERIFY"     // $FE $28               
    "DIRECTORY"   // $FE $29                     // http://www.classic-games.com/commodore64/cbmtoken.html, AtBasic (@Basic)
    "ERASE"       // $FE $2A                     // https://en.wikipedia.org/wiki/Sinclair_BASIC
    "FIND"        // $FE $2B                     // http://www.classic-games.com/commodore64/cbmtoken.html, AtBasic (@Basic)
    "CHANGE"      // $FE $2C               
    "SET"         // $FE $2D               
    "SCREEN"      // $FE $2E                     // http://www.antonis.de/qbebooks/gwbasman/screens.html
    "POLYGON"     // $FE $2F                     // Amos Professional Manual, Command Index
    "ELLIPSE"     // $FE $30                     // Amos Professional Manual, Command Index
    "VIEWPORT"    // $FE $31               
    "GCOPY"       // $FE $32               
    "PEN"         // $FE $33                     // Amos Professional Manual, Command Index
    "PALETTE"     // $FE $34                     // Amos Professional Manual, Command Index
    "DMODE"       // $FE $35               
    "DPAT"        // $FE $36               
    "PIC"         // $FE $37               
    "GENLOCK"     // $FE $38               
    "FOREGROUND"  // $FE $39               

    "BACKGROUND"  // $FE $3B               
    "BORDER"      // $FE $3C                     // https://en.wikipedia.org/wiki/Sinclair_BASIC
    "HIGHLIGHT"   // $FE $3D               
*/

std::map<std::string, bool> GLOBAL_ConfigOptions;

//
// Work class definitions
//

// This class encapsulates the optional dictionary encoding of selected string lists
class DictEncoder
{
public:

    void addString(const std::string &inString, StringEncoded *outPtr);

    void process(StringEntryList &outDictionary);

private:

    bool optimizeSplit();
    bool optimizeJoin();
    void optimizeOrder();

    void cleanupDictionary();

    void extractWords(std::vector<std::string> &candidateList);
    int32_t evaluateCandidate(std::string &candidate);

    std::vector<StringEncoded *> encodings;
    std::vector<std::string>     dictionary;
};

// Main class to encode strings based on character frequency
class DataSet
{
public:

    void addStrings(const StringEntryList &stringList);

    const std::string &getOutput();

private:

    void process();

    void generateConfigDepStrings();
    void validateLists();
    void calculateFrequencies();
    void encodeStringsDict();
    void encodeStringsFreq();

    void encodeByFreq(const std::string &plain, StringEncoded &encoded) const;

    void prepareOutput();
    void prepareOutput_1n_3n(std::ostringstream &stream);
    void prepareOutput_labels(std::ostringstream &stream,
                              const StringEntryList &stringEntryList,
                              const StringEncodedList &stringEncodedList);
    void prepareOutput_packed(std::ostringstream &stream,
                              const StringEntryList &stringEntryList,
                              const StringEncodedList &stringEncodedList);

    void putCharEncoding(std::ostringstream &stream, uint8_t idx, char character, bool is3n);

    bool isCompressionLvl2(const StringEntryList &list) const;

    virtual bool isRelevant(const StringEntry &entry) const = 0;
    virtual std::string layoutName() const = 0;

    std::vector<StringEntryList>          stringEntryLists;
    std::vector<StringEncodedList>        stringEncodedLists;

    std::vector<char>                     as1n; // list of bytes to be encoded as 1 nibble
    std::vector<char>                     as3n; // list of bytes to be encoded as 3 nibbles

    uint8_t                               tk__packed_as_3n    = 0;
    uint8_t                               tk__max_keyword_len = 0;

    size_t                                maxAliasLen          = 0;
    std::string                           outFileContent;
};

class DataSetSTD : public DataSet
{
    bool isRelevant(const StringEntry &entry) const { return entry.enabledSTD; }
    std::string layoutName() const { return "STD"; }
};

class DataSetM65 : public DataSet
{
    bool isRelevant(const StringEntry &entry) const { return entry.enabledM65; }
    std::string layoutName() const { return "M65"; }
};

class DataSetU64 : public DataSet
{
    bool isRelevant(const StringEntry &entry) const { return entry.enabledU64; }
    std::string layoutName() const { return "STD"; } // XXX to be changed for 'U64' once the layout is finished
};

class DataSetX16 : public DataSet
{
    bool isRelevant(const StringEntry &entry) const { return entry.enabledX16; }
    std::string layoutName() const { return "X16"; }
};

//
// Work class implementation
//

void DictEncoder::addString(const std::string &inString, StringEncoded *outPtr)
{
    // Store the pointer to encoding

    encodings.push_back(outPtr);

    // Check if string is already present in the dictionary

    auto pos = std::find(dictionary.begin(), dictionary.end(), inString);

    // Create initial encoding

    if (pos != dictionary.end())
    {
        encodings.back()->push_back(pos - dictionary.begin());
    }
    else
    {
        if (dictionary.size() > 255)
        {
            ERROR("max 255 strings allowed for dictionary compression");
        }

        dictionary.push_back(inString);
        encodings.back()->push_back(dictionary.size() - 1);
    }
}


void DictEncoder::extractWords(std::vector<std::string> &candidateList)
{
    for (const auto &dictionaryEntry : dictionary)
    {
        // Split the dictionary entry into words
       
        std::istringstream entryStream(dictionaryEntry);
        while (entryStream)
        {
            std::string word_1;
            entryStream >> word_1;

            if (word_1.empty()) continue;
           
            // Create possible variants with spaces

            std::string word_2 = " " + word_1;
            std::string word_3 = word_1 + " ";
            std::string word_4 = word_2 + " ";

            // If necessary, add the word to candidate list
           
            auto addToList = [&dictionaryEntry, &candidateList](std::string &word)
            {
                // Before dding, make sure the word variant exists in the string,
                // is not already on the list, and is long enough it makes sense to try

                if (word.size() < 1) return;
                if (dictionaryEntry.find(word) == std::string::npos) return;
                if (std::find(candidateList.begin(), candidateList.end(), word) != candidateList.end()) return;

                candidateList.push_back(word);
            };
           
            addToList(word_1);
            addToList(word_2);
            addToList(word_3);
            addToList(word_4);
        }
    }
}

int32_t DictEncoder::evaluateCandidate(std::string &candidate)
{
    // XXX it looks like this is not 100% right - debug the algorithm if dictionary compression is reintroduced

    // Build the score - find how much bytes can be spared by extracting this particular candidate
    // Limited size of the dictionary is taken into consideration
   
    int32_t  score      = -(candidate.size() + 1);
    uint32_t targetSize = dictionary.size() + 1;

    // First check for situation when the candidate equals the currently existing dictionary entry

    for (const auto &dictionaryEntry : dictionary)
    {   
        if (dictionaryEntry == candidate)
        {
            // Candidate equals the string

            score += candidate.size() + 1;
            targetSize--;
            continue;
        }
    }

    // Now check the remaining cases

    for (const auto &dictionaryEntry : dictionary)
    {   
        if (dictionaryEntry == candidate) continue; // already handled

        // Find all the occurences of the candidate in the current string

        std::vector<uint8_t> occurences;
        for (auto iter = dictionaryEntry.begin(); iter < (dictionaryEntry.end() - candidate.size() + 1); iter++)
        {
            if (candidate != std::string(iter, iter + candidate.size())) continue;
           
            occurences.push_back(iter - dictionaryEntry.begin());
            iter += candidate.size() - 1; // to make sure we have no occurence overlapping
        }
       
        if (occurences.empty()) continue;
       
        // Now summarize what we are going to gain when doing replacement
       
        if (occurences[0] != 0)
        {
            // For the substring before the first occurence we need to create a separate entry
            // in the dictionary - unless it is already there, it brings some additional cost

            std::string otherStr = std::string(dictionaryEntry.begin(), dictionaryEntry.end() + occurences[0]);

            if (std::find(dictionary.begin(), dictionary.end(), otherStr) != dictionary.end())
            {
                // This extra string is already in the dictionary - that gives extra saving
                score += otherStr.size() - 1;
            }
            else
            {
                // This extra string is not in the dictionary, it has to be added
                score -= 2;
                targetSize++;
            }
        }
       
        for (auto iter = occurences.begin(); iter < occurences.end(); iter++)
        {
            // With a replacement, we should gain some bytes
            score += candidate.size() - 1;

            // If the occurence ends with the last byte of dictionary string - nothing more to do
            if (*iter + candidate.size() == dictionaryEntry.size()) break;

            // If next occurence starts immediately after this one - next iteration
            if (iter + 1 != occurences.end() && (*(iter + 1) - *iter) == (uint8_t) candidate.size()) continue;

            // For the substring between this occurence and the next one (or the end of the string)
            // we need to create a separate entry in the dictionary - unless it is already there,
            // it brings some additional cost

            std::string otherStr;
            if (iter + 1 == occurences.end())
            {
                otherStr = std::string(dictionaryEntry.begin() + *iter + candidate.size(),
                                       dictionaryEntry.end());
            }
            else
            {
                otherStr = std::string(dictionaryEntry.begin() + *iter + candidate.size(),
                                       dictionaryEntry.begin() + *(iter + 1));
            }

            if (std::find(dictionary.begin(), dictionary.end(), otherStr) != dictionary.end())
            {
                // This extra string is already in the dictionary - that gives extra saving
                score += otherStr.size() - 1;
            }
            else
            {
                // This extra string is not in the dictionary, it has to be added
                score -= 2;
                targetSize++;
            }           
        }
       
        // We crossed the maximum number of strings (leave one free for the work buffer),
        // do not consider this candidate
       
        if (targetSize > 254) return -1;
    }
   
    return score;
}

void DictEncoder::cleanupDictionary()
{
    // Get rid of dictionary entries which are not needed anymore
   
    bool isClean = false;
   
    while (!isClean)
    {
        isClean = true;
       
        for (auto iter = dictionary.begin(); iter < dictionary.end(); iter++)
        {
            if (!iter->empty()) continue;
           
            // Found an empty string in the dictionary - remove it and adapt encoding
           
            isClean = false;
            uint8_t obsoleteStrIdx = iter - dictionary.begin();
           
            dictionary.erase(iter);
           
            for (auto &encoding : encodings) for (auto &byte : *encoding)
            {
                if (byte >= obsoleteStrIdx) byte--;
            }
           
            break;
        }
    }
}

bool DictEncoder::optimizeSplit()
{
    // XXX - The code here is not the best one - redesign and algorithm improvements
    // (like - consider optimizing as a game and apply alpha-beta scheme to select the best
    // candidate, incorporate frequency encoding into candidate evaluation) could result in
    // a slightly better compression. But currently we have very few strings, and the dictionary
    // compression is disabled by default - so right now this is not worth the effort.
   
    if (dictionary.size() >= 255) return false; // up to 255 entries in the dictionary are possible
   
    // First select words, which can potentially be extracted to new substrings
   
    std::vector<std::string> candidateList;
    extractWords(candidateList);

    // XXX possible future improvement: find a couple of largest common substrings and add them as candidates too
   
    // Now find the best word to be extracted
   
    auto bestCandidate         = candidateList.end();
    int32_t bestCandidateScore = 0;
   
    for (auto iter = candidateList.begin(); iter < candidateList.end(); iter++)
    {
        int32_t candidateScore = evaluateCandidate(*iter);

        if (candidateScore > bestCandidateScore)
        {
            bestCandidate      = iter;
            bestCandidateScore = candidateScore;
        }
    }
   
    // Only allow for replacements that brings some size benefit
   
    if (bestCandidateScore < 1) return false;
   
    // Extract the best candidate to a separate string
   
    // First add our selected candidate to the dictionary and replace all strings which are equal to it
   
    auto    &selectedStr   = *bestCandidate;
    uint8_t selectedStrIdx = dictionary.size();
   
    dictionary.push_back(selectedStr);

    for (auto iter = dictionary.begin(); iter < dictionary.end(); iter++)
    {
        uint8_t currentStrIdx = iter - dictionary.begin();
       
        if (*iter != selectedStr || selectedStrIdx == currentStrIdx) continue;
       
        // Replace the current string with the new one
       
        for (auto &encoding : encodings) for (auto &byte : *encoding)
        {
            if (byte == currentStrIdx) byte = selectedStrIdx;
        }
       
        // Mark obsolete dictionary entry as free for removal
       
        iter->clear();
    }

    cleanupDictionary();

    // Now handle normal cases, when the string needs to be split
    // XXX - this is not time-effective, optimize this in the future

    bool optimizeAgain = true;
    bool nexIteration  = true;
    while (nexIteration)
    {
        nexIteration = false;

        for (auto iter = dictionary.begin(); iter < dictionary.end(); iter++)
        {
            auto    &currentStr     = *iter;
            uint8_t currentStrIdx   = iter - dictionary.begin();   
            auto    selectedStrIter = std::find(dictionary.begin(), dictionary.end(), selectedStr);
            selectedStrIdx          = selectedStrIter - dictionary.begin();

            if (currentStrIdx == selectedStrIdx) continue;
   
            // Check if the current string contains the selected string
           
            auto pos = currentStr.find(selectedStr);
            if (pos == std::string::npos) continue;
               
            nexIteration  = true;
            optimizeAgain = true;
   
            // Prepare replacement sequence for 'selectedStrIdx'
               
            std::vector<uint8_t> replacement;
           
            if (pos == 0)
            {
                // The current dictionary string starts with our selected substring
               
                replacement.push_back(selectedStrIdx);
                currentStr = currentStr.substr(selectedStr.size(), currentStr.size() - selectedStr.size());
               
                if (!currentStr.empty())
                {
                    // Check if the remaining string is present somewhere else in the dictionary; if so, reuse it
               
                    uint8_t pos2 = currentStrIdx;
                    for (auto iter2 = dictionary.begin(); iter2 < dictionary.end(); iter2++)
                    {
                        if (iter2 == iter) continue;
                        if (currentStr == *iter2)
                        {
                            dictionary[pos2].clear();
                            pos2 = iter2 - dictionary.begin();
                            break;
                        }
                    }
                   
                    replacement.push_back(pos2);
                }
            }
            else
            {
                // The current dictionary string does not start with our selected substring
               
                std::string newStr = currentStr.substr(0, pos);
                currentStr         = currentStr.substr(pos, currentStr.size() - pos);
               
                // Check if the newStr is present somewhere else in the dictionary; if so, reuse it
               
                bool    found = false;
                uint8_t pos2  = 0;
                for (auto iter2 = dictionary.begin(); iter2 < dictionary.end(); iter2++)
                {
                    if (*iter2 == newStr)
                    {
                        found = true;
                        pos2  = iter2 - dictionary.begin();

                        break;
                    }
                }
           
                if (found)
                {
                    replacement.push_back(pos2);                   
                }
                else
                {
                    dictionary.push_back(newStr);
                    replacement.push_back(dictionary.size() - 1);                   
                }

                replacement.push_back(currentStrIdx);
            }

            // Now replace all the occurences of 'selectedStrIdx' with a 'replacement' vector

            for (auto &encoding : encodings)
            {
                for (uint8_t idx = 0; idx < encoding->size(); idx++)
                {
                    if ((*encoding)[idx] != currentStrIdx) continue;
                   
                    // Perform replacement
                   
                    encoding->erase(encoding->begin() + idx);
                   
                    for (const auto replacementIdx : replacement)
                    {
                        encoding->insert(encoding->begin() + idx, replacementIdx);
                        idx++;
                    }
                   
                    idx--;
                }
            }
           
            cleanupDictionary();
        }
    }

    return optimizeAgain;
}

bool DictEncoder::optimizeJoin()
{
    // Try to optimize by joining two substrings
   
    // XXX - possible future improvement
   
    return false;
}

void DictEncoder::optimizeOrder()
{
    // XXX - it would be better to do this after the dictionary is compressed

    // Try to optimize order of strings in the dictionary for fastest display
    // - put the shorter substrings first
    // - for strings with roughly the same length put more frequently used first
   
    typedef struct Entry
    {
        uint32_t    penalty;
        std::string word;
    } Entry;
   
    // Create copy of the dictionary with optimization info
   
    std::vector<Entry> optimizedOrder;
    for (auto iter = dictionary.begin(); iter < dictionary.end(); iter++)
    {
        const auto &dictionaryStr = *iter;
   
        uint8_t  sizePenalty = dictionaryStr.size() / 3;
        uint16_t freqPenalty = 65535;
       
        // Calculate penalty for low occurence frequency
       
        for (auto &encoding : encodings)
        {
            for (auto &byte : *encoding)
            {
                if (byte == (iter - dictionary.begin())) freqPenalty--;
            }
        }

        // Create new entry
       
        Entry newEntry;
        newEntry.word    = dictionaryStr;
        newEntry.penalty = sizePenalty * 65536 + freqPenalty;

        optimizedOrder.push_back(newEntry);
    }
   

    // Determine ordering - sort from smallest penalty to largest
   
    std::sort(optimizedOrder.begin(), optimizedOrder.end(),
              [](const Entry &e1, const Entry &e2) { return e1.penalty < e2.penalty; });

    // Create helper table for reordering
   
    std::vector<uint8_t> reorderTable;
   
    for (uint8_t idx1 = 0; idx1 < dictionary.size(); idx1++)
    {
        uint8_t idx2 = 0;
        while (dictionary[idx1] != optimizedOrder[idx2].word) idx2++;
       
        reorderTable.push_back(idx2);       
    }

    // Perform the reordering
   
    for (auto &encoding : encodings) for (auto &byte : *encoding)
    {
        byte = reorderTable[byte];
    }
   
    for (uint8_t idx = 0; idx < dictionary.size(); idx++) dictionary[idx] = optimizedOrder[idx].word;
}

void DictEncoder::process(StringEntryList &outDictionary)
{
    if (dictionary.empty()) return;
    // Optimize as long as it brings any improvement

    while (optimizeSplit() || optimizeJoin()) ;
    optimizeOrder();

    // Export the dictionary to external format

    outDictionary.type = ListType::DICTIONARY;
    outDictionary.name = "DICTIONARY";

    for (const auto &dictionaryStr : dictionary)
    {
        StringEntry newEntry = { true, true, true, "", dictionaryStr };
        outDictionary.list.push_back(newEntry);
    }

    // Adapt the encoding to external format (0 = end of string)

    for (auto &encoding : encodings)
    {
        for (auto &byte : *encoding) byte++;
        encoding->push_back(0);
    }
}

bool DataSet::isCompressionLvl2(const StringEntryList &list) const
{
    return (GLOBAL_ConfigOptions["CONFIG_COMPRESSION_LVL_2"] && list.type == ListType::STRINGS_BASIC);
}

void DataSet::addStrings(const StringEntryList &stringList)
{
    // Import the new list of strings

    stringEntryLists.push_back(stringList);
    stringEncodedLists.emplace_back();

    // Clear strings not relevant for the current configuration
   
    while (1)
    {
        if (isRelevant(stringEntryLists.back().list.back())) break;

        stringEntryLists.back().list.pop_back();
        if (stringEntryLists.back().list.empty())
        {
            ERROR(std::string("no valid strings in layout '") + layoutName() + "', list'" + stringEntryLists.back().name + "'");
        }
    }
   
    // Clear the output content - make sure it is not valid anymore

    outFileContent.clear();
}

void DataSet::process()
{
    std::cout << "Processing file '" << CMD_cnfFile << "', layout '" << layoutName() << "'" << std::endl;

    generateConfigDepStrings();
    validateLists();
    encodeStringsDict();
    calculateFrequencies();
    encodeStringsFreq();   
    prepareOutput();
}

const std::string &DataSet::getOutput()
{
    if (outFileContent.empty())
    {
        process();
    }

    return outFileContent;
}

void DataSet::generateConfigDepStrings()
{
    // Generate string to show the build features
   
    std::string featureStr;
   
    // Tape support features
   
    if (GLOBAL_ConfigOptions["CONFIG_TAPE_NORMAL"] && GLOBAL_ConfigOptions["CONFIG_TAPE_TURBO"])
    {
        featureStr = "TAPE LOAD NORMAL TURBO\r";
    }
    else if (GLOBAL_ConfigOptions["CONFIG_TAPE_NORMAL"])
    {
        featureStr = "TAPE LOAD NORMAL\r";
    }
    else if (GLOBAL_ConfigOptions["CONFIG_TAPE_TURBO"])
    {
        featureStr = "TAPE LOAD TURBO\r";
    }
   
    // IEC support features
   
    if (GLOBAL_ConfigOptions["CONFIG_IEC"])
    {
        featureStr += "IEC";
       
        bool extendedIEC = false;
       
        if (GLOBAL_ConfigOptions["CONFIG_IEC_BURST_CIA1"])
        {
            featureStr += " BURST1";
            extendedIEC = true;
        }
        if (GLOBAL_ConfigOptions["CONFIG_IEC_BURST_CIA2"])
        {
            featureStr += " BURST2";
            extendedIEC = true;
        }
        if (GLOBAL_ConfigOptions["CONFIG_IEC_BURST_MEGA65"])
        {
            featureStr += " BURST";
            extendedIEC = true;
        }
       
        if (GLOBAL_ConfigOptions["CONFIG_IEC_DOLPHINDOS"])
        {
            featureStr += " DOLPHIN";
            extendedIEC = true;
        }
       
        if (GLOBAL_ConfigOptions["CONFIG_IEC_JIFFYDOS"])
        {
            featureStr += " JIFFY";
            extendedIEC = true;
        }
       
        if (!extendedIEC) featureStr += " NORMAL";
       
        featureStr += "\r";
    }
   
    // RS-232 support features
   
    if (GLOBAL_ConfigOptions["CONFIG_RS232_UP2400"]) featureStr += "UP2400\r";
    if (GLOBAL_ConfigOptions["CONFIG_RS232_UP9600"]) featureStr += "UP9600\r";
   
    // Keyboard support features
   
    if (GLOBAL_ConfigOptions["CONFIG_KEYBOARD_C128"]) featureStr += "KBD 128\r";
    if (GLOBAL_ConfigOptions["CONFIG_KEYBOARD_C65"])  featureStr += "KBD 65\r";

    // Add strings to appropriate list
   
    for (auto &stringEntryList : stringEntryLists)
    {
        if (stringEntryList.name != std::string("misc")) continue;

        // List found

        if (GLOBAL_ConfigOptions["CONFIG_SHOW_FEATURES"])
        {
            StringEntry newEntry1 = { true, true, true, true, "STR_PAL",      "PAL\r"    };
            StringEntry newEntry2 = { true, true, true, true, "STR_NTSC",     "NTSC\r"   };
            StringEntry newEntry3 = { true, true, true, true, "STR_FEATURES", featureStr };

            stringEntryList.list.push_back(newEntry1);
            stringEntryList.list.push_back(newEntry2);
            stringEntryList.list.push_back(newEntry3);

            break;
        }
    }
}

void DataSet::validateLists()
{
    for (const auto &stringEntryList : stringEntryLists)
    {
        for (const auto &stringEntry : stringEntryList.list)
        {
            // Check for maximum allowed string length
            if (stringEntry.string.length() > 255) ERROR("string cannot be longer than 255 characters");

            // Check mor maximum keyword length
            if (stringEntryList.type == ListType::KEYWORDS)
            {
                if (stringEntry.string.length() > 16) ERROR("keyword cannot be longer than 16 characters");
                tk__max_keyword_len = std::max(tk__max_keyword_len, (uint8_t) stringEntry.string.length());
            }

            // Update maximum alias length too
            maxAliasLen = std::max(maxAliasLen, stringEntry.alias.length());

            for (const auto &character : stringEntry.string)
            {
                if ((unsigned char) character >= 0x80)
                {
                    ERROR(std::string("character above 0x80 in string '") + stringEntry.string + "'");
                }
            }           
        }
    }
}

void DataSet::encodeStringsDict()
{
    DictEncoder dictEncoder;

    // Add strings for dictionary compresssion

    for (uint8_t idx = 0; idx < stringEntryLists.size(); idx++)
    {
        const auto &stringEntryList = stringEntryLists[idx];
        auto &stringEncodedList     = stringEncodedLists[idx];

        // Skip lists not to be encoded using the dictionary
        if (!isCompressionLvl2(stringEntryList)) continue;

        stringEncodedList.resize(stringEntryList.list.size());
        for (uint8_t idxEntry = 0; idxEntry < stringEntryList.list.size(); idxEntry++)
        {
            dictEncoder.addString(stringEntryList.list[idxEntry].string,
                                  &stringEncodedList[idxEntry]);
        }
    }

    // Perform the compression

    StringEntryList dictionary;
    dictEncoder.process(dictionary);

    // Add new lists

    stringEntryLists.push_back(dictionary);
    stringEncodedLists.emplace_back();
}

void DataSet::calculateFrequencies()
{
    as1n.clear();
    as3n.clear();
   
    std::map<char, uint16_t> freqMapGeneral;  // general character frequency map
    std::map<char, uint16_t> freqMapKeywords; // frequency map for keywords

    // Calculate frequencies of characters in the strings

    for (const auto &stringEntryList : stringEntryLists)
    {
        // Skip lists encoded by the dictionary
        if (isCompressionLvl2(stringEntryList)) continue;

        for (const auto &stringEntry : stringEntryList.list)
        {
            if (!isRelevant(stringEntry)) continue;

            for (const auto &character : stringEntry.string)
            {               
                freqMapGeneral[character]++;
                if (stringEntryList.type == ListType::KEYWORDS) freqMapKeywords[character]++;
            }
        }
    }
   
    // Sort characters by frequency
   
    std::vector<char> freqVector1;
   
    for (auto iter = freqMapGeneral.begin(); iter != freqMapGeneral.end(); ++iter)
    {
        freqVector1.push_back(iter->first);
    }
   
    std::sort(freqVector1.begin(), freqVector1.end(), [&freqMapGeneral](char e1, char e2)
              { return freqMapGeneral[e2] < freqMapGeneral[e1]; });

    // Check if minimal amount of characters needed, below 15 is not supported by the 6502 side code

    if (freqVector1.size() < 15) ERROR(std::string("not enough distinct characters in layout '") + layoutName() + "', at least 15 needed");

    // Extract 14 most frequent characters to be encoded as 1 nibble
   
    for (uint8_t idx = 0; idx < 14; idx++)
    {
        as1n.push_back(freqVector1[idx]);
    }
   
    // Now sort them by frequency in keywords, in descending order - this will speed up the tokenizer a little
   
    std::sort(as1n.begin(), as1n.end(), [&freqMapKeywords](char e1, char e2) { return freqMapKeywords[e2] > freqMapKeywords[e1]; });

    // Extract characters to be encoded as 3 nibbles, which actually exist in keywords

    std::vector<char> freqVector2;

    tk__packed_as_3n = 0;
    for (uint8_t idx = 14; idx < freqVector1.size(); idx++)
    {
        const auto &character = freqVector1[idx];
       
        if (freqMapKeywords[character] > 0)
        {
            as3n.push_back(character);
            tk__packed_as_3n++;
        }
        else
        {
            freqVector2.push_back(character);
        }
    }
    tk__packed_as_3n = std::max(tk__packed_as_3n, (uint8_t) 1);

    // Again, sort them by frequency in keywords, in descending order - this will speed up the tokenizer a little
   
    std::sort(as3n.begin(), as3n.end(), [&freqMapKeywords](char e1, char e2) { return freqMapKeywords[e2] > freqMapKeywords[e1]; });

    // Finally extract the remaining characters to be encoded as 3 nibbles

    for (const auto &character : freqVector2)
    {
        as3n.push_back(character);
    }
}

void DataSet::encodeByFreq(const std::string &plain, StringEncoded &encoded) const
{
    bool fullByte = true;

    auto push1n = [&](uint8_t val) // push 1 nibble - encoded character or 0xF mark
    {
        if (fullByte)
        {
            encoded.push_back(val);
            fullByte = false;
        }
        else
        {
            encoded.back() += val * 0x10;
            fullByte = true;
        }
    };

    auto push2n = [&](uint8_t val) // push the remaining nibbles for 3-niobble encoded characters
    {
        if (fullByte)
        {
            encoded.push_back(val);
        }
        else
        {
            // Encode byte in a way to be easily decoded by 6502
            encoded.back() += (val / 0x10) * 0x10;
            encoded.push_back(val % 0x10);           
        }
    };

    // Encode every single character by frequency, put them in the output vector

    for (const char &character : plain)
    {
        auto iterEncoding1 = std::find(as1n.begin(), as1n.end(), character);
        if (iterEncoding1 != as1n.end())
        {
            push1n(std::distance(as1n.begin(), iterEncoding1) + 1);
        }
        else
        {
            push1n(0x0F);

            auto iterEncoding3 = std::find(as3n.begin(), as3n.end(), character);
            if (iterEncoding3 == as3n.end())
            {
                ERROR("internal error in 'encodeByFreq'");
            }
            push2n(std::distance(as3n.begin(), iterEncoding3) + 1);
        }
    }

    // Make sure the last byte of encoded stream is 0

    if (encoded.size() == 0 || encoded.back() != 0) encoded.push_back(0);
}

void DataSet::encodeStringsFreq()
{
    // Encode every relevant string from every list - by character frequency

    for (uint8_t idx = 0; idx < stringEntryLists.size(); idx++)
    {
        const auto &stringEntryList = stringEntryLists[idx];
        auto &stringEncodedList = stringEncodedLists[idx];

        // Skip lists encoded by the dictionary
        if (isCompressionLvl2(stringEntryList)) continue;

        // Perform frequency encoding of the list

        for (const auto &stringEntry : stringEntryList.list)
        {
            stringEncodedList.emplace_back();
            auto &stringEncoded = stringEncodedList.back();

            if (isRelevant(stringEntry))
            {
                encodeByFreq(stringEntry.string, stringEncoded);
            }
        }
    }
}

void DataSet::putCharEncoding(std::ostringstream &stream, uint8_t idx, char character, bool is3n)
{
    stream << "\t.byte $" << std::uppercase << std::hex <<
              std::setfill('0') << std::setw(2) << +character <<
              "    // " << std::setfill(is3n ? '0' : ' ') << std::setw(2) << +idx;

    std::string petscii;

    if (character == 0x20)
    {
        petscii = " = SPACE";
    }
    else if (character == 0x27)
    {
        petscii = " = APOSTROPHE";
    }
    else if (character == 0x0D)
    {
        petscii = " = RETURN";
    }
    else if (character > ' ' && character < 'a')
    {
        petscii = std::string(" = '") + character + "'";
    }

    stream << petscii << std::endl;
}

void DataSet::prepareOutput_1n_3n(std::ostringstream &stream)
{
    uint8_t idx;

    // Export all nibble-encoded characters

    stream << std::endl << ".macro put_packed_as_1n() // characters encoded as 1 nibble" << std::endl << "{" << std::endl;
   
    idx = 0;
    for (const auto& encoding : as1n)
    {
        putCharEncoding(stream, ++idx, encoding, false);
    }
   
    stream << "}" << std::endl;

    // Export all byte-encoded characters

    stream << std::endl << ".macro put_packed_as_3n() // characters encoded as 3 nibbles" << std::endl << "{" << std::endl;

    idx = 0;
    for (const auto& encoding : as3n)
    {
        if (idx == tk__packed_as_3n) stream << std::endl <<
            "\t// Characters below are not used by any BASIC keyword" << std::endl << std::endl;

        putCharEncoding(stream, ++idx, encoding, true);
    }

    stream << "}" << std::endl;
}

void DataSet::prepareOutput_labels(std::ostringstream &stream,
                                   const StringEntryList &stringEntryList,
                                   const StringEncodedList &stringEncodedList)
{
    // For the dictionary we do not have any labels
    if (stringEntryList.type == ListType::DICTIONARY) return;

    stream << std::endl;
    for (uint8_t idx = 0; idx < stringEncodedList.size(); idx++)
    {
        const auto &stringEntry   = stringEntryList.list[idx];
        const auto &stringEncoded = stringEncodedList[idx];

        if (!stringEncoded.empty())
        {
            stream << ".label IDX__" << stringEntry.alias <<
                      std::string(maxAliasLen - stringEntry.alias.length(), ' ') << " = $" <<
                      std::uppercase << std::hex << std::setfill('0') << std::setw(2) << +idx << std::endl;
        }
    }
}

void DataSet::prepareOutput_packed(std::ostringstream &stream,
                                   const StringEntryList &stringEntryList,
                                   const StringEncodedList &stringEncodedList)
{
    if (isCompressionLvl2(stringEntryList))
    {
        stream << std::endl << ".macro put_packed_dict_";
    }
    else
    {
        stream << std::endl << ".macro put_packed_freq_";           
    }

    stream << stringEntryList.name << "()" << std::endl << "{" << std::endl;

    enum LastStr { NONE, SKIPPED, WRITTEN } lastStr = LastStr::NONE;
    for (uint8_t idxString = 0; idxString < stringEncodedList.size(); idxString++)
    {
        const auto &stringEncoded = stringEncodedList[idxString];

        if (stringEncoded.empty())
        {
            if (stringEntryList.type == ListType::DICTIONARY) ERROR("internal error"); // should never happen

            if (lastStr == LastStr::WRITTEN) stream << std::endl;
            stream << "\t.byte $00    // skipped " << stringEntryList.list[idxString].alias << std::endl;
            lastStr = LastStr::SKIPPED;
        }
        else
        {
            if (lastStr != LastStr::NONE) stream << std::endl;

            // Output the label - as a comment

            if (stringEntryList.type != ListType::DICTIONARY)
            {
                stream << "\t// IDX__" << stringEntryList.list[idxString].alias << std::endl;
            }

            // Output the source string - as a comment

            stream << "\t// '";
            for (auto &character : stringEntryList.list[idxString].string)
            {
                if (character >= 32 && character <= 132 && character != 39 && character != 34)
                {
                    stream << character;
                }
                else if (character == 13)
                {
                    stream << "<return>";
                }
                else
                {
                    stream << "_";
                }
            }
            stream << "'" << std::endl;

            // Output the encoding

            stream << "\t.byte ";

            bool first = true;
            for (const auto &charEncoded : stringEncoded)
            {
                if (first)
                {
                    first = false;
                }
                else
                {
                    stream << ", ";
                }

                stream << "$" << std::uppercase << std::hex << std::setfill('0') << std::setw(2) << +charEncoded;
            }

            stream << std::endl;
            lastStr = LastStr::WRITTEN;
        }
    }

    // For the token list - put the 'end of keywords' mark

    if (stringEntryList.type == ListType::KEYWORDS)
    {
        stream << std::endl << "\t// Marker - end of the keyword list" << std::endl;
        stream << "\t.byte $FF, $FF" << std::endl;
    }

    stream << "}" << std::endl;
}

void DataSet::prepareOutput()
{
    // Convert our encoded strings to a KickAssembler source

    std::ostringstream stream;
    stream << std::endl << "#if ROM_LAYOUT_" << layoutName() << std::endl;

    // Export 1-nibble and 3-nibble encoding data

    prepareOutput_1n_3n(stream);

    // Export additional data for the tokenizer

    stream << std::endl << ".label TK__PACKED_AS_3N    = $" << std::hex << +tk__packed_as_3n <<
              std::endl << ".label TK__MAX_KEYWORD_LEN = "  << std::dec << +tk__max_keyword_len << std::endl;

    // Export encoded strings

    for (uint8_t idx = 0; idx < stringEntryLists.size(); idx++)
    {
        const auto &stringEntryList   = stringEntryLists[idx];
        const auto &stringEncodedList = stringEncodedLists[idx];

        if (stringEncodedList.empty()) continue;

        // Export labels for the current list

        prepareOutput_labels(stream, stringEntryList, stringEncodedList);

        // For the token list - put the number of tokens available

        if (stringEntryList.type == ListType::KEYWORDS)
        {
            stream << std::endl << ".label TK__MAXTOKEN_" << stringEntryList.name << " = " <<
                      std::dec << stringEncodedList.size() << std::endl;
        }

        // Export the packed data

        prepareOutput_packed(stream, stringEntryList, stringEncodedList);
    }

    // Finalize the file stream

    stream << std::endl << "#endif // ROM_LAYOUT_" << layoutName() << std::endl;
    outFileContent = stream.str();
}


//
// Common helper functions
//

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
       
        // Skip lines which are not preprocessor definitions
       
        if (workStr.empty() || workStr[0] != '#') continue;
       
        // Make sure this is '#define '
       
        if (!std::regex_match(workStr, std::regex("^#define[ \t].*")))
        {
            ERROR(std::string("only '#define' preprocessor directives allowed in config files - line ") + std::to_string(lineNum));
        }

        // Get rid of the directive and trailing spaces/comments
   
        workStr = std::regex_replace(workStr, std::regex("^#define[ \t]+"), "");
        workStr = std::regex_replace(workStr, std::regex("[ \t]+.*"), "");

        // Add definitin to config option map

        if (workStr.empty()) ERROR(std::string("error parsing config file - line ") + std::to_string(lineNum));

        GLOBAL_ConfigOptions[workStr] = true;
    }
   
    cnfFile.close();
}

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

void writeStrings()
{
    std::string outputString;
   
    if (GLOBAL_ConfigOptions["CONFIG_PLATFORM_COMMANDER_X16"])
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
    else if (GLOBAL_ConfigOptions["CONFIG_PLATFORM_COMMODORE_64"] && GLOBAL_ConfigOptions["CONFIG_MB_MEGA_65"])
    {
        DataSetM65 dataSetM65;

        // Add input data to computation objects

        dataSetM65.addStrings(GLOBAL_Keywords_V2);
        dataSetM65.addStrings(GLOBAL_Keywords_01);
        dataSetM65.addStrings(GLOBAL_Keywords_02);
        dataSetM65.addStrings(GLOBAL_Errors);
        dataSetM65.addStrings(GLOBAL_MiscStrings);
       
        // Retrieve the results
       
        outputString = dataSetM65.getOutput();
    }
    else if (GLOBAL_ConfigOptions["CONFIG_PLATFORM_COMMODORE_64"] && GLOBAL_ConfigOptions["CONFIG_MB_ULTIMATE_64"])
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
    else if (GLOBAL_ConfigOptions["CONFIG_PLATFORM_COMMODORE_64"])
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

    outFile << "//\n// Generated file - do not edit\n//";

    // Write packed strings

    outFile << std::endl << std::endl;
    outFile << outputString;
    outFile << std::endl << std::endl;

    // Close the file
  
    outFile.close();

    std::cout << std::string("Compressed strings written to: ") + CMD_outFile + "\n\n";
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
