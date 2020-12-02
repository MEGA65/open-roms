
;
; Configuration dependent aliases/macros/checks
;



; Check that platform is specified

!set counter = 0
!ifdef CONFIG_PLATFORM_COMMODORE_64  { !set counter = counter + 1 }
!ifdef CONFIG_PLATFORM_COMMANDER_X16 { !set counter = counter + 1 }

!if (counter != 1) { !error "Please select exactly one CONFIG_PLATFORM_* option" }



; Check that motherboard configuration is correct

!set counter = 0
!ifdef CONFIG_MB_M65 { !set counter = counter + 1 }
!ifdef CONFIG_MB_U64 { !set counter = counter + 1 }

!if (counter > 1) { !error "Please select at most one CONFIG_MB_* option" }

!ifdef ROM_LAYOUT_M65 { !ifndef CONFIG_MB_M65 { !error "ROM layout requires CONFIG_MB_M65 option" } }
!ifdef ROM_LAYOUT_U64 { !ifndef CONFIG_MB_U64 { !error "ROM layout requires CONFIG_MB_U64 option" } }

!ifdef CONFIG_MB_M65 { !ifndef ROM_LAYOUT_M65 { !error "CONFIG_MB_M65 can only be used with appropriate ROM layout" } }
; !ifdef CONFIG_MB_U64 { !ifndef ROM_LAYOUT_U64 { !error "CONFIG_MB_U64 can only be used with appropriate ROM layout" } }

!ifdef CONFIG_MB_M65 { !ifndef CONFIG_PLATFORM_COMMODORE_64 { !error "CONFIG_MB_M65 can only be used with CONFIG_PLATFORM_COMMODORE_64" } }
!ifdef CONFIG_MB_U64 { !ifndef CONFIG_PLATFORM_COMMODORE_64 { !error "CONFIG_MB_U64 can only be used with CONFIG_PLATFORM_COMMODORE_64" } }



; Check that brand configuration is correct

!set counter = 0
!ifdef CONFIG_BRAND_CUSTOM       { !set counter = counter + 1 }
!ifdef CONFIG_BRAND_GENERIC      { !set counter = counter + 1 }
!ifdef CONFIG_BRAND_TESTING      { !set counter = counter + 1 }

!ifndef CONFIG_PLATFORM_COMMODORE_64 {
	!if (counter != 0) { !error "Do not use CONFIG_BRAND_* options for non-C64 platforms" }
} else ifdef CONFIG_MB_M65 {
	!if (counter != 0) { !error "Do not use CONFIG_BRAND_* options for the MEGA65 motherboard" }
} else ifdef CONFIG_MB_U64 {
	!if (counter != 0) { !error "Do not use CONFIG_BRAND_* options for the Ultimate 64 motherboard" }
} else if (counter != 1) {
	!error "Please select exactly one CONFIG_BRAND_* option"	
}

!ifdef CONFIG_ROM_CRT { !ifndef ROM_LAYOUT_CRT {
	!error "ROM_LAYOUT_CRT needs standard CONFIG_ROM_CRT set and vice-versa"
}}
!ifdef ROM_LAYOUT_CRT { !ifndef CONFIG_ROM_CRT {
	!error "ROM_LAYOUT_CRT needs standard CONFIG_ROM_CRT set and vice-versa"
}}


; Check that processor configuration is correct

!set counter = 0
!ifdef CONFIG_CPU_MOS_6502   { !set counter = counter + 1 }
!ifdef CONFIG_CPU_DTV_6502   { !set counter = counter + 1 }
!ifdef CONFIG_CPU_RCW_65C02  { !set counter = counter + 1 }
!ifdef CONFIG_CPU_WDC_65C02  { !set counter = counter + 1 }
!ifdef CONFIG_CPU_WDC_65816  { !set counter = counter + 1 }
!ifdef CONFIG_CPU_CSG_65CE02 { !set counter = counter + 1 }

!ifdef CONFIG_PLATFORM_COMMANDER_X16 {
	!if (counter != 0) { !error "Do not use CONFIG_CPU_* options for Commander X16 platform" }
} else ifdef CONFIG_MB_M65 {
	!if (counter != 0) { !error "Do not use CONFIG_CPU_* options for MEGA65 motherboard" }
} else ifdef CONFIG_MB_U64 {
	!if (counter != 0) { !error "Do not use CONFIG_CPU_* options for Ultimate 64 motherboard" }
} else if (counter != 1) {
	!error "Please select exactly one CONFIG_CPU_* option"	
}



