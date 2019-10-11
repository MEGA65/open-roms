
//
// Please read CONFIG.md before modifying this file!
//


// Hardware platform and variant

#define CONFIG_PLATFORM_COMMODORE_64

// #define CONFIG_VARIANT_GENERIC
// #define CONFIG_VARIANT_MEGA_65
#define CONFIG_VARIANT_ULTIMATE_64


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


// Software features

#define CONFIG_BANNER_FANCY
#define CONFIG_BANNER_PAL_NTSC
#define CONFIG_DOS_WEDGE
#define CONFIG_BCD_SAFE_INTERRUPTS
#define CONFIG_SCNKEY_TWW_CTR // for now has to be enabled


// Debug options

// #define CONFIG_DBG_STUBS_BRK
// #define CONFIG_DBG_PRINTF
