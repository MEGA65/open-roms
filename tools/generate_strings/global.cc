
#include "global.h"


//
// Command line settings
//

std::string CMD_outFile = "out.s";
std::string CMD_cnfFile = "";

//
// Options from the configuration file
//

std::map<std::string, bool> GLOBAL_ConfigOptions;

//
// Open ROMs string definitions
//

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
    // STD    CRT    M65    U64    X16
    { true,  true,  true,  true,  true,  "KV2_80",   "END",        2 }, // https://www.landsnail.com/a2ref.htm
    { true,  true,  true,  true,  true,  "KV2_81",   "FOR",        2 }, // https://www.landsnail.com/a2ref.htm
    { true,  true,  true,  true,  true,  "KV2_82",   "NEXT",       2 }, // https://www.landsnail.com/a2ref.htm
    { true,  true,  true,  true,  true,  "KV2_83",   "DATA",       2 }, // https://www.landsnail.com/a2ref.htm
    { true,  true,  true,  true,  true,  "KV2_84",   "INPUT#",     2 }, // https://www.atariarchives.org/creativeatari/Using_Disks_With_Atari_Basic.php
    { true,  true,  true,  true,  true,  "KV2_85",   "INPUT",      0 }, // https://www.landsnail.com/a2ref.htm
    { true,  true,  true,  true,  true,  "KV2_86",   "DIM",        2 }, // https://www.landsnail.com/a2ref.htm
    { true,  true,  true,  true,  true,  "KV2_87",   "READ",       2 }, // https://www.landsnail.com/a2ref.htm
    { true,  true,  true,  true,  true,  "KV2_88",   "LET",        2 }, // https://en.wikipedia.org/wiki/Atari_BASIC
    { true,  true,  true,  true,  true,  "KV2_89",   "GOTO",       2 }, // https://www.landsnail.com/a2ref.htm
    { true,  true,  true,  true,  true,  "KV2_8A",   "RUN",        2 }, // https://www.landsnail.com/a2ref.htm
    { true,  true,  true,  true,  true,  "KV2_8B",   "IF",         0 }, // https://www.landsnail.com/a2ref.htm
    { true,  true,  true,  true,  true,  "KV2_8C",   "RESTORE",    3 }, // https://www.landsnail.com/a2ref.htm
    { true,  true,  true,  true,  true,  "KV2_8D",   "GOSUB",      3 }, // https://www.landsnail.com/a2ref.htm
    { true,  true,  true,  true,  true,  "KV2_8E",   "RETURN",     3 }, // https://www.landsnail.com/a2ref.htm
    { true,  true,  true,  true,  true,  "KV2_8F",   "REM",        0 }, // https://www.landsnail.com/a2ref.htm
    { true,  true,  true,  true,  true,  "KV2_90",   "STOP",       2 }, // https://www.landsnail.com/a2ref.htm
    { true,  true,  true,  true,  true,  "KV2_91",   "ON",         0 }, // https://www.landsnail.com/a2ref.htm
    { true,  true,  true,  true,  true,  "KV2_92",   "WAIT",       2 }, // http://www.picaxe.com/BASIC-Commands/Time-Delays/wait/
    { true,  true,  true,  true,  true,  "KV2_93",   "LOAD",       2 }, // https://www.landsnail.com/a2ref.htm
    { true,  true,  true,  true,  true,  "KV2_94",   "SAVE",       2 }, // https://www.landsnail.com/a2ref.htm
    { true,  true,  true,  true,  true,  "KV2_95",   "VERIFY",     2 }, // https://en.wikipedia.org/wiki/Sinclair_BASIC
    { true,  true,  true,  true,  true,  "KV2_96",   "DEF",        2 }, // https://www.landsnail.com/a2ref.htm
    { true,  true,  true,  true,  true,  "KV2_97",   "POKE",       2 }, // https://www.landsnail.com/a2ref.htm
    { true,  true,  true,  true,  true,  "KV2_98",   "PRINT#",     2 }, // https://www.atariarchives.org/creativeatari/Using_Disks_With_Atari_Basic.php
    { true,  true,  true,  true,  true,  "KV2_99",   "PRINT",      0 }, // https://www.landsnail.com/a2ref.htm
    { true,  true,  true,  true,  true,  "KV2_9A",   "CONT",       2 }, // https://www.landsnail.com/a2ref.htm
    { true,  true,  true,  true,  true,  "KV2_9B",   "LIST",       2 }, // https://www.landsnail.com/a2ref.htm
    { true,  true,  true,  true,  true,  "KV2_9C",   "CLR",        2 }, // Apple I Replica Creation: Back to the Garage, p125
    { true,  true,  true,  true,  true,  "KV2_9D",   "CMD",        2 }, // https://en.wikipedia.org/wiki/List_of_DOS_commands
    { true,  true,  true,  true,  true,  "KV2_9E",   "SYS",        2 }, // https://www.lifewire.com/dos-commands-4070427
    { true,  true,  true,  true,  true,  "KV2_9F",   "OPEN",       2 }, // https://www.atariarchives.org/creativeatari/Using_Disks_With_Atari_Basic.php
    // STD    CRT    M65    U64    X16
    { true,  true,  true,  true,  true,  "KV2_A0",   "CLOSE",      3 }, // https://www.atariarchives.org/creativeatari/Using_Disks_With_Atari_Basic.php
    { true,  true,  true,  true,  true,  "KV2_A1",   "GET",        2 }, // https://www.landsnail.com/a2ref.htm
    { true,  true,  true,  true,  true,  "KV2_A2",   "NEW",        0 }, // https://www.landsnail.com/a2ref.htm
    { true,  true,  true,  true,  true,  "KV2_A3",   "TAB(",       2 }, // http://www.antonis.de/qbebooks/gwbasman/tab.html
    { true,  true,  true,  true,  true,  "KV2_A4",   "TO",         0 }, // https://www.landsnail.com/a2ref.htm
    { true,  true,  true,  true,  true,  "KV2_A5",   "FN",         0 }, // https://www.landsnail.com/a2ref.htm
    { true,  true,  true,  true,  true,  "KV2_A6",   "SPC(",       2 }, // http://www.antonis.de/qbebooks/gwbasman/spc.html
    { true,  true,  true,  true,  true,  "KV2_A7",   "THEN",       2 }, // https://www.landsnail.com/a2ref.htm
    { true,  true,  true,  true,  true,  "KV2_A8",   "NOT",        2 }, // https://www.landsnail.com/a2ref.htm
    { true,  true,  true,  true,  true,  "KV2_A9",   "STEP",       2 }, // https://www.landsnail.com/a2ref.htm
    { true,  true,  true,  true,  true,  "KV2_AA",   "+",          0 }, // https://www.landsnail.com/a2ref.htm
    { true,  true,  true,  true,  true,  "KV2_AB",   "-",          0 }, // https://www.landsnail.com/a2ref.htm
    { true,  true,  true,  true,  true,  "KV2_AC",   "*",          0 }, // https://www.landsnail.com/a2ref.htm
    { true,  true,  true,  true,  true,  "KV2_AD",   "/",          0 }, // https://www.landsnail.com/a2ref.htm
    { true,  true,  true,  true,  true,  "KV2_AE",   "^",          0 }, // https://www.landsnail.com/a2ref.htm
    { true,  true,  true,  true,  true,  "KV2_AF",   "AND",        2 }, // https://www.landsnail.com/a2ref.htm
    { true,  true,  true,  true,  true,  "KV2_B0",   "OR",         0 }, // https://www.landsnail.com/a2ref.htm
    { true,  true,  true,  true,  true,  "KV2_B1",   ">",          0 }, // https://www.landsnail.com/a2ref.htm
    { true,  true,  true,  true,  true,  "KV2_B2",   "=",          0 }, // https://www.landsnail.com/a2ref.htm
    { true,  true,  true,  true,  true,  "KV2_B3",   "<",          0 }, // https://www.landsnail.com/a2ref.htm
    { true,  true,  true,  true,  true,  "KV2_B4",   "SGN",        2 }, // https://www.landsnail.com/a2ref.htm
    { true,  true,  true,  true,  true,  "KV2_B5",   "INT",        0 }, // https://www.landsnail.com/a2ref.htm
    { true,  true,  true,  true,  true,  "KV2_B6",   "ABS",        2 }, // https://www.landsnail.com/a2ref.htm
    { true,  true,  true,  true,  true,  "KV2_B7",   "USR",        2 }, // https://www.landsnail.com/a2ref.htm
    { true,  true,  true,  true,  true,  "KV2_B8",   "FRE",        2 }, // http://www.antonis.de/qbebooks/gwbasman/fre.html
    { true,  true,  true,  true,  true,  "KV2_B9",   "POS",        0 }, // http://www.antonis.de/qbebooks/gwbasman/pos.html
    { true,  true,  true,  true,  true,  "KV2_BA",   "SQR",        2 }, // https://www.landsnail.com/a2ref.htm
    { true,  true,  true,  true,  true,  "KV2_BB",   "RND",        2 }, // https://www.landsnail.com/a2ref.htm
    { true,  true,  true,  true,  true,  "KV2_BC",   "LOG",        0 }, // https://www.landsnail.com/a2ref.htm
    { true,  true,  true,  true,  true,  "KV2_BD",   "EXP",        2 }, // https://www.landsnail.com/a2ref.htm
    { true,  true,  true,  true,  true,  "KV2_BE",   "COS",        0 }, // https://www.landsnail.com/a2ref.htm
    { true,  true,  true,  true,  true,  "KV2_BF",   "SIN",        2 }, // https://www.landsnail.com/a2ref.htm
    // STD    CRT    M65    U64    X16
    { true,  true,  true,  true,  true,  "KV2_C0",   "TAN",        0 }, // https://www.landsnail.com/a2ref.htm
    { true,  true,  true,  true,  true,  "KV2_C1",   "ATN",        2 }, // https://www.landsnail.com/a2ref.htm
    { true,  true,  true,  true,  true,  "KV2_C2",   "PEEK",       2 }, // https://www.landsnail.com/a2ref.htm
    { true,  true,  true,  true,  true,  "KV2_C3",   "LEN",        0 }, // https://www.landsnail.com/a2ref.htm
    { true,  true,  true,  true,  true,  "KV2_C4",   "STR$",       3 }, // https://www.landsnail.com/a2ref.htm
    { true,  true,  true,  true,  true,  "KV2_C5",   "VAL",        2 }, // https://www.landsnail.com/a2ref.htm
    { true,  true,  true,  true,  true,  "KV2_C6",   "ASC",        2 }, // https://www.landsnail.com/a2ref.htm
    { true,  true,  true,  true,  true,  "KV2_C7",   "CHR$",       2 }, // https://www.landsnail.com/a2ref.htm
    { true,  true,  true,  true,  true,  "KV2_C8",   "LEFT$",      3 }, // https://www.landsnail.com/a2ref.htm
    { true,  true,  true,  true,  true,  "KV2_C9",   "RIGHT$",     2 }, // https://www.landsnail.com/a2ref.htm
    { true,  true,  true,  true,  true,  "KV2_CA",   "MID$",       2 }, // https://www.landsnail.com/a2ref.htm
    { true,  true,  true,  true,  true,  "KV2_CB",   "GO",         0 }, // https://en.wikipedia.org/wiki/Goto
} };