; Check that memory model configuration is correct

!set counter = 0
!ifdef CONFIG_MEMORY_MODEL_38K { !set counter = counter + 1 }
!ifdef CONFIG_MEMORY_MODEL_46K { !set counter = counter + 1 }
!ifdef CONFIG_MEMORY_MODEL_50K { !set counter = counter + 1 }
!ifdef CONFIG_MEMORY_MODEL_60K { !set counter = counter + 1 }

!ifdef CONFIG_MB_M65 {
	!ifdef CONFIG_MEMORY_MODEL_60K { !error "Do not use CONFIG_MEMORY_MODEL_60K options for MEGA65 motherboard" }
}
!ifdef ROM_LAYOUT_CRT {
	!ifdef CONFIG_MEMORY_MODEL_60K { !error "Do not use CONFIG_MEMORY_MODEL_60K options for CRT ROM layout" }
}
!ifdef CONFIG_PLATFORM_COMMANDER_X16 {
	!ifndef CONFIG_MEMORY_MODEL_38K { !error "Select CONFIG_MEMORY_MODEL_38K options for Commander X16 platform" }
}
!if (counter != 1) {
	!error "Please select exactly one CONFIG_MEMORY_MODEL_* option"	
}



; Check that IEC configuration is correct

!ifdef CONFIG_PLATFORM_COMMANDER_X16 {
	!ifdef CONFIG_IEC { !error "Do not use CONFIG_IEC options for Commander X16 platform, it is not implemented" }
}
!ifdef CONFIG_MB_MEGA65 {
	!ifdef CONFIG_IEC_BURST_CIA1 { !error "Do not use CONFIG_IEC_BURST_CIA1 options for MEGA65 motherboard, CONFIG_IEC_BURST_M65 instead" }
	!ifdef CONFIG_IEC_BURST_CIA2 { !error "Do not use CONFIG_IEC_BURST_CIA2 options for MEGA65 motherboard, CONFIG_IEC_BURST_M65 instead" }
}
!ifndef CONFIG_MB_MEGA65 {
	!ifdef CONFIG_IEC_BURST_M65 { !error "CONFIG_IEC_BURST_M65 is only possible for MEGA65 motherboard" }
}
!ifdef CONFIG_IEC_BURST_CIA1 {
	!ifndef CONFIG_IEC { !error "CONFIG_IEC_BURST_CIA1 requires CONFIG_IEC" }
}
!ifdef CONFIG_IEC_BURST_CIA2 {
	!ifndef CONFIG_IEC { !error "CONFIG_IEC_BURST_CIA2 requires CONFIG_IEC" }
}
!ifdef CONFIG_IEC_BURST_CIA1 {
	!ifdef CONFIG_IEC_BURST_CIA2 { !error "CONFIG_IEC_BURST_CIA1 and CONFIG_IEC_BURST_CIA2 are mutually exclusive" }
}
!ifdef CONFIG_IEC_BURST_M65 {
	!ifndef CONFIG_IEC { !error "CONFIG_IEC_BURST_M65 requires CONFIG_IEC" }
}
!ifdef CONFIG_IEC_DOLPHINDOS {
	!ifndef CONFIG_IEC { !error "CONFIG_IEC_DOLPHINDOS requires CONFIG_IEC" }
}
!ifdef CONFIG_IEC_DOLPHINDOS_FAST {
	!ifndef CONFIG_IEC_DOLPHINDOS { !error "CONFIG_IEC_DOLPHINDOS_FAST requires CONFIG_IEC_DOLPHINDOS" }
}
!ifdef CONFIG_IEC_JIFFYDOS {
	!ifndef CONFIG_IEC { !error "CONFIG_IEC_JIFFYDOS requires CONFIG_IEC" }
}
!ifdef CONFIG_IEC_JIFFYDOS_BLANK {
	!ifndef CONFIG_IEC_JIFFYDOS { !error "CONFIG_IEC_JIFFYDOS_BLANK requires CONFIG_IEC_JIFFYDOS" }
}



; Check that tape deck configuration is correct

!set counter = 0
!ifdef CONFIG_TAPE_NORMAL { !set counter = counter + 1 }
!ifdef CONFIG_TAPE_TURBO  { !set counter = counter + 1 }

