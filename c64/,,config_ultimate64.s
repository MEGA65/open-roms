
.const CONFIG_ID = $02 // should be 1 byte, different for each config file!

//
// Please read CONFIG.md before modifying this file!
//

// Idea:
// - sane defaults for the Ultimate 64 FPGA computer
// - do not enable features which are a significant compatibility risk


// Hardware platform and brand

#define CONFIG_PLATFORM_COMMODORE_64

// #define CONFIG_MB_MEGA_65
#define CONFIG_MB_ULTIMATE_64

// #define CONFIG_BRAND_GENERIC
// #define CONFIG_BRAND_TESTING
// #define CONFIG_BRAND_MEGA_65
#define CONFIG_BRAND_ULTIMATE_64


// Processor instruction set

#define CONFIG_CPU_MOS_6502
// #define CONFIG_CPU_WDC_65C02
// #define CONFIG_CPU_CSG_65CE02
// #define CONFIG_CPU_WDC_65816


// Memory model configuration

#define CONFIG_MEMORY_MODEL_38K
// #define CONFIG_MEMORY_MODEL_60K


// Multiple SID support

// #define CONFIG_SID_2ND
.const CONFIG_SID_2ND_ADDRESS = $D420

// #define CONFIG_SID_3RD
.const CONFIG_SID_3RD_ADDRESS = $D440

#define CONFIG_SID_D4XX
#define CONFIG_SID_D5XX


// Keyboard settings


// #define CONFIG_LEGACY_SCNKEY
// #define CONFIG_KEYBOARD_C128
// #define CONFIG_KEYBOARD_C128_CAPS_LOCK
// #define CONFIG_KEY_REPEAT_DEFAULT
// #define CONFIG_KEY_REPEAT_ALWAYS
#define CONFIG_KEY_FAST_SCAN
#define CONFIG_JOY1_CURSOR
#define CONFIG_JOY2_CURSOR


// Eye candy

// #define CONFIG_BANNER_SIMPLE
#define CONFIG_BANNER_FANCY
// #define CONFIG_BANNER_BRAND
#define CONFIG_SHOW_PAL_NTSC


// Software features

#define CONFIG_PANIC_SCREEN
#define CONFIG_DOS_WEDGE
#define CONFIG_BCD_SAFE_INTERRUPTS


// Debug options

// #define CONFIG_DBG_STUBS_BRK
// #define CONFIG_DBG_PRINTF
