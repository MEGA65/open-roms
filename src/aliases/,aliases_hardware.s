
;
; Names of hardware registers - names from C64 Programmer's Reference Guide, sometimes slightly modified
;


!ifdef CONFIG_PLATFORM_COMMODORE_64 {

	; CPU memory registers

	!addr CPU_D6510    = $00
	!addr CPU_R6510    = $01

	; VIC-II registers

	!addr __VIC_BASE   = $D000  ; base address of the chip

	!addr VIC_SP0X     = $D000
	!addr VIC_SP0Y     = $D001
	!addr VIC_SP1X     = $D002
	!addr VIC_SP1Y     = $D003
	!addr VIC_SP2X     = $D004
	!addr VIC_SP2Y     = $D005
	!addr VIC_SP3X     = $D006
	!addr VIC_SP3Y     = $D007
	!addr VIC_SP4X     = $D008
	!addr VIC_SP4Y     = $D009
	!addr VIC_SP5X     = $D00A
	!addr VIC_SP5Y     = $D00B
	!addr VIC_SP6X     = $D00C
	!addr VIC_SP6Y     = $D00D
	!addr VIC_SP7X     = $D00E
	!addr VIC_SP7Y     = $D00F

	!addr VIC_MSIGX    = $D010
	!addr VIC_SCROLY   = $D011
	!addr VIC_RASTER   = $D012
	!addr VIC_LPENX    = $D013
	!addr VIC_LPENY    = $D014
	!addr VIC_SPENA    = $D015
	!addr VIC_SCROLX   = $D016
	!addr VIC_YXPAND   = $D017
	!addr VIC_YMCSB    = $D018
	!addr VIC_IRQ      = $D019
	!addr VIC_IRQMSK   = $D01A
	!addr VIC_SPBGPR   = $D01B
	!addr VIC_SPMC     = $D01C
	!addr VIC_XXPAND   = $D01D
	!addr VIC_SPSPCL   = $D01E
	!addr VIC_SPBGCL   = $D01F

	!addr VIC_EXTCOL   = $D020
	!addr VIC_BGCOL0   = $D021
	!addr VIC_BGCOL1   = $D022
	!addr VIC_BGCOL2   = $D023
	!addr VIC_BGCOL3   = $D024
	!addr VIC_SPMC0    = $D025
	!addr VIC_SPMC1    = $D026
	!addr VIC_SP0COL   = $D027
	!addr VIC_SP1COL   = $D028
	!addr VIC_SP2COL   = $D029
	!addr VIC_SP3COL   = $D02A
	!addr VIC_SP4COL   = $D02B
	!addr VIC_SP5COL   = $D02C
	!addr VIC_SP6COL   = $D02D
	!addr VIC_SP7COL   = $D02E

!ifndef CONFIG_MB_M65 { !ifndef CONFIG_MB_U64 {

	!addr VIC_XSCAN    = $D02F ; C128 only
	!addr VIC_CLKRATE  = $D030 ; C128 only
} }

!ifdef CONFIG_MB_U64 {

	; Ultimate 64 registers

	!addr U64_TURBOBIT = $D030 ; 0 = 1 MHz + badlines, 1 = settings from menu
	!addr U64_TURBOCTL = $D031 ; bit 0-3 = CPU speed (index), bit 7 = disable badlines, $FF = not available
}

	; SID registers

	!addr __SID_BASE   = $D400  ; base address of the chip

	!addr SID_FRELO1   = $D400
	!addr SID_FREHI1   = $D401
	!addr SID_PWLO1    = $D402
	!addr SID_PWHI1    = $D403
	!addr SID_VCREG1   = $D404
	!addr SID_ATDCY1   = $D405
	!addr SID_SUREL1   = $D406

	!addr SID_FRELO2   = $D407
	!addr SID_FREHI2   = $D408
	!addr SID_PWLO2    = $D409
	!addr SID_PWHI2    = $D40A
	!addr SID_VCREG2   = $D40B
	!addr SID_ATDCY2   = $D40C
	!addr SID_SUREL2   = $D40D

	!addr SID_FRELO3   = $D40E
	!addr SID_FREHI3   = $D40F
	!addr SID_PWLO3    = $D410
	!addr SID_PWHI3    = $D411
	!addr SID_VCREG3   = $D412
	!addr SID_ATDCY3   = $D413
	!addr SID_SUREL3   = $D414

	!addr SID_CUTLO    = $D415
	!addr SID_CUTHI    = $D416
	!addr SID_RESON    = $D417
	!addr SID_SIGVOL   = $D418
	!addr SID_POTX     = $D419
	!addr SID_POTY     = $D41A
	!addr SID_RANDOM   = $D41B
	!addr SID_ENV3     = $D41C

	; Color COLOR_RAM

	!addr COLOR_RAM    = $D800

	; CIA #1 registers

	!addr __CIA1_BASE  = $DC00  ; base address of the chip

	!addr CIA1_PRA     = $DC00
	!addr CIA1_PRB     = $DC01
	!addr CIA1_DDRA    = $DC02
	!addr CIA1_DDRB    = $DC03

	!addr CIA1_TIMALO  = $DC04
	!addr CIA1_TIMAHI  = $DC05
	!addr CIA1_TIMBLO  = $DC06
	!addr CIA1_TIMBHI  = $DC07

	!addr CIA1_TODTEN  = $DC08
	!addr CIA1_TODSEC  = $DC09
	!addr CIA1_TODMIN  = $DC0A
	!addr CIA1_TODHRS  = $DC0B

	!addr CIA1_SDR     = $DC0C
	!addr CIA1_ICR     = $DC0D
	!addr CIA1_CRA     = $DC0E
	!addr CIA1_CRB     = $DC0F

	; CIA #2 registers

	!addr __CIA2_BASE  = $DD00  ; base address of the chip

	!addr CIA2_PRA     = $DD00  ; VIC bank switching and IEC port
	!addr CIA2_PRB     = $DD01
	!addr CIA2_DDRA    = $DD02
	!addr CIA2_DDRB    = $DD03

	!addr CIA2_TIMALO  = $DD04
	!addr CIA2_TIMAHI  = $DD05
	!addr CIA2_TIMBLO  = $DD06
	!addr CIA2_TIMBHI  = $DD07

	!addr CIA2_TODTEN  = $DD08
	!addr CIA2_TODSEC  = $DD09
	!addr CIA2_TODMIN  = $DD0A
	!addr CIA2_TODHRS  = $DD0B

	!addr CIA2_SDR     = $DD0C
	!addr CIA2_ICR     = $DD0D
	!addr CIA2_CRA     = $DD0E
	!addr CIA2_CRB     = $DD0F

	; CIA #2 helper bits - IEC bus
	
	!set BIT_CIA2_PRA_ATN_OUT  = $08  ; 1 - low (pulled), 0 - high (released)
	!set BIT_CIA2_PRA_CLK_OUT  = $10  ; 1 - low (pulled), 0 - high (released)
	!set BIT_CIA2_PRA_DAT_OUT  = $20  ; 1 - low (pulled), 0 - high (released)
	!set BIT_CIA2_PRA_CLK_IN   = $40  ; 0 - low (pulled), 1 - high (released)
	!set BIT_CIA2_PRA_DAT_IN   = $80  ; 0 - low (pulled), 1 - high (released)

	; SuperCPU registers

!ifndef CONFIG_MB_M65 {

	!addr SCPU_SPEED_NORMAL = $D07A
	!addr SCPU_SPEED_TURBO  = $D07B
}

}