// extended BASIC keywords - list reserved for small BASIC commands, suitable for inclusion in all machines with extended ROM

const StringEntryList GLOBAL_Keywords_01 =  { ListType::KEYWORDS, "keywords_01",
{
    // STD    CRT    M65    U64    X16
    { true,  true,  true,  true,  true,  "K01_01",   "SLOW",         }, // https://en.wikipedia.org/wiki/Sinclair_BASIC - ZX81 variant
    { true,  true,  true,  true,  true,  "K01_02",   "FAST",         }, // https://en.wikipedia.org/wiki/Sinclair_BASIC - ZX81 variant
    { true,  true,  true,  true,  true,  "K01_03",   "OLD",          }, // Not present in CBM BASIC dialects, but common to some extensions (*)
    { false, true,  true,  true,  false, "K01_04",   "CLEAR",        }, // Not present in CBM BASIC dialects, Open ROMs specific
    { false, true,  true,  true,  false, "K01_05",   "DISPOSE",      }, // Not present in CBM BASIC dialects, Open ROMs specific
    { false, true,  true,  true,  false, "K01_06",   "MERGE",        }, // Not present in CBM BASIC dialects, but common to some extensions (*)
    { false, true,  true,  true,  false, "K01_07",   "BLOAD",        }, // http://www.antonis.de/qbebooks/gwbasman/bload.html
    { false, true,  true,  true,  false, "K01_08",   "BSAVE",        }, // http://www.antonis.de/qbebooks/gwbasman/bsave.html
    { false, true,  true,  true,  false, "K01_09",   "BVERIFY",      },
    { false, true,  true,  true,  false, "K01_0A",   "COLD",         }, // Not present in CBM BASIC dialects, but common to some extensions (*)
    { false, true,  true,  true,  false, "K01_0B",   "MEM",          }, // Not present in CBM BASIC dialects, Open ROMs specific

    // (*) see https://sourceforge.net/p/vice-emu/code/HEAD/tree/trunk/vice/src/petcat.c
} };

