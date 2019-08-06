;;
;; Names of ZP and low memory locations
;; (https://www.c64-wiki.com/wiki/Zeropage)
;;

	;; $00-$01 - 6502 CPU registers are here

    ;;
	;; Page 0 - BASIC area ($02-$8F)
    ;;
	
	.alias TXTTAB     $2B

    ;;
	;; Page 0 - Kernal area ($90-$FF)
    ;;
	
	.alias IOSTATUS   $90
	.alias STKEY      $91 ; Keys down clears bits. STOP - bit 7, C= - bit 6, SPACE - bit 4, CTRL - bit 2
	
	.alias VERCK      $93 ; 0 = LOAD, 1 = VERIVY
	
	.alias C3PO       $94 ; flag - is BSOUR content valid
	.alias BSOUR      $95 ; serial bus buffered output byte

	.alias LDTND      $98 ; number of entries in LAT / FAT / SAT tables
	.alias DFLTN      $99
	.alias DFLTO      $9A
	
	.alias MSGFLG     $9D ; bit 6 = error messages, bit 7 = control message

	.alias TIME       $A0 ; $A0-$A2, jiffy clock

	.alias IEC_TMP1   $A3 ; temporary variable for tape and IEC
	.alias IEC_TMP2   $A4 ; temporary variable for tape and IEC

	;; 2-byte location below seems to be a good place for temporary storage,
	;; it seems used for timing during tape reads only - see:
	;; - 'C64 Programmer's Reference Guide', page 314
	;; - 'Compute's Mapping the Commodore 64', page 32
	.alias CMP0       $B0 ; $B0-$B1
	
	.alias FNLEN      $B7 ; current file name length

	.alias FNADDR     $BB ; $BB-$BC, current file name pointer

	.alias STAL       $C1 ; $C1-$C2 LOAD/SAVE start address

	;;
	;; Other low memory addresses
	;;
    
	.alias BUF        $200 ; $200-$250 (81 bytes), BASIC line editor input buffer

	;; Kernal tables for opened files, 10 entries each
	.alias LAT        $259 ; logical file numbers
	.alias FAT        $263 ; device numbers
	.alias SAT        $26D ; secondary addresses

	.alias MEMSTR     $281
	.alias MEMSIZ     $283 ; NOTE: Mapping the 64 erroniously has the hex as $282, while the DEC is correct

	.alias TIMOUT     $285 ; IEEE-488 timeout

	.alias HIBASE     $288 ; high byte of start of screen

	.alias RSSTAT     $297 ; RS-232 status

	.alias PALNTSC    $2A6 ; 0 = NTSC, 1 = PAL
	
	
	;; Registers for SYS call
	.alias SAREG      $30C
	.alias SXREG      $30D
	.alias SYREG      $30E
	.alias SPREG      $30F

	.alias USRPOK     $310 ; JMP instruction
	.alias USRADD     $311 ; $311 - $312
	
	;; Kernal vectors - interrupts
	.alias CINV       $314
	.alias CBINV      $316 
	.alias NMINV      $318
	
	;; Kernal vectors - routines
	.alias IOPEN      $31A
	.alias ICLOSE     $31C
	.alias ICHKIN     $31E
	.alias ICKOUT     $320
	.alias ICLRCH     $322
	.alias IBASIN     $324
	.alias IBSOUT     $326
	.alias ISTOP      $328
	.alias IGETIN     $32A
	.alias ICLALL     $32C
	.alias USRCMD     $32E
	.alias ILOAD      $330
	.alias ISAVE      $331

	.alias TBUFFR     $33C ; $33C-$3FB, tape buffer	
