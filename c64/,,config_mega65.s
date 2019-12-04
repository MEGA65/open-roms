
.const CONFIG_ID = $01 // should be 1 byte, different for each config file!
.encoding "petscii_upper"

//
// Please read CONFIG.md before modifying this file!
//

// Idea:
// - sane defaults for the Mega 65 FPGA computer
// - do not enable features which are a significant compatibility risk
// - unless VICE gains Commodore 65 (or at least Flash8 cartridge) emulation support,
//   do not enable CPU-specific optimizations; ROMs would be hard to test


// Hardware platform and brand

#define CONFIG_PLATFORM_COMMODORE_64

#define CONFIG_MB_MEGA_65
// #define CONFIG_MB_ULTIMATE_64

// #define CONFIG_BRAND_GENERIC
// #define CONFIG_BRAND_TESTING
#define CONFIG_BRAND_MEGA_65
// #define CONFIG_BRAND_ULTIMATE_64


// Processor instruction set

#define CONFIG_CPU_MOS_6502
// #define CONFIG_CPU_WDC_65C02
// #define CONFIG_CPU_CSG_65CE02
// #define CONFIG_CPU_WDC_65816


// Memory model

#define CONFIG_MEMORY_MODEL_38K
// #define CONFIG_MEMORY_MODEL_60K


// I/O devices

#define CONFIG_IEC
#define CONFIG_IEC_JIFFYDOS
// #define CONFIG_TAPE_NORMAL     // please keep disabled for now
// #define CONFIG_TAPE_TURBO
// #define CONFIG_RS232_UP2400    // please keep disabled for now
// #define CONFIG_RS232_UP9600    // please keep disabled for now


// Multiple SID support

#define CONFIG_SID_2ND
.const CONFIG_SID_2ND_ADDRESS = $D440

// #define CONFIG_SID_3RD
.const CONFIG_SID_3RD_ADDRESS = $D480

// #define CONFIG_SID_D4XX
// #define CONFIG_SID_D5XX


// Keyboard settings

// #define CONFIG_LEGACY_SCNKEY
// #define CONFIG_KEYBOARD_C128
// #define CONFIG_KEYBOARD_C128_CAPS_LOCK
#define CONFIG_KEYBOARD_C65              // untested
#define CONFIG_KEYBOARD_C65_CAPS_LOCK    // untested
// #define CONFIG_KEY_REPEAT_DEFAULT
// #define CONFIG_KEY_REPEAT_ALWAYS
#define CONFIG_KEY_FAST_SCAN
#define CONFIG_JOY1_CURSOR
#define CONFIG_JOY2_CURSOR

#define CONFIG_PROGRAMMABLE_KEYS

.const CONFIG_KEYCMD_RUN  = @"LOAD\"*\""

.const CONFIG_KEYCMD_F1   = @"@"
.const CONFIG_KEYCMD_F2   = @""
.const CONFIG_KEYCMD_F3   = @"RUN:"
.const CONFIG_KEYCMD_F4   = @""
.const CONFIG_KEYCMD_F5   = @"LOAD"
.const CONFIG_KEYCMD_F6   = @""
.const CONFIG_KEYCMD_F7   = @"@$"
.const CONFIG_KEYCMD_F8   = @""

.const CONFIG_KEYCMD_HELP = @"LIST"

.const CONFIG_KEYCMD_F9   = @""
.const CONFIG_KEYCMD_F10  = @""
.const CONFIG_KEYCMD_F11  = @""
.const CONFIG_KEYCMD_F12  = @""
.const CONFIG_KEYCMD_F13  = @""
.const CONFIG_KEYCMD_F14  = @""


// Screen editor

#define CONFIG_EDIT_STOPQUOTE
#define CONFIG_EDIT_TABULATORS


// Software features

#define CONFIG_PANIC_SCREEN
#define CONFIG_DOS_WEDGE
// #define CONFIG_TAPE_WEDGE
#define CONFIG_BCD_SAFE_INTERRUPTS


// Eye candy

#define CONFIG_COLORS_BRAND
// #define CONFIG_BANNER_SIMPLE
// #define CONFIG_BANNER_FANCY
#define CONFIG_BANNER_BRAND
#define CONFIG_SHOW_FEATURES
// #define CONFIG_SHOW_PAL_NTSC


// Debug options

// #define CONFIG_DBG_STUBS_BRK
// #define CONFIG_DBG_PRINTF