// extended BASIC keywords - list reserved for hardware dependent BASIC commands

const StringEntryList GLOBAL_Keywords_04 =  { ListType::KEYWORDS, "keywords_04",
{
    // STD    CRT    M65    U64    X16
    { false, false, true,  false, false, "K04_01",   "SYSINFO",      }, // Not present in CBM BASIC dialects, Open ROMs specific
    { false, false, true,  false, false, "K04_02",   "MONITOR",      }, // Amos Professional Manual, Command Index
    { false, false, true,  false, false, "K04_03",   "BOOTCPM",      }, // Not present in CBM BASIC dialects, Open ROMs specific
    { false, false, true,  false, false, "K04_04",   "JOYCRSR",      }, // Not present in CBM BASIC dialects, Open ROMs specific
    { false, false, true,  false, false, "K04_05",   "COLORSET",      }, // Not present in CBM BASIC dialects, Open ROMs specific

} };

// extended BASIC keywords - list reserved for functions

const StringEntryList GLOBAL_Keywords_06 =  { ListType::KEYWORDS, "keywords_06",
{
    // STD    CRT    M65    U64    X16
    { false, false, true,  false, false, "K06_01",   "TEST",         }, // Not present in CBM BASIC dialects, Open ROMs specific

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
    // STD    CRT    M65    U64    X16   --- error strings compatible with CBM BASIC V2
    { true,  true,  true,  true,  true,  "EV2_01", "TOO MANY FILES"           },
    { true,  true,  true,  true,  true,  "EV2_02", "FILE OPEN"                },
    { true,  true,  true,  true,  true,  "EV2_03", "FILE NOT OPEN"            },
    { true,  true,  true,  true,  true,  "EV2_04", "FILE NOT FOUND"           },
    { true,  true,  true,  true,  true,  "EV2_05", "DEVICE NOT PRESENT"       },
    { true,  true,  true,  true,  true,  "EV2_06", "NOT INPUT FILE"           },
    { true,  true,  true,  true,  true,  "EV2_07", "NOT OUTPUT FILE"          },
    { true,  true,  true,  true,  true,  "EV2_08", "MISSING FILENAME"         },
    { true,  true,  true,  true,  true,  "EV2_09", "ILLEGAL DEVICE NUMBER"    },
    { true,  true,  true,  true,  true,  "EV2_0A", "NEXT WITHOUT FOR"         },
    { true,  true,  true,  true,  true,  "EV2_0B", "SYNTAX"                   },
    { true,  true,  true,  true,  true,  "EV2_0C", "RETURN WITHOUT GOSUB"     },
    { true,  true,  true,  true,  true,  "EV2_0D", "OUT OF DATA"              },
    { true,  true,  true,  true,  true,  "EV2_0E", "ILLEGAL QUANTITY"         },
    { true,  true,  true,  true,  true,  "EV2_0F", "OVERFLOW"                 },
    { true,  true,  true,  true,  true,  "EV2_10", "OUT OF MEMORY"            },
    { true,  true,  true,  true,  true,  "EV2_11", "UNDEF\'D STATEMENT"       },
    { true,  true,  true,  true,  true,  "EV2_12", "BAD SUBSCRIPT"            },
    { true,  true,  true,  true,  true,  "EV2_13", "REDIM\'D ARRAY"           },
    { true,  true,  true,  true,  true,  "EV2_14", "DIVISION BY ZERO"         },
    { true,  true,  true,  true,  true,  "EV2_15", "ILLEGAL DIRECT"           },
    { true,  true,  true,  true,  true,  "EV2_16", "TYPE MISMATCH"            },
    { true,  true,  true,  true,  true,  "EV2_17", "STRING TOO LONG"          },
    { true,  true,  true,  true,  true,  "EV2_18", "FILE DATA"                },
    { true,  true,  true,  true,  true,  "EV2_19", "FORMULA TOO COMPLEX"      },
    { true,  true,  true,  true,  true,  "EV2_1A", "CAN\'T CONTINUE"          },
    { true,  true,  true,  true,  true,  "EV2_1B", "UNDEF\'D FUNCTION"        },
    { true,  true,  true,  true,  true,  "EV2_1C", "VERIFY"                   },
    { true,  true,  true,  true,  true,  "EV2_1D", "LOAD"                     },
    { true,  true,  true,  true,  true,  "EV2_1E", "BREAK"                    },
    // STD    CRT    M65    U64    X16   --- error strings compatible with CBM BASIC V7
    { false, false, false, false, false, "EV7_1F", "CAN'T RESUME"             }, // not used for now
    { false, false, false, false, false, "EV7_20", "LOOP NOT FOUND"           }, // not used for now
    { false, false, false, false, false, "EV7_21", "LOOP WITHOUT DO"          }, // not used for now
    { true,  true,  true,  true,  true,  "EV7_22", "DIRECT MODE ONLY"         },
    { false, false, false, false, false, "EV7_23", "NO GRAPHICS AREA"         }, // not used for now
    { false, false, false, false, false, "EV7_24", "BAD DISK"                 }, // not used for now
    { false, false, false, false, false, "EV7_25", "BEND NOT FOUND"           }, // not used for now
    { true,  true,  true,  true,  true,  "EV7_26", "LINE NUMBER TOO LARGE"    },
    { false, false, false, false, false, "EV7_27", "UNRESOLVED REFERENCE"     }, // not used for now
    { true,  true,  true,  true,  true,  "EV7_28", "NOT IMPLEMENTED"          }, // this message actually differs from the CBM one
    { false, false, false, false, false, "EV7_29", "FILE READ"                }, // not used for now
    // STD    CRT    M65    U64    X16   --- error strings specific to Open ROMs, not present in CBM BASIC dialects
    { true,  true,  true,  true,  true,  "EOR_2A", "MEMORY CORRUPT"           },
    { false, false, true,  false, false, "EOR_2B", "NATIVE MODE ONLY"         },   
    { false, false, true,  false, false, "EOR_2C", "LEGACY MODE ONLY"         },   
} };

