//
// Utility to generate compressed messages and BASIC tokens
//

// XXX parse the config file to select the string set (STD, M65, X16) and generate feature string
// XXX use DualStream class for logging
// XXX use dictionary compression by finding the set of non-overlapping strings that can be concatenated
//     to produce full set of strings; some idea for the algorithm (not sure if proper one) is available here
//     https://stackoverflow.com/questions/9195676/finding-the-smallest-number-of-substrings-to-represent-a-set-of-strings
//     needs some investigation...

#include "common.h"

#include <unistd.h>

#include <algorithm>
#include <fstream>
#include <iomanip>
#include <sstream>
#include <map>
#include <vector>

//
// Command line settings
//

std::string CMD_outFile = "out.s";

//
// Type definition for text/tokens to generate
//

typedef struct StringEntry
{
	bool        enabledSTD;     // whether enabled for basic build 
	bool        enabledM65;     // whether enabled for Mega65 build
	bool        enabledX16;     // whether enabled for Commander X16 build
	std::string alias;          // alias, for the assembler
	std::string string;         // string/token
	uint8_t     abbrevLen = 0;  // length of token abbreviation
} StringEntry;

enum class ListType
{
	KEYWORDS,
	STRINGS_BASIC
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
    // STD    M65    X16 
	{ true,  true,  true,  "KV2_80",   "END",        2 }, // https://www.landsnail.com/a2ref.htm
	{ true,  true,  true,  "KV2_81",   "FOR",        2 }, // https://www.landsnail.com/a2ref.htm
	{ true,  true,  true,  "KV2_82",   "NEXT",       2 }, // https://www.landsnail.com/a2ref.htm
	{ true,  true,  true,  "KV2_83",   "DATA",       2 }, // https://www.landsnail.com/a2ref.htm
	{ true,  true,  true,  "KV2_84",   "INPUT#",     2 }, // https://www.atariarchives.org/creativeatari/Using_Disks_With_Atari_Basic.php
	{ true,  true,  true,  "KV2_85",   "INPUT",      0 }, // https://www.landsnail.com/a2ref.htm
	{ true,  true,  true,  "KV2_86",   "DIM",        2 }, // https://www.landsnail.com/a2ref.htm
	{ true,  true,  true,  "KV2_87",   "READ",       2 }, // https://www.landsnail.com/a2ref.htm
	{ true,  true,  true,  "KV2_88",   "LET",        2 }, // https://en.wikipedia.org/wiki/Atari_BASIC
	{ true,  true,  true,  "KV2_89",   "GOTO",       2 }, // https://www.landsnail.com/a2ref.htm
	{ true,  true,  true,  "KV2_8A",   "RUN",        2 }, // https://www.landsnail.com/a2ref.htm
	{ true,  true,  true,  "KV2_8B",   "IF",         0 }, // https://www.landsnail.com/a2ref.htm
	{ true,  true,  true,  "KV2_8C",   "RESTORE",    3 }, // https://www.landsnail.com/a2ref.htm
	{ true,  true,  true,  "KV2_8D",   "GOSUB",      3 }, // https://www.landsnail.com/a2ref.htm
	{ true,  true,  true,  "KV2_8E",   "RETURN",     3 }, // https://www.landsnail.com/a2ref.htm
	{ true,  true,  true,  "KV2_8F",   "REM",        0 }, // https://www.landsnail.com/a2ref.htm
	{ true,  true,  true,  "KV2_90",   "STOP",       2 }, // https://www.landsnail.com/a2ref.htm
	{ true,  true,  true,  "KV2_91",   "ON",         0 }, // https://www.landsnail.com/a2ref.htm
	{ true,  true,  true,  "KV2_92",   "WAIT",       2 }, // http://www.picaxe.com/BASIC-Commands/Time-Delays/wait/
	{ true,  true,  true,  "KV2_93",   "LOAD",       2 }, // https://www.landsnail.com/a2ref.htm
	{ true,  true,  true,  "KV2_94",   "SAVE",       2 }, // https://www.landsnail.com/a2ref.htm
	{ true,  true,  true,  "KV2_95",   "VERIFY",     2 }, // https://en.wikipedia.org/wiki/Sinclair_BASIC
	{ true,  true,  true,  "KV2_96",   "DEF",        2 }, // https://www.landsnail.com/a2ref.htm
	{ true,  true,  true,  "KV2_97",   "POKE",       2 }, // https://www.landsnail.com/a2ref.htm
	{ true,  true,  true,  "KV2_98",   "PRINT#",     2 }, // https://www.atariarchives.org/creativeatari/Using_Disks_With_Atari_Basic.php
	{ true,  true,  true,  "KV2_99",   "PRINT",      0 }, // https://www.landsnail.com/a2ref.htm
	{ true,  true,  true,  "KV2_9A",   "CONT",       2 }, // https://www.landsnail.com/a2ref.htm
	{ true,  true,  true,  "KV2_9B",   "LIST",       2 }, // https://www.landsnail.com/a2ref.htm
	{ true,  true,  true,  "KV2_9C",   "CLR",        2 }, // Apple I Replica Creation: Back to the Garage, p125
	{ true,  true,  true,  "KV2_9D",   "CMD",        2 }, // https://en.wikipedia.org/wiki/List_of_DOS_commands
	{ true,  true,  true,  "KV2_9E",   "SYS",        2 }, // https://www.lifewire.com/dos-commands-4070427
	{ true,  true,  true,  "KV2_9F",   "OPEN",       2 }, // https://www.atariarchives.org/creativeatari/Using_Disks_With_Atari_Basic.php
	// STD    M65    X16 
	{ true,  true,  true,  "KV2_A0",   "CLOSE",      3 }, // https://www.atariarchives.org/creativeatari/Using_Disks_With_Atari_Basic.php
	{ true,  true,  true,  "KV2_A1",   "GET",        2 }, // https://www.landsnail.com/a2ref.htm
	{ true,  true,  true,  "KV2_A2",   "NEW",        0 }, // https://www.landsnail.com/a2ref.htm
	{ true,  true,  true,  "KV2_A3",   "TAB(",       2 }, // http://www.antonis.de/qbebooks/gwbasman/tab.html
	{ true,  true,  true,  "KV2_A4",   "TO",         0 }, // https://www.landsnail.com/a2ref.htm
	{ true,  true,  true,  "KV2_A5",   "FN",         0 }, // https://www.landsnail.com/a2ref.htm
	{ true,  true,  true,  "KV2_A6",   "SPC(",       2 }, // http://www.antonis.de/qbebooks/gwbasman/spc.html
	{ true,  true,  true,  "KV2_A7",   "THEN",       2 }, // https://www.landsnail.com/a2ref.htm
	{ true,  true,  true,  "KV2_A8",   "NOT",        2 }, // https://www.landsnail.com/a2ref.htm
	{ true,  true,  true,  "KV2_A9",   "STEP",       2 }, // https://www.landsnail.com/a2ref.htm
	{ true,  true,  true,  "KV2_AA",   "+",          0 }, // https://www.landsnail.com/a2ref.htm
	{ true,  true,  true,  "KV2_AB",   "-",          0 }, // https://www.landsnail.com/a2ref.htm
	{ true,  true,  true,  "KV2_AC",   "*",          0 }, // https://www.landsnail.com/a2ref.htm
	{ true,  true,  true,  "KV2_AD",   "/",          0 }, // https://www.landsnail.com/a2ref.htm
	{ true,  true,  true,  "KV2_AE",   "^",          0 }, // https://www.landsnail.com/a2ref.htm
	{ true,  true,  true,  "KV2_AF",   "AND",        2 }, // https://www.landsnail.com/a2ref.htm
	{ true,  true,  true,  "KV2_B0",   "OR",         0 }, // https://www.landsnail.com/a2ref.htm
	{ true,  true,  true,  "KV2_B1",   ">",          0 }, // https://www.landsnail.com/a2ref.htm
	{ true,  true,  true,  "KV2_B2",   "=",          0 }, // https://www.landsnail.com/a2ref.htm
	{ true,  true,  true,  "KV2_B3",   "<",          0 }, // https://www.landsnail.com/a2ref.htm
	{ true,  true,  true,  "KV2_B4",   "SGN",        2 }, // https://www.landsnail.com/a2ref.htm
	{ true,  true,  true,  "KV2_B5",   "INT",        0 }, // https://www.landsnail.com/a2ref.htm
	{ true,  true,  true,  "KV2_B6",   "ABS",        2 }, // https://www.landsnail.com/a2ref.htm
	{ true,  true,  true,  "KV2_B7",   "USR",        2 }, // https://www.landsnail.com/a2ref.htm
	{ true,  true,  true,  "KV2_B8",   "FRE",        2 }, // http://www.antonis.de/qbebooks/gwbasman/fre.html
	{ true,  true,  true,  "KV2_B9",   "POS",        0 }, // http://www.antonis.de/qbebooks/gwbasman/pos.html
	{ true,  true,  true,  "KV2_BA",   "SQR",        2 }, // https://www.landsnail.com/a2ref.htm
	{ true,  true,  true,  "KV2_BB",   "RND",        2 }, // https://www.landsnail.com/a2ref.htm
	{ true,  true,  true,  "KV2_BC",   "LOG",        0 }, // https://www.landsnail.com/a2ref.htm
	{ true,  true,  true,  "KV2_BD",   "EXP",        2 }, // https://www.landsnail.com/a2ref.htm
	{ true,  true,  true,  "KV2_BE",   "COS",        0 }, // https://www.landsnail.com/a2ref.htm
	{ true,  true,  true,  "KV2_BF",   "SIN",        2 }, // https://www.landsnail.com/a2ref.htm
	// STD    M65    X16 
	{ true,  true,  true,  "KV2_C0",   "TAN",        0 }, // https://www.landsnail.com/a2ref.htm
	{ true,  true,  true,  "KV2_C1",   "ATN",        2 }, // https://www.landsnail.com/a2ref.htm
	{ true,  true,  true,  "KV2_C2",   "PEEK",       2 }, // https://www.landsnail.com/a2ref.htm
	{ true,  true,  true,  "KV2_C3",   "LEN",        0 }, // https://www.landsnail.com/a2ref.htm
	{ true,  true,  true,  "KV2_C4",   "STR$",       3 }, // https://www.landsnail.com/a2ref.htm
	{ true,  true,  true,  "KV2_C5",   "VAL",        2 }, // https://www.landsnail.com/a2ref.htm
	{ true,  true,  true,  "KV2_C6",   "ASC",        2 }, // https://www.landsnail.com/a2ref.htm
	{ true,  true,  true,  "KV2_C7",   "CHR$",       2 }, // https://www.landsnail.com/a2ref.htm
	{ true,  true,  true,  "KV2_C8",   "LEFT$",      3 }, // https://www.landsnail.com/a2ref.htm
	{ true,  true,  true,  "KV2_C9",   "RIGHT$",     2 }, // https://www.landsnail.com/a2ref.htm
	{ true,  true,  true,  "KV2_CA",   "MID$",       2 }, // https://www.landsnail.com/a2ref.htm
	{ true,  true,  true,  "KV2_CB",   "GO",         0 }, // https://en.wikipedia.org/wiki/Goto
} };

