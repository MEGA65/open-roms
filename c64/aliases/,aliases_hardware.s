
;;
;; Names of hardware registers - slightly modified names from C64 Programmer's Reference Guide
;;

	;; CPU memory registers

	.alias CPU_D6510      $0000
	.alias CPU_R6510      $0001

	;; VIC-II registers

	.alias VIC_SP0X       $D000
	.alias VIC_SP0Y       $D001
	.alias VIC_SP1X       $D002
	.alias VIC_SP1Y       $D003
	.alias VIC_SP2X       $D004
	.alias VIC_SP2Y       $D005
	.alias VIC_SP3X       $D006
	.alias VIC_SP3Y       $D007
	.alias VIC_SP4X       $D008
	.alias VIC_SP4Y       $D009
	.alias VIC_SP5X       $D00A
	.alias VIC_SP5Y       $D00B
	.alias VIC_SP6X       $D00C
	.alias VIC_SP6Y       $D00D
	.alias VIC_SP7X       $D00E
	.alias VIC_SP7Y       $D00F

	.alias VIC_MSIGX      $D010
	.alias VIC_SCROLLY    $D011
	.alias VIC_RASTER     $D012
	.alias VIC_LPENX      $D013
	.alias VIC_LPENY      $D014
	.alias VIC_SPENA      $D015
	.alias VIC_SCROLX     $D016
	.alias VIC_YXPAND     $D017
	.alias VIC_YMCSB      $D018
	.alias VIC_IRQ        $D019
	.alias VIC_IRQMSK     $D01A
	.alias VIC_SPBGPR     $D01B
	.alias VIC_SPMC       $D01C
	.alias VIC_XXPAND     $D01D
	.alias VIC_SPSPCL     $D01E
	.alias VIC_SPBGCL     $D01F

	.alias VIC_EXTCOL     $D020
	.alias VIC_BGCOL0     $D021
	.alias VIC_BGCOL1     $D022
	.alias VIC_BGCOL2     $D023
	.alias VIC_BGCOL3     $D024
	.alias VIC_SPMC0      $D025
	.alias VIC_SPMC1      $D026
	.alias VIC_SP0COL     $D027
	.alias VIC_SP1COL     $D028
	.alias VIC_SP2COL     $D029
	.alias VIC_SP3COL     $D02A
	.alias VIC_SP4COL     $D02B
	.alias VIC_SP5COL     $D02C
	.alias VIC_SP6COL     $D02D
	.alias VIC_SP7COL     $D02E
	
	;; SID #1 registers

	.alias SID1_FRELO1    $D400
	.alias SID1_FREHI1    $D401
	.alias SID1_PWLO1     $D402
	.alias SID1_PWHI1     $D403
	.alias SID1_VCREG1    $D404
	.alias SID1_ATDCY1    $D405
	.alias SID1_SUREL1    $D406

	.alias SID1_FRELO2    $D407
	.alias SID1_FREHI2    $D408
	.alias SID1_PWLO2     $D409
	.alias SID1_PWHI2     $D40A
	.alias SID1_VCREG2    $D40B
	.alias SID1_ATDCY2    $D40C
	.alias SID1_SUREL2    $D40D

	.alias SID1_FRELO3    $D40E
	.alias SID1_FREHI3    $D40F
	.alias SID1_PWLO3     $D410
	.alias SID1_PWHI3     $D411
	.alias SID1_VCREG3    $D412
	.alias SID1_ATDCY3    $D413
	.alias SID1_SUREL3    $D414

	.alias SID1_CUTLO     $D415
	.alias SID1_CUTHI     $D416
	.alias SID1_RESON     $D417
	.alias SID1_SIGVOL    $D418
	.alias SID1_POTX      $D419
	.alias SID1_POTY      $D41A
	.alias SID1_RANDOM    $D41B
	.alias SID1_ENV3      $D41C

	;; SID #2, #3, #4 registers

	.alias SID2_SIGVOL    $D438
	.alias SID3_SIGVOL    $D458
	.alias SID4_SIGVOL    $D478

	;; CIA #1 registers

	.alias CIA1_PRA       $DC00
	.alias CIA1_PRB       $DC01
	.alias CIA1_DDRA      $DC02
	.alias CIA1_DDRB      $DC03

	.alias CIA1_TIMALO    $DC04
	.alias CIA1_TIMAHI    $DC05
	.alias CIA1_TIMBLO    $DC06
	.alias CIA1_TIMBHI    $DC07

	.alias CIA1_TODTEN    $DC08
	.alias CIA1_TODSEC    $DC09
	.alias CIA1_TODMIN    $DC0A
	.alias CIA1_TODHRS    $DC0B

	.alias CIA1_SDR       $DC0C
	.alias CIA1_ICR       $DC0D
	.alias CIA1_CRA       $DC0E
	.alias CIA1_CRB       $DC0F

	;; CIA #2 registers

	.alias CIA2_PRA       $DD00 ; VIC bank switching and IEC port
	.alias CIA2_PRB       $DD01
	.alias CIA2_DDRA      $DD02
	.alias CIA2_DDRB      $DD03

	.alias CIA2_TIMALO    $DD04
	.alias CIA2_TIMAHI    $DD05
	.alias CIA2_TIMBLO    $DD06
	.alias CIA2_TIMBHI    $DD07

	.alias CIA2_TODTEN    $DD08
	.alias CIA2_TODSEC    $DD09
	.alias CIA2_TODMIN    $DD0A
	.alias CIA2_TODHRS    $DD0B

	.alias CIA2_SDR       $DD0C
	.alias CIA2_ICR       $DD0D
	.alias CIA2_CRA       $DD0E
	.alias CIA2_CRB       $DD0F

	;; CIA #2 helper bits - IEC bus
	
	.alias BIT_CIA2_PRA_ATN_OUT $08    ; 1 - low (pulled), 0 - high (released)
	.alias BIT_CIA2_PRA_CLK_OUT $10    ; 1 - low (pulled), 0 - high (released)
	.alias BIT_CIA2_PRA_DAT_OUT $20    ; 1 - low (pulled), 0 - high (released)
	.alias BIT_CIA2_PRA_CLK_IN  $40    ; 0 - low (pulled), 1 - high (released)
	.alias BIT_CIA2_PRA_DAT_IN  $80    ; 0 - low (pulled), 1 - high (released)