// BASIC errors - miscelaneous strings

const StringEntryList GLOBAL_MiscStrings =  { ListType::STRINGS_BASIC, "misc",
{
    // STD    CRT    M65    U64    X16   --- misc strings as on CBM machines
    { true,  true,  true,  true,  true,  "STR_RET_QM",       "\r?"                },
    { true,  true,  true,  true,  true,  "STR_BYTES",        " BASIC BYTES FREE"  }, // https://github.com/stefanhaustein/expressionparser
    { true,  true,  true,  true,  true,  "STR_READY",        "\rREADY.\r"         }, // https://www.ibm.com/support/knowledgecenter/zosbasics/com.ibm.zos.zconcepts/zconc_whatistsonative.htm https://github.com/stefanhaustein/expressionparser
    { true,  true,  true,  true,  true,  "STR_ERROR",        " ERROR"             }, // simply the word error that is attached to the other parts of messages https://fjkraan.home.xs4all.nl/comp/apple2faq/app2asoftfaq.html
    { true,  true,  true,  true,  true,  "STR_IN",           " IN "               },
    { false, true,  true,  false, false, "STR_IF_SURE",      "\rARE YOU SURE? "   }, // https://docs.microsoft.com/en-us/windows/win32/uxguide/mess-confirm
    // STD    CRT    M65    U64    X16   --- misc strings specific to Open ROMs, not present in CBM ROMs
    { true,  true,  true,  true,  true,  "STR_BRK_AT",       "\rBRK AT $"         },

    { false, false, true,  false, false, "STR_ORS",          "OPEN ROMS BASIC & KERNAL\r" },
    { false, false, true,  false, false, "STR_ORS_LEGACY",   "(LEGACY MODE)  "    },

    { false, true,  true,  false, false, "STR_MEM_HDR",      "\r\x12 AREA   START   SIZE  \r" },
    { false, true,  true,  false, false, "STR_MEM_1",        "   $"               },
    { false, true,  true,  false, false, "STR_MEM_2",        "   "                },
    { false, true,  true,  false, false, "STR_MEM_TEXT",     "\r TEXT"            },
    { false, true,  true,  false, false, "STR_MEM_VARS",     "\r VARS"            },
    { false, true,  true,  false, false, "STR_MEM_ARRS",     "\r ARRS"            },
    { false, true,  true,  false, false, "STR_MEM_STRS",     "\r STRS"            },
    { false, true,  true,  false, false, "STR_MEM_FREE",     "\r\r FREE"          },

    { false, false, true,  false, false, "STR_DOS_FD",       "\rFLOPPY   : "      },
    { false, false, true,  false, false, "STR_DOS_SEPAR",    " / "                },
    { false, false, true,  false, false, "STR_DOS_RD",       "\rRAM DISK : "      },

    { false, false, true,  false, false, "STR_SI_HEADER",    "OPEN ROMS, "        },
    { false, false, true,  false, false, "STR_SI_MODE64",    "LEGACY MODE"        },
    { false, false, true,  false, false, "STR_SI_MODE65",    "NATIVE MODE"        },
    { false, false, true,  false, false, "STR_SI_HDR_REL",   "\rRELEASE "         },
    { false, false, true,  false, false, "STR_SI_HDR_HW",    "BOARD    : "        },
    { false, false, true,  false, false, "STR_SI_HW_01",     "MEGA65 R1"          },
    { false, false, true,  false, false, "STR_SI_HW_02",     "MEGA65 R2"          },
    { false, false, true,  false, false, "STR_SI_HW_03",     "MEGA65 R3"          },
    { false, false, true,  false, false, "STR_SI_HW_21",     "MEGAPHONE R1"       },
    { false, false, true,  false, false, "STR_SI_HW_40",     "NEXYS4 PSRAM"       },
    { false, false, true,  false, false, "STR_SI_HW_41",     "NEXYS4 DDR"         },
    { false, false, true,  false, false, "STR_SI_HW_42",     "NEXYS4 DDR WIDGET"  },
    { false, false, true,  false, false, "STR_SI_HW_FD",     "WUKONG A100T"       },
    { false, false, true,  false, false, "STR_SI_HW_FE",     "SIMULATION VHDL"    },
    { false, false, true,  false, false, "STR_SI_HW_XX",     "UNKNOWN ID $"       },
    { false, false, true,  false, false, "STR_SI_HDR_VID",   "\rVIDEO    : "      },

    { false, false, true,  false, false, "STR_RD_NAME",      "RAMDISK.DNP "       },
    { false, false, true,  false, false, "STR_RD_OK",        "LOADED OK\r"        },
    { false, false, true,  false, false, "STR_RD_ERR1",      "SIZE WRONG\r"       },
    { false, false, true,  false, false, "STR_RD_ERR2",      "TOO LARGE\r"        },
    { false, false, true,  false, false, "STR_RD_ERR3",      "NOT FOUND\r"        },

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