!ifdef CONFIG_PLATFORM_COMMANDER_X16 {
	!ifdef CONFIG_TAPE_NORMAL { !error "Do not use CONFIG_TAPE_NORMAL options for Commander X16 platform, it is not implemented" }
	!ifdef CONFIG_TAPE_TURBO  { !error "Do not use CONFIG_TAPE_TURBO options for Commander X16 platform, it is not implemented" }
}
!ifdef CONFIG_TAPE_AUTODETECT { !ifndef CONFIG_TAPE_NORMAL { !ifndef CONFIG_TAPE_TURBO {
	!error "CONFIG_TAPE_AUTODETECT requires both CONFIG_TAPE_NORMAL and CONFIG_TAPE_TURBO"
} } }
!ifdef CONFIG_TAPE_HEAD_ALIGN {
	!ifndef CONFIG_TAPE_WEDGE { !error "CONFIG_TAPE_HEAD_ALIGN requires CONFIG_TAPE_WEDGE" }
}
!ifdef CONFIG_TAPE_WEDGE {
	!if (counter = 0) { !error "CONFIG_TAPE_WEDGE requires CONFIG_TAPE_TURBO or CONFIG_TAPE_NORMAL"}
}



; Check that RS-232 configuration is correct

!set counter = 0
!ifdef CONFIG_RS232_ACIA   { !set counter = counter + 1 }
!ifdef CONFIG_RS232_UP2400 { !set counter = counter + 1 }
!ifdef CONFIG_RS232_UP9600 { !set counter = counter + 1 }

!ifdef CONFIG_PLATFORM_COMMANDER_X16 {
	!if (counter != 0) { !error "Do not use CONFIG_RS232_* options for Commander X16 platform, it is not implemented" }
}
!ifdef CONFIG_RS232_UP9600 {
	!ifdef CONFIG_TAPE_NORMAL { !error "CONFIG_RS232_UP9600 is not compatible with CONFIG_TAPE_NORMAL" }
	!ifdef CONFIG_TAPE_TURBO  { !error "CONFIG_RS232_UP9600 is not compatible with CONFIG_TAPE_TURBO"  }
}
!if (counter > 1) { !error "Please select at most one CONFIG_RS232_* option" }



; Check that sound support configuration is correct

!set counter = 0
!ifdef CONFIG_SID_2ND_ADDRESS { !set counter = counter + 1 }
!ifdef CONFIG_SID_3RD_ADDRESS { !set counter = counter + 1 }
!ifdef CONFIG_SID_D4XX        { !set counter = counter + 1 }
!ifdef CONFIG_SID_D5XX        { !set counter = counter + 1 }
!ifdef CONFIG_SID_D6XX        { !set counter = counter + 1 }
!ifdef CONFIG_SID_D7XX        { !set counter = counter + 1 }