// extended BASIC keywords - reserved for generic (hardware independent) BASIC commands

const StringEntryList GLOBAL_Keywords_CC =  { ListType::KEYWORDS, "keywords_CC",
{
    // STD    M65    X16 
	{ false, false, false, "KCC_01",   "BLOAD",        }, // http://www.antonis.de/qbebooks/gwbasman/bload.html
	{ false, false, false, "KCC_02",   "BSAVE",        }, // http://www.antonis.de/qbebooks/gwbasman/bload.html
	{ false, false, false, "KCC_03",   "BVERIFY",      },
} };

// extended BASIC keywords - reserved for BASIC commands likely making sense on most C64-compatible machines

const StringEntryList GLOBAL_Keywords_CD =  { ListType::KEYWORDS, "keywords_CD",
{
    // STD    M65    X16 
	{ false, false, false, "KCD_01",   "SLOW",         }, // https://en.wikipedia.org/wiki/Sinclair_BASIC - ZX81 variant
	{ false, false, false, "KCD_02",   "FAST",         }, // https://en.wikipedia.org/wiki/Sinclair_BASIC - ZX81 variant
} };

// extended BASIC keywords - reserved for board-specific BASIC commands

const StringEntryList GLOBAL_Keywords_CE =  { ListType::KEYWORDS, "keywords_CE",
{
    // STD    M65    X16 
	{ false, false, false, "KCE_01",   "TESTCMD",      },
} };

