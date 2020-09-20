
;
; Names of hardware registers
;


!ifdef CONFIG_PLATFORM_COMMANDER_X16 {

	; VERA registers

	!addr __VERA_BASE   = $9F20  ; base address of the chip

	!addr VERA_ADDR_LO  = $9F20
	!addr VERA_ADDR_MID = $9F21
	!addr VERA_ADDR_HI  = $9F22

	!addr VERA_DATA0    = $9F23
	!addr VERA_DATA1    = $9F24

	!addr VERA_CTRL     = $9F25

	!addr VERA_IEN      = $9F26
	!addr VERA_ISR      = $9F27

	; VIA #1 registers

	!addr __VIA1_BASE  = $9F60  ; base address of the chip

	!addr VIA1_PRB     = $9F60
	!addr VIA1_PRA     = $9F61
	!addr VIA1_DDRB    = $9F62
	!addr VIA1_DDRA    = $9F63

	!addr VIA1_T1C_L   = $9F64
	!addr VIA1_T1C_H   = $9F65
	!addr VIA1_T1L_L   = $9F66
	!addr VIA1_T1L_H   = $9F67
	!addr VIA1_T2C_L   = $9F68
	!addr VIA1_T2C_H   = $9F69

	!addr VIA1_SR      = $9F6A
	!addr VIA1_ACR     = $9F6B
	!addr VIA1_PCR     = $9F6C
	!addr VIA1_IFR     = $9F6D
	!addr VIA1_IER     = $9F6E

	!addr VIA1_PRA_NH  = $9F6F

	; VIA #2 registers

	!addr __VIA2_BASE  = $9F70  ; base address of the chip

	!addr VIA2_PRB     = $9F70
	!addr VIA2_PRA     = $9F71
	!addr VIA2_DDRB    = $9F72
	!addr VIA2_DDRA    = $9F73

	!addr VIA2_T1C_L   = $9F74
	!addr VIA2_T1C_H   = $9F75
	!addr VIA2_T1L_L   = $9F76
	!addr VIA2_T1L_H   = $9F77
	!addr VIA2_T2C_L   = $9F78
	!addr VIA2_T2C_H   = $9F79

	!addr VIA2_SR      = $9F7A
	!addr VIA2_ACR     = $9F7B
	!addr VIA2_PCR     = $9F7C
	!addr VIA2_IFR     = $9F7D
	!addr VIA2_IER     = $9F7E

	!addr VIA2_PRA_NH  = $9F7F
}