!ifdef CONFIG_PLATFORM_COMMANDER_X16 {
	!if (counter != 0) { !error "Do not use CONFIG_SID_* options for Commander X16 platform" }
}
!ifdef CONFIG_MB_M65 {
	!if (counter != 0) { !error "Do not use CONFIG_SID_* options for MEGA65 motherboard" }
}
!ifdef CONFIG_SID_2ND_ADDRESS {
	!if (CONFIG_SID_2ND_ADDRESS = $D400)          { !error "CONFIG_SID_2ND_ADDRESS points to the 1st SID" }
	!if (CONFIG_SID_2ND_ADDRESS < $D420)          { !error "CONFIG_SID_2ND_ADDRESS needs hex value from $D420-$D7E0 range" }
	!if (CONFIG_SID_2ND_ADDRESS > $D7E0)          { !error "CONFIG_SID_2ND_ADDRESS needs hex value from $D420-$D7E0 range" }
	!if ((CONFIG_SID_2ND_ADDRESS % $20)   != 0)   { !error "CONFIG_SID_2ND_ADDRESS has to be aligned to $20" }
	!if ((CONFIG_SID_2ND_ADDRESS DIV $100) = $D4) { !ifdef CONFIG_SID_D4XX { !error "CONFIG_SID_2ND_ADDRESS redundant due to CONFIG_SID_D4XX" } }
	!if ((CONFIG_SID_2ND_ADDRESS DIV $100) = $D5) { !ifdef CONFIG_SID_D5XX { !error "CONFIG_SID_2ND_ADDRESS redundant due to CONFIG_SID_D5XX" } }
	!if ((CONFIG_SID_2ND_ADDRESS DIV $100) = $D6) { !ifdef CONFIG_SID_D6XX { !error "CONFIG_SID_2ND_ADDRESS redundant due to CONFIG_SID_D6XX" } }
	!if ((CONFIG_SID_2ND_ADDRESS DIV $100) = $D7) { !ifdef CONFIG_SID_D7XX { !error "CONFIG_SID_2ND_ADDRESS redundant due to CONFIG_SID_D7XX" } }
}
!ifdef CONFIG_SID_3RD_ADDRESS {
	!if (CONFIG_SID_3RD_ADDRESS = $D400)          { !error "CONFIG_SID_3RD_ADDRESS points to the 1st SID" }
	!if (CONFIG_SID_3RD_ADDRESS < $D420)          { !error "CONFIG_SID_3RD_ADDRESS needs hex value from $D420-$D7E0 range" }
	!if (CONFIG_SID_3RD_ADDRESS > $D7E0)          { !error "CONFIG_SID_3RD_ADDRESS needs hex value from $D420-$D7E0 range" }
	!if ((CONFIG_SID_3RD_ADDRESS % $20)   != 0)   { !error "CONFIG_SID_3RD_ADDRESS has to be aligned to $20" }
	!if ((CONFIG_SID_3RD_ADDRESS DIV $100) = $D4) { !ifdef CONFIG_SID_D4XX { !error "CONFIG_SID_3RD_ADDRESS redundant due to CONFIG_SID_D4XX" } }
	!if ((CONFIG_SID_3RD_ADDRESS DIV $100) = $D5) { !ifdef CONFIG_SID_D5XX { !error "CONFIG_SID_3RD_ADDRESS redundant due to CONFIG_SID_D5XX" } }
	!if ((CONFIG_SID_3RD_ADDRESS DIV $100) = $D6) { !ifdef CONFIG_SID_D6XX { !error "CONFIG_SID_3RD_ADDRESS redundant due to CONFIG_SID_D6XX" } }
	!if ((CONFIG_SID_3RD_ADDRESS DIV $100) = $D7) { !ifdef CONFIG_SID_D7XX { !error "CONFIG_SID_3RD_ADDRESS redundant due to CONFIG_SID_D7XX" } }
}
!ifdef CONFIG_SID_2ND_ADDRESS { !ifdef CONFIG_SID_3RD_ADDRESS {
	!if (CONFIG_SID_2ND_ADDRESS = CONFIG_SID_3RD_ADDRESS) { !error "Configured SIDs have the same addresses" }
} }



; Check that keyboard settings are correct

!ifdef CONFIG_LEGACY_SCNKEY {
	!ifdef CONFIG_RS232_UP2400            { !error "CONFIG_LEGACY_SCNKEY is not compatible with CONFIG_RS232_UP2400"               }
	!ifdef CONFIG_RS232_UP9600            { !error "CONFIG_LEGACY_SCNKEY is not compatible with CONFIG_RS232_UP9600"               }
	!ifdef CONFIG_TAPE_NORMAL             { !error "CONFIG_LEGACY_SCNKEY is not compatible with CONFIG_TAPE_NORMAL"                }
	!ifdef CONFIG_KEYBOARD_C128           { !error "CONFIG_LEGACY_SCNKEY is not compatible with CONFIG_KEYBOARD_C128"              }
	!ifdef CONFIG_KEYBOARD_C128_CAPS_LOCK { !error "CONFIG_LEGACY_SCNKEY is not compatible with CONFIG_KEYBOARD_C128_CAPS_LOCK"    }
}
!ifdef CONFIG_MB_M65 {
	!ifdef CONFIG_KEYBOARD_C128           { !error "MEGA65 motherboard is not compatible with CONFIG_KEYBOARD_C128"                }
	!ifdef CONFIG_KEYBOARD_C128_CAPS_LOCK { !error "MEGA65 motherboard is not compatible with CONFIG_KEYBOARD_C128_CAPS_LOCK"      }
	!ifdef CONFIG_LEGACY_SCNKEY           { !error "MEGA65 motherboard is not compatible with CONFIG_LEGACY_SCNKEY"                }
}
!ifdef CONFIG_MB_U64 {
	!ifdef CONFIG_KEYBOARD_C128           { !error "Ultimate 64 motherboard is not compatible with CONFIG_KEYBOARD_C128"           }
	!ifdef CONFIG_KEYBOARD_C128_CAPS_LOCK { !error "Ultimate 64 motherboard is not compatible with CONFIG_KEYBOARD_C128_CAPS_LOCK" }
}



; Check that internal DOS configuration is correct

!ifdef CONFIG_CMDRDOS { !ifndef CONFIG_MB_M65 {
	!error "CONFIG_CMDRDOS requires CONFIG_MB_M65"
} }