const StringEntryList GLOBAL_Keywords_CF =  { ListType::KEYWORDS, "keywords_CF",
{
    // STD    M65    X16 
	{ false, false, false, "KCF_01",   "TESTCMD",      },
} };

// extended BASIC keywords - reserved for generic (hardware independent) BASIC functions

const StringEntryList GLOBAL_Keywords_D0 =  { ListType::KEYWORDS, "keywords_D0",
{
    // STD    M65    X16 
	{ false, false, false, "KD0_01",   "TESTFUN",      },
} };

// extended BASIC keywords - reserved for BASIC functions likely making sense on most C64-compatible machines

const StringEntryList GLOBAL_Keywords_D1 =  { ListType::KEYWORDS, "keywords_D1",
{
    // STD    M65    X16 
	{ false, false, false, "KD1_01",   "TESTFUN",       },
} };

// extended BASIC keywords - reserved for board-specific BASIC functions

const StringEntryList GLOBAL_Keywords_D2 =  { ListType::KEYWORDS, "keywords_D2",
{
    // STD    M65    X16 
	{ false, false, false, "KD2_01",   "TESTFUN",      },
} };

const StringEntryList GLOBAL_Keywords_D3 =  { ListType::KEYWORDS, "keywords_D3",
{
    // STD    M65    X16 
	{ false, false, false, "KD3_01",   "TESTFUN",      },
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
	// STD    M65    X16   --- error strings compatible with CBM BASIC V2
	{ true,  true,  true,  "EV2_01", "TOO MANY FILES"           },
	{ true,  true,  true,  "EV2_02", "FILE OPEN"                },
	{ true,  true,  true,  "EV2_03", "FILE NOT OPEN"            },
	{ true,  true,  true,  "EV2_04", "FILE NOT FOUND"           },
	{ true,  true,  true,  "EV2_05", "DEVICE NOT PRESENT"       },
	{ true,  true,  true,  "EV2_06", "NOT INPUT FILE"           },
	{ true,  true,  true,  "EV2_07", "NOT OUTPUT FILE"          },
	{ true,  true,  true,  "EV2_08", "MISSING FILENAME"         },
	{ true,  true,  true,  "EV2_09", "ILLEGAL DEVICE NUMBER"    },
	{ true,  true,  true,  "EV2_0A", "NEXT WITHOUT FOR"         },
	{ true,  true,  true,  "EV2_0B", "SYNTAX"                   },
	{ true,  true,  true,  "EV2_0C", "RETURN WITHOUT GOSUB"     },
	{ true,  true,  true,  "EV2_0D", "OUT OF DATA"              },
	{ true,  true,  true,  "EV2_0E", "ILLEGAL QUANTITY"         },
	{ true,  true,  true,  "EV2_0F", "OVERFLOW"                 },
	{ true,  true,  true,  "EV2_10", "OUT OF MEMORY"            },
	{ true,  true,  true,  "EV2_11", "UNDEF\'D STATEMENT"       },
	{ true,  true,  true,  "EV2_12", "BAD SUBSCRIPT"            },
	{ true,  true,  true,  "EV2_13", "REDIM\'D ARRAY"           },
	{ true,  true,  true,  "EV2_14", "DIVISION BY ZERO"         },
	{ true,  true,  true,  "EV2_15", "ILLEGAL DIRECT"           },
	{ true,  true,  true,  "EV2_16", "TYPE MISMATCH"            },
	{ true,  true,  true,  "EV2_17", "STRING TOO LONG"          },
	{ true,  true,  true,  "EV2_18", "FILE DATA"                },
	{ true,  true,  true,  "EV2_19", "FORMULA TOO COMPLEX"      },
	{ true,  true,  true,  "EV2_1A", "CAN\'T CONTINUE"          },
	{ true,  true,  true,  "EV2_1B", "UNDEF\'D FUNCTION"        },
	{ true,  true,  true,  "EV2_1C", "VERIFY"                   },
	{ true,  true,  true,  "EV2_1D", "LOAD"                     },
	{ true,  true,  true,  "EV2_1E", "BREAK"                    },
	// STD    M65    X16   --- error strings compatible with CBM BASIC V7
	{ false, false, false, "EV7_1F", "CAN'T RESUME"             }, // not used for now
	{ false, false, false, "EV7_20", "LOOP NOT FOUND"           }, // not used for now
	{ false, false, false, "EV7_21", "LOOP WITHOUT DO"          }, // not used for now
	{ false, false, false, "EV7_22", "DIRECT MODE ONLY"         }, // not used for now
	{ false, false, false, "EV7_23", "NO GRAPHICS AREA"         }, // not used for now
	{ false, false, false, "EV7_24", "BAD DISK"                 }, // not used for now
	{ false, false, false, "EV7_25", "BEND NOT FOUND"           }, // not used for now
	{ false, false, false, "EV7_26", "LINE NUMBER TOO LARGE"    }, // not used for now
	{ false, false, false, "EV7_27", "UNRESOLVED REFERENCE"     }, // not used for now
	{ true,   true,  true, "EV7_28", "NOT IMPLEMENTED"          }, // this message actually differs rom CBM one
	{ false, false, false, "EV7_29", "FILE READ"                }, // not used for now
	// STD    M65    X16   --- error strings specific to OpenROMs, not present in CBM BASIC dialects
	{ true,  true,  true,  "EOR_2A", "MEMORY CORRUPT"           },	
} };