; Check that startup banner configuration is correct

!set counter = 0
!ifdef CONFIG_BANNER_SIMPLE { !set counter = counter + 1 }
!ifdef CONFIG_BANNER_FANCY  { !set counter = counter + 1 }

!ifdef CONFIG_MB_M65 {
	!if (counter > 0) { !error "Do not use CONFIG_BANNER_* options for MEGA65"    }
	!ifdef CONFIG_COLORS_BRAND  { !errror "Do not use CONFIG_COLORS_BRAND options for MEGA65" }
	!ifdef CONFIG_SHOW_FEATURES { !errror "Do not use CONFIG_SHOW_FEATURES options for MEGA65" }
} else {
	!if (counter != 1) { !error "Please select exactly one CONFIG_BANNER_* option" }
}



;
; Define some macros depending on the configuration
;


; Handle platform/mothjerboard configuration


!ifdef PLATFORM_COMMODORE_64 { !ifndef CONFIG_MB_M65 { !ifndef CONFIG_MB_U64 {
	!set HAS_128_POSSIBILITY     = 1
} } }


; Handle CPU configuration

!ifdef CONFIG_BCD_SAFE_INTERRUPTS { !set HAS_BCD_SAFE_INTERRUPTS = 1 }

!ifdef CONFIG_CPU_MOS_6502 {
	!cpu 6502
}
!ifdef CONFIG_CPU_DTV_6502 {
	!cpu c64dtv2
	!set HAS_OPCODE_BRA          = 1
	; XXX
}
!ifdef CONFIG_CPU_RCW_65C02 {
	!cpu r65c02
	!set HAS_BCD_SAFE_INTERRUPTS = 1
	!set HAS_OPCODE_BRA          = 1
	!set HAS_OPCODES_65C02       = 1
}
!ifdef CONFIG_PLATFORM_COMMANDER_X16 {
	!cpu w65c02
	!set HAS_BCD_SAFE_INTERRUPTS = 1
	!set HAS_OPCODE_BRA          = 1
	!set HAS_OPCODES_65C02       = 1
}
!ifdef CONFIG_CPU_WDC_65C02 {
	!cpu w65c02
	!set HAS_BCD_SAFE_INTERRUPTS = 1
	!set HAS_OPCODE_BRA          = 1
	!set HAS_OPCODES_65C02       = 1
}
!ifdef CONFIG_CPU_WDC_65816 {
	!cpu 65816
	!set HAS_BCD_SAFE_INTERRUPTS = 1
	!set HAS_OPCODE_BRA          = 1
	!set HAS_OPCODES_65C02       = 1
	!set HAS_OPCODES_65816       = 1
}
!ifdef CONFIG_CPU_CSG_65CE02 {
	!cpu 65ce02
	!set HAS_BCD_SAFE_INTERRUPTS = 1
	!set HAS_OPCODE_BRA          = 1
	!set HAS_OPCODES_65C02       = 1
	!set HAS_OPCODES_65CE02      = 1
}
!ifdef CONFIG_MB_M65 {
	!cpu m65
	!set HAS_BCD_SAFE_INTERRUPTS = 1
	!set HAS_OPCODE_BRA          = 1
	!set HAS_OPCODES_65C02       = 1
	!set HAS_OPCODES_65CE02      = 1
}



; Handle memory model

!ifdef CONFIG_MEMORY_MODEL_46K { !set CONFIG_MEMORY_MODEL_46K_OR_50K = 1 }
!ifdef CONFIG_MEMORY_MODEL_50K { !set CONFIG_MEMORY_MODEL_46K_OR_50K = 1 }



; Handle IEC configuration

!ifdef CONFIG_IEC_BURST_CIA1 { !set HAS_IEC_BURST = 1 }
!ifdef CONFIG_IEC_BURST_CIA2 { !set HAS_IEC_BURST = 1 }
!ifdef CONFIG_IEC_BURST_M65  { !set HAS_IEC_BURST = 1 }

!ifdef CONFIG_IEC_JIFFYDOS   { !set CONFIG_IEC_JIFFYDOS_OR_DOLPHINDOS = 1 }
!ifdef CONFIG_IEC_DOLPHINDOS { !set CONFIG_IEC_JIFFYDOS_OR_DOLPHINDOS = 1 }



; Handle tape configuration

!ifdef CONFIG_TAPE_NORMAL { !set HAS_TAPE = 1 }
!ifdef CONFIG_TAPE_TURBO  { !set HAS_TAPE = 1 }

!ifdef CONFIG_TAPE_NORMAL { !set HAS_TAPE_OR_IEC = 1 }
!ifdef CONFIG_TAPE_TURBO  { !set HAS_TAPE_OR_IEC = 1 }
!ifdef CONFIG_IEC         { !set HAS_TAPE_OR_IEC = 1 }

!ifdef CONFIG_DOS_WEDGE   { !set HAS_WEDGE = 1 }
!ifdef CONFIG_TAPE_WEDGE  { !set HAS_WEDGE = 1 }



; Handle RS-232 configuration

!ifdef CONFIG_RS232_ACIA   { !set HAS_RS232 = 1 }
!ifdef CONFIG_RS232_UP2400 { !set HAS_RS232 = 1 }
!ifdef CONFIG_RS232_UP9600 { !set HAS_RS232 = 1 }



; Handle sound configuration

!ifdef CONFIG_SID_D4XX { !set CONFIG_SID_DX_RANGE = 1 }
!ifdef CONFIG_SID_D5XX { !set CONFIG_SID_DX_RANGE = 1 }
!ifdef CONFIG_SID_D6XX { !set CONFIG_SID_DX_RANGE = 1 }
!ifdef CONFIG_SID_D7XX { !set CONFIG_SID_DX_RANGE = 1 }


; Handle keyboard configuration

!ifdef CONFIG_JOY1_CURSOR             { !set CONFIG_JOY1_OR_JOY2_CURSOR = 1 }
!ifdef CONFIG_JOY2_CURSOR             { !set CONFIG_JOY1_OR_JOY2_CURSOR = 1 }

!ifdef CONFIG_RS232_UP9600 { !set CONFIG_KEY_DELAY = $18 } else { !set CONFIG_KEY_DELAY = $16 }


; Handle debug configuration

!macro STUB_IMPLEMENTATION_RTS { 
	rts
}

!macro STUB_IMPLEMENTATION_BRK { 
	; XXX set VICE breakpoint
	brk
	brk
	jmp *-2
}

!ifdef CONFIG_DBG_STUBS_BRK {
	!macro STUB_IMPLEMENTATION { +STUB_IMPLEMENTATION_BRK }
} else {
	!macro STUB_IMPLEMENTATION { +STUB_IMPLEMENTATION_RTS }
}



; Handle colors

!set CONFIG_COLOR_BG  = $06
!set CONFIG_COLOR_TXT = $01

!ifdef CONFIG_COLORS_BRAND {
	!ifdef CONFIG_MB_U64 {
		!set CONFIG_COLOR_BG  = $00
		!set CONFIG_COLOR_TXT = $01
	}
}



; Handle non-LGPL3 code

!ifdef CONFIG_CMDRDOS { !set HAS_NOLGPL3_WARN = 1 }



; Determine if we need space-savings in BASIC code

!ifndef CONFIG_MB_M65 { !ifndef ROM_LAYOUT_CRT {
	!set HAS_SMALL_BASIC = 1
} }



; Determine if it is OK to include tape autocalibration routines; they are too slow to be safely used at 1 MHz CPU speed

!ifdef HAS_TAPE {
	!ifdef CONFIG_MB_M65 {
	    !set HAS_TAPE_AUTOCALIBRATE = 1
    }
}

; XXX adapt autocalibration to Ultimate64 once additional Kernal bank is available



; Defines for multi-segment ROMs

!ifdef CONFIG_MB_M65 {
	!ifdef SEGMENT_BASIC_0  { !set SEGMENT_M65_BASIC_0  = 1 }
	!ifdef SEGMENT_BASIC_1  { !set SEGMENT_M65_BASIC_1  = 1 }
	!ifdef SEGMENT_KERNAL_0 { !set SEGMENT_M65_KERNAL_0 = 1 }
	!ifdef SEGMENT_KERNAL_1 { !set SEGMENT_M65_KERNAL_1 = 1 }
}

!ifdef ROM_LAYOUT_CRT {
	!ifdef SEGMENT_BASIC_0  { !set SEGMENT_CRT_BASIC_0  = 1 }
	!ifdef SEGMENT_BASIC_1  { !set SEGMENT_CRT_BASIC_1  = 1 }
	!ifdef SEGMENT_KERNAL_0 { !set SEGMENT_CRT_KERNAL_0 = 1 }
	!ifdef SEGMENT_KERNAL_1 { !set SEGMENT_CRT_KERNAL_1 = 1 }
}