// BASIC errors - miscelaneous strings

const StringEntryList GLOBAL_MiscStrings =  { ListType::STRINGS_BASIC, "misc",
{
	// STD    M65    X16   --- misc strings as on CBM machines
	{ true,  true,  true,  "STR_BYTES",   " BASIC BYTES FREE"   }, // https://github.com/stefanhaustein/expressionparser
	{ true,  true,  true,  "STR_READY",   "\rREADY.\r"          }, // https://www.ibm.com/support/knowledgecenter/zosbasics/com.ibm.zos.zconcepts/zconc_whatistsonative.htm https://github.com/stefanhaustein/expressionparser
	{ true,  true,  true,  "STR_ERROR",   " ERROR"              }, // simply the word error that is attached to the other parts of messages https://fjkraan.home.xs4all.nl/comp/apple2faq/app2asoftfaq.html
	{ true,  true,  true,  "STR_IN",      " IN "                },
	// STD    M65    X16   --- misc strings specific to OpenROMs, not present in CBM ROMs
	{ true,  true,  true,  "STR_BRK_AT",  "\rBRK AT $"          },
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

//
// Work class definitions
//

class DataSet
{
public:

	void addStrings(const StringEntryList &stringList);

	const std::string &getOutput();

private:

	void process();

	void calculateFrequencies();
	void encodeStrings();

	void encodeByFreq(const std::string &plain, StringEncoded &encoded) const;

	void prepareOutput();

	void putCharEncoding(std::ostringstream &stream, uint8_t idx, char character, bool is3n);

	virtual bool isRelevant(const StringEntry &entry) const = 0;
	virtual std::string layoutName() const = 0;

	std::vector<StringEntryList>          stringEntryLists;
	std::vector<StringEncodedList>        stringEncodedLists;

	std::vector<char>                     as1n; // list of bytes to be encoded as 1 nibble
	std::vector<char>                     as3n; // list of bytes to be encoded as 3 nibbles

	uint8_t                               tk__packed_as_3n    = 0;
	uint8_t                               tk__max_keyword_len = 0;

	size_t                                maxAliasLen      = 0;
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

class DataSetX16 : public DataSet
{
	bool isRelevant(const StringEntry &entry) const { return entry.enabledX16; }
	std::string layoutName() const { return "X16"; }
};

//
// Work class implementation
//

void DataSet::addStrings(const StringEntryList &stringList)
{
	// Import the new list of strings

	stringEntryLists.push_back(stringList);

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
	std::cout << "Processing layout '" << layoutName() << "'" << std::endl;

	calculateFrequencies();
	encodeStrings();
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

void DataSet::calculateFrequencies()
{
	as1n.clear();
	as3n.clear();
	
	std::map<char, uint16_t> freqMapGeneral;  // general character frequency map
	std::map<char, uint16_t> freqMapKeywords; // frequency map for keywords

	// Calculate frequencies of characters in the strings

	for (const auto &stringEntryList : stringEntryLists)
	{
		for (const auto &stringEntry : stringEntryList.list)
		{
			if (!isRelevant(stringEntry)) continue;

			// Check for maximum allowed string length
			if (stringEntry.string.length() > 255) ERROR("string cannot be longer than 255 characters");

			// Check mor maximum keyword length
			if (stringEntryList.type == ListType::KEYWORDS)
			{
				if (stringEntry.string.length() > 8) ERROR("keyword cannot be longer than 8 characters");
				tk__max_keyword_len = std::max(tk__max_keyword_len, (uint8_t) stringEntry.string.length());
			}

			// Update maximum alias length too
			maxAliasLen = std::max(maxAliasLen, stringEntry.alias.length());

			for (const auto &character : stringEntry.string)
			{
				if (character >= 0x80)
				{
					ERROR(std::string("character above 0x80 in string '") + stringEntry.string + "'");
				}
				
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

void DataSet::encodeStrings()
{
	stringEncodedLists.clear();

	// Encode every relevant string from every list - by character frequency

	for (const auto &stringEntryList : stringEntryLists)
	{
		stringEncodedLists.emplace_back();
		auto &stringEncodedList = stringEncodedLists.back();

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

void DataSet::prepareOutput()
{
	// Convert our encoded strings to a KickAssembler source

	std::ostringstream stream;
	stream << std::endl << "#if ROM_LAYOUT_" << layoutName() << std::endl;

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

	// Export additional data for the tokenizer

	stream << std::endl << ".label TK__PACKED_AS_3N    = $" << std::hex << +tk__packed_as_3n <<
              std::endl << ".label TK__MAX_KEYWORD_LEN = "  << std::dec << +tk__max_keyword_len << std::endl;

	// Export frequency-encoded strings

	for (uint8_t idxList = 0; idxList < stringEntryLists.size(); idxList++)
	{
		const auto &stringEntryList   = stringEntryLists[idxList];
		const auto &stringEncodedList = stringEncodedLists[idxList];

		stream << std::endl;
		for (uint8_t idxString = 0; idxString < stringEncodedList.size(); idxString++)
		{
			const auto &stringEntry   = stringEntryList.list[idxString];
			const auto &stringEncoded = stringEncodedList[idxString];

			if (!stringEncoded.empty())
			{
				stream << ".label IDX__" << stringEntry.alias << std::string(maxAliasLen - stringEntry.alias.length(), ' ') << 
				          " = $" << std::uppercase << std::hex << std::setfill('0') << std::setw(2) << +idxString << std::endl;
			}
		}

		stream << std::endl << ".macro put_freq_packed_" << stringEntryList.name << "()" << std::endl << "{" << std::endl;

		enum LastStr { NONE, SKIPPED, WRITTEN } lastStr = LastStr::NONE;
		for (uint8_t idxString = 0; idxString < stringEncodedList.size(); idxString++)
		{
			const auto &stringEntry   = stringEntryList.list[idxString];
			const auto &stringEncoded = stringEncodedList[idxString];

			if (stringEncoded.empty())
			{
				if (lastStr == LastStr::WRITTEN) stream << std::endl;
				stream << "\t.byte $00    // skipped " << stringEntry.alias << std::endl;
				lastStr = LastStr::SKIPPED;
			}
			else
			{
				if (lastStr != LastStr::NONE) stream << std::endl;

				stream << "\t// IDX__" << stringEntry.alias << std::endl;
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

		// For the token list - pu the 'end of keywords' mark

		if (stringEntryList.type == ListType::KEYWORDS)
		{
			stream << std::endl << "\t// Marker - end of the keyword list" << std::endl;
			stream << "\t.byte $FF, $FF" << std::endl;
		}

		stream << "}" << std::endl;
	}

	// Finalize the file stream

	stream << std::endl << "#endif // ROM_LAYOUT_" << layoutName() << std::endl;
	outFileContent = stream.str();
}


//
// Common helper functions
//

void printUsage()
{
    std::cout << "\n" <<
        "usage: generate_strings [-o <out file>]" << "\n\n";
}

void printBanner()
{
    printBannerLineTop();
    std::cout << "// Generating compressed messages and BASIC tokens" << "\n";
    printBannerLineBottom();
}

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

void writeStrings()
{
	DataSetSTD dataSetSTD;
	DataSetM65 dataSetM65;
	DataSetX16 dataSetX16;

	// Add input data to computation objects

	dataSetSTD.addStrings(GLOBAL_Keywords_V2);
	dataSetSTD.addStrings(GLOBAL_Errors);
	dataSetSTD.addStrings(GLOBAL_MiscStrings);

	dataSetM65.addStrings(GLOBAL_Keywords_V2);
	dataSetM65.addStrings(GLOBAL_Errors);
	dataSetM65.addStrings(GLOBAL_MiscStrings);

	dataSetX16.addStrings(GLOBAL_Keywords_V2);
	dataSetX16.addStrings(GLOBAL_Errors);
	dataSetX16.addStrings(GLOBAL_MiscStrings);

	// Retrieve the results

	std::string outputSTD = dataSetSTD.getOutput();
	std::string outputM65 = dataSetM65.getOutput();
	std::string outputX16 = dataSetX16.getOutput();

    // Remove old file

    unlink(CMD_outFile.c_str());

    // Open output file for writing

    std::ofstream outFile(CMD_outFile, std::fstream::out | std::fstream::trunc);
    if (!outFile.good()) ERROR(std::string("can't open oputput file '") + CMD_outFile + "'");

    // Write header

    outFile << "//\n// Generated file - do not edit\n//";

    // Write packed strings

    outFile << std::endl << std::endl;
    outFile << outputSTD;
    outFile << std::endl << std::endl;
	outFile << outputM65;
    outFile << std::endl << std::endl;    
    outFile << outputX16;  
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

    writeStrings();

    return 0;
}
