;
; Names of ZP and low memory locations:
; - Computes Mapping the Commodore 64
; - https://www.c64-wiki.com/wiki/Zeropage
; - http://unusedino.de/ec64/technical/project64/memory_maps.html
;

	; $00-$01 - 6502 CPU registers are here

	;
	; Page 0 - BASIC area ($02-$8F)
	;

	;                 $02             -- UNUSED --          free for user software
	!addr ADRAY1    = $03 ; $03-$04
	!addr ADRAY2    = $05 ; $05-$06
	!addr CHARAC    = $07 ;          [!] our implementation might be different  XXX give more details
	!addr ENDCHR    = $08 ;          [!] our implementation might be different  XXX give more details
	!addr TRMPOS    = $09 ;          -- NOT IMPLEMENTED -- [!] on MEGA65 also used by DOS Wedge under MONITOR
	!addr VERCKB    = $0A ;          flag used by BASIC, 0 - LOAD, 1 - VERIFY, [!] on MEGA65 also used by DOS Wedge
	!addr COUNT     = $0B ;          [!] our implementation might be different  XXX give more details
	!addr DIMFLG    = $0C ;          [!] our implementation might be different  XXX give more details
	!addr VALTYP    = $0D ;          expression eveluation result; $00 - float, $FF - string
	!addr INTFLG    = $0E ;          -- NOT IMPLEMENTED --
	!addr GARBFL    = $0F ;          [!] our implementation might be different  XXX give more details
	!addr SUBFLG    = $10 ;          -- NOT IMPLEMENTED --
	!addr INPFLG    = $11 ;          -- NOT IMPLEMENTED --
	!addr TANSGN    = $12 ;          -- NOT IMPLEMENTED --
	!addr CHANNL    = $13 ;          -- NOT IMPLEMENTED --
	!addr LINNUM    = $14 ; $14-$15  BASIC line number, [!] also used by DOS Wedge
	!addr TEMPPT    = $16 ;          pointer to the first available slot in the temporary string descriptor stack
	!addr LASTPT    = $17 ; $17-$18  pointer to the last used slot in the temporary string descriptor
	!addr TEMPST    = $19 ; $19-$21  temporary string stack descriptors
	!addr INDEX     = $22 ; $22-$25  temporary variables, [!] our usage might be different
	!addr RESHO     = $26 ; $26-$2A  temporary variables, [!] our usage might be different
	!addr TXTTAB    = $2B ; $2B-$2C  start of BASIC code
	!addr VARTAB    = $2D ; $2D-$2E  end of BASIC code, start of variables
	!addr ARYTAB    = $2F ; $2F-$30  pointer to start of array storage
	!addr STREND    = $31 ; $31-$32  pointer to start of free RAM
	!addr FRETOP    = $33 ; $33-$34  pointer to bottom of strings area
	!addr FRESPC    = $35 ; $35-$36  [!] our implementation uses this as temporary string pointer
	!addr MEMSIZ    = $37 ; $37-$38  highest address of BASIC memory + 1
	!addr CURLIN    = $39 ; $39-$3A  current BASIC line number
	!addr OLDLIN    = $3B ; $3B-$3C  previous BASIC line number
	!addr OLDTXT    = $3D ; $3D-$3E  current BASIC line pointer
	!addr DATLIN    = $3F ; $3F-$40  -- NOT IMPLEMENTED --
	!addr DATPTR    = $41 ; $41-$42  pointer for READ/DATA copmmands
	!addr INPPTR    = $43 ; $43-$44  -- NOT IMPLEMENTED --
	!addr VARNAM    = $45 ; $45-$46  current variable name
	!addr VARPNT    = $47 ; $47-$48  current variable/descriptor pointer
	!addr FORPNT    = $49 ; $49-$4A  -- NOT IMPLEMENTED --
	!addr OPPTR     = $4B ; $4B-$4C  helper variable for expression computation, [!] our usage details are different
	!addr OPMASK    = $4D ;          -- NOT IMPLEMENTED --
	!addr DEFPNT    = $4E ; $4E-$4F  -- NOT IMPLEMENTED --
	!addr DSCPNT    = $50 ; $50-$52  temporary area fro string handling, [!] our usage might differ
	!addr FOUR6     = $53 ;          size of variable content (float = 5, integer = 2, string descriptor = 3)
	!addr JMPER     = $54 ; $54-$56  -- NOT IMPLEMENTED --
	!addr TEMPF1    = $57 ; $57-$5B  BASIC numeric work area
	!addr TEMPF2    = $5C ; $5C-$60  BASIC numeric work area

	!addr __FAC1    = $61 ; $61-$66  floating point accumulator 1
	!addr FAC1_exponent   = $61
	!addr FAC1_mantissa   = $62 ; $62 - $65
	!addr FAC1_sign       = $66

	!addr SGNFLG    = $67 ;          -- NOT IMPLEMENTED --
	!addr BITS      = $68 ;          FAC1 overflow

	!addr __FAC2    = $69 ; $69-$6E  floating point accumulator 2 [!] also used for memory move pointers
	!addr FAC2_exponent   = $69
	!addr FAC2_mantissa   = $6A ; $6A - $6D
	!addr FAC2_sign       = $6E

	!addr ARISGN    = $6F ;          -- NOT IMPLEMENTED --
	!addr FACOV     = $70 ;          FAC1 low order mantissa
	!addr FBUFPT    = $71 ; $71-$72  -- NOT IMPLEMENTED --
	!addr CHRGET    = $73 ; $73-$8A  -- NOT IMPLEMENTED --
	!addr TXTPTR    = $7A ; $7A-$7B  current BASIC statement pointer
	!addr RNDX      = $8B ; $8B-$8F  random number seed

	;
	; Page 0 - Kernal area ($90-$FF)
	;
	
	!addr IOSTATUS  = $90
	!addr STKEY     = $91  ;          keys down clears bits. STOP - bit 7, C= - bit 6, SPACE - bit 4, CTRL - bit 2
	!addr SVXT      = $92  ;          tape reading constant [!] our tape routines use it differently
	!addr VERCKK    = $93  ;          0 = LOAD, 1 = VERIFY
	!addr C3PO      = $94  ;          flag - is BSOUR content valid
	!addr BSOUR     = $95  ;          serial bus buffered output byte
	!addr SYNO      = $96  ;          temporary tape routines storage, [!] our usage differs
	!addr XSAV      = $97  ;          temporary register storage for ASCII/tape related routines [!] usage details might differ
	!addr LDTND     = $98  ;          number of entries in LAT / FAT / SAT tables
	!addr DFLTN     = $99  ;          default input device
	!addr DFLTO     = $9A  ;          default output device
	!addr PRTY      = $9B  ;          tape storage for parity/checksum
!ifndef HAS_TAPE {
	!addr DPSW      = $9C  ;          -- NOT IMPLEMENTED --
} else {
    !addr COLSTORE  = $9C  ;          [!] screen border storage for tape routines 
}
	!addr MSGFLG    = $9D  ;          bit 6 = error messages, bit 7 = control message
	!addr PTR1      = $9E  ;          for tape support, counter of errorneous bytes             [!] also used by PRIMM and other routines
	!addr PTR2      = $9F  ;          for tape support, counter for errorneous bytes correction [!] also used by PRIMM and other routines
	!addr TIME      = $A0  ; $A0-$A2  jiffy clock
	!addr IECPROTO  = $A3  ;          [!] IEC or pseudo-IEC protocol, >= $80 for unknown; originally named TSFCNT
	!addr TBTCNT    = $A4  ;          temporary variable for tape and IEC, [!] our usage probably differs in details
	!addr CNTDN     = $A5  ;          -- NOT IMPLEMENTED --
	!addr BUFPNT    = $A6  ;          -- NOT IMPLEMENTED --
	!addr INBIT     = $A7  ;          temporary storage for tape / RS-232 received bits
	!addr BITCI     = $A8  ;          -- NOT IMPLEMENTED --
	!addr RINONE    = $A9  ;          -- WIP -- (UP9600 only) RS-232 check for start bit flag
	!addr RIDDATA   = $AA  ;          -- NOT IMPLEMENTED --
	!addr RIPRTY    = $AB  ;          -- WIP -- checksum while reading tape
	!addr SAL       = $AC  ; $AC-$AD  -- XXX: describe -- (implemented screen part)
	!addr EAL       = $AE  ; $AE-$AF  -- XXX: describe -- [!] used also by screen editor, for temporary color storage when scrolling
	!addr CMP0      = $B0  ; $B0-$B1  temporary tape storage, [!] here used for BRK instruction address
	!addr TAPE1     = $B2  ; $B2-$B3  tape buffer pointer
	!addr BITTS     = $B4  ;          -- NOT IMPLEMENTED --
	!addr NXTBIT    = $B5  ;          -- NOT IMPLEMENTED -- [!] also used by tape routine to store CPU turbo settings
	!addr RODATA    = $B6  ;          -- NOT IMPLEMENTED --
	!addr FNLEN     = $B7  ;          current file name length
	!addr LA        = $B8  ;          current logical_file number
	!addr SA        = $B9  ;          current secondary address
	!addr FA        = $BA  ;          current unit number
	!addr FNADDR    = $BB  ; $BB-$BC  current file name pointer
	!addr ROPRTY    = $BD  ;          -- NOT IMPLEMENTED -- tape / RS-232 temporary storage
	!addr FSBLK     = $BE  ;          -- NOT IMPLEMENTED -- tape / RS-232 temporary storage
	!addr MYCH      = $BF  ;          -- NOT IMPLEMENTED --
	!addr CAS1      = $C0  ;          tape motor interlock
	!addr STAL      = $C1  ; $C1-$C2  LOAD/SAVE start address
	!addr MEMUSS    = $C3  ; $C3-$C4  temporary address for tape LOAD/SAVE
	!addr LSTX      = $C5  ;          last key matrix position [!] our usage probably differs in details
	!addr NDX       = $C6  ;          number of chars in keyboard buffer
	!addr RVS       = $C7  ;          flag, whether to print reversed characters
	!addr INDX      = $C8  ;          end of logical line (column, 0-79)
	!addr LSXP      = $C9  ; $C9-$CA  start of input, X/Y position (typo in Mapping the C64, fixed in Mapping the C128)
	!addr SFDX      = $CB  ;          -- NOT IMPLEMENTED --
	!addr BLNSW     = $CC  ;          cursor blink disable flag
	!addr BLNCT     = $CD  ;          cursor blink countdown
	!addr GDBLN     = $CE  ;          cursor saved character
	!addr BLNON     = $CF  ;          cursor visibility flag
	!addr CRSW      = $D0  ;          whether to input from screen or keyboard (if from screen, stores input offset)
	!addr PNT       = $D1  ; $D1-$D2  pointer to the current screen line
	!addr PNTR      = $D3  ;          current screen X position (logical column), 0-79
	!addr QTSW      = $D4  ;          quote mode flag
	!addr LNMX      = $D5  ;          logical line length, 39 or 79
	!addr TBLX      = $D6  ;          current screen Y position (row), 0-24
	!addr SCHAR     = $D7  ;          ASCII value of the last printed character
	!addr INSRT     = $D8  ;          insert mode flag/counter
	!addr LDTB1     = $D9  ; $D9-$F2  screen line link table, [!] our usage is different  XXX give more details
	!addr USER      = $F3  ; $F3-$F4  pointer to current color RAM location
	!addr KEYTAB    = $F5  ; $F5-$F6  pointer to keyboard lookup table
	!addr RIBUF     = $F7  ; $F7-$F8  -- WIP -- RS-232 receive buffer pointer
	!addr ROBUF     = $F9  ; $F9-$FA  -- WIP -- RS-232 send buffer pointer
	;                 $FB    $FB-$FE  -- UNUSED --          free for user software
	!addr BASZPT    = $FF  ;          -- NOT IMPLEMENTED --

	;
	; Page 1
	;

	!addr STACK     = $100  ; $100-$1FF, processor stack

	;
	; Pages 2 & 3
	;
    
	!addr BUF       = $200  ; $200-$250, BASIC line editor input buffer (81 bytes)

	; $250-$258 is the 81st - 88th characters in BASIC input, a carry over from VIC-20

	; [!] XXX document $251-$258 usage
	!addr LAT       = $259  ; $259-$262, logical file numbers (table, 10 bytes)
	!addr FAT       = $263  ; $263-$26C, device numbers       (table, 10 bytes)
	!addr SAT       = $26D  ; $26D-$276, secondary addresses  (table, 10 bytes)
	!addr KEYD      = $277  ; $277-$280, keyboard buffer
	!addr MEMSTR    = $281  ; $281-$282, start of BASIC memory
	!addr MEMSIZK   = $283  ; $283-$284, NOTE: Mapping the 64 erroneously has the hex as $282 (DEC is correct)
	!addr TIMOUT    = $285  ;            IEEE-488 timeout
	!addr COLOR     = $286  ;            current text foreground color
	!addr GDCOL     = $287  ;            color of character under cursor
	!addr HIBASE    = $288  ;            high byte of start of screen
	!addr XMAX      = $289  ;            max keyboard buffer size
	!addr RPTFLG    = $28A  ;            whether to repeat keys (highest bit set = repeat)
	!addr KOUNT     = $28B  ;            key repeat counter
	!addr DELAY     = $28C  ;            -- NOT IMPLEMENTED --
	!addr SHFLAG    = $28D  ;            bucky keys (SHIFT/CTRL/C=) flags
	!addr LSTSHF    = $28E  ;            last bucky key flags
	!addr KEYLOG    = $28F  ; $28F-$290  routine to setup keyboard decoding
	!addr MODE      = $291  ;            flag, is case switch allowed
	!addr AUTODN    = $292  ;            -- NOT IMPLEMENTED -- screen scroll disable
	!addr M51CRT    = $293  ;            -- NOT IMPLEMENTED -- mock 6551
	!addr M51CDR    = $294  ;            -- NOT IMPLEMENTED -- mock 6551
	!addr M51AJB    = $295  ; $295-$296  -- NOT IMPLEMENTED -- mock 6551
	!addr RSSTAT    = $297  ;            -- WIP -- (UP9600 only) mock 6551, RS-232 status
	!addr BITNUM    = $298  ;            -- NOT IMPLEMENTED --
	!addr BAUDOF    = $299  ; $299-$29A  -- NOT IMPLEMENTED --
	!addr RIDBE     = $29B  ;            -- WIP -- write pointer into RS-232 receive buffer
	!addr RIDBS     = $29C  ;            -- WIP -- read pointer into RS-232 receive buffer
	!addr RODBS     = $29D  ;            -- WIP -- read pointer into RS-232 send buffer
	!addr RODBE     = $29E  ;            -- WIP -- write pointer into RS-232 send buffer
	!addr IRQTMP    = $29F  ; $29F-$2A0  temporary IRQ vector storage [!] we use it for tape speed calibration instead
	!addr ENABL     = $2A1  ;            -- NOT IMPLEMENTED --
	!addr TODSNS    = $2A2  ;            -- NOT IMPLEMENTED --
	!addr TRDTMP    = $2A3  ;            -- NOT IMPLEMENTED --
	!addr TD1IRQ    = $2A4  ;            -- NOT IMPLEMENTED --
	!addr TLNIDX    = $2A5  ;            -- NOT IMPLEMENTED --
	!addr TVSFLG    = $2A6  ;            0 = NTSC, 1 = PAL
	
	; [!] $2A7-$2FF is normally free, but in our case some extra functionality uses it

!ifdef CONFIG_MEMORY_MODEL_60K {

	; IRQs are disabled when doing such accesses, and a default NMI handler only increments
	; a counter, so that if an NMI occurs, it does not crash the machine, but can be captured.

	!addr missed_nmi_flag         = $2A7
	!addr tiny_nmi_handler        = $2A8
	!addr peek_under_roms         = tiny_nmi_handler + peek_under_roms_routine - tiny_nmi_handler_routine
	!addr poke_under_roms         = tiny_nmi_handler + poke_under_roms_routine - tiny_nmi_handler_routine
	!addr memmap_allram           = tiny_nmi_handler + memmap_allram_routine   - tiny_nmi_handler_routine
	!addr memmap_normal           = tiny_nmi_handler + memmap_normal_routine   - tiny_nmi_handler_routine
!ifdef SEGMENT_BASIC {
	!addr shift_mem_up_internal   = tiny_nmi_handler + shift_mem_up_routine    - tiny_nmi_handler_routine
	!addr shift_mem_down_internal = tiny_nmi_handler + shift_mem_down_routine  - tiny_nmi_handler_routine
}

} ; CONFIG_MEMORY_MODEL_60K

	; BASIC vectors
	!addr IERROR    = $300  ; $300-$301
	!addr IMAIN     = $302  ; $302-$303
	!addr ICRNCH    = $304  ; $304-$305
	!addr IQPLOP    = $306  ; $306-$307
	!addr IGONE     = $308  ; $308-$309
	!addr IEVAL     = $30A  ; $30A-$30B
	
	!addr SAREG     = $30C  ;            .A storage, for SYS call
	!addr SXREG     = $30D  ;            .X storage, for SYS call
	!addr SYREG     = $30E  ;            .Y storage, for SYS call
	!addr SPREG     = $30F  ;            .P storage, for SYS call

	!addr USRPOK    = $310  ;            -- NOT IMPLEMENTED -- JMP instruction
	!addr USRADD    = $311  ; $311-$312  -- NOT IMPLEMENTED --
	;                 $313                -- UNUSED --          free for user software
	
	; Kernal vectors - interrupts
	!addr CINV      = $314  ; $314-$315
	!addr CBINV     = $316  ; $316-$317
	!addr NMINV     = $318  ; $318-$319
	
	; Kernal vectors - routines
	!addr IOPEN     = $31A  ; $31A-$31B
	!addr ICLOSE    = $31C  ; $31C-$31D
	!addr ICHKIN    = $31E  ; $31E-$31F
	!addr ICKOUT    = $320  ; $320-$321
	!addr ICLRCH    = $322  ; $322-$323
	!addr IBASIN    = $324  ; $324-$325
	!addr IBSOUT    = $326  ; $326-$327
	!addr ISTOP     = $328  ; $328-$329
	!addr IGETIN    = $32A  ; $32A-$32B
	!addr ICLALL    = $32C  ; $32C-$32D
	!addr USRCMD    = $32E  ; $32E-$32F
	!addr ILOAD     = $330  ; $330-$331
	!addr ISAVE     = $332  ; $332-$333

	;                 $314     $334-$33B  -- UNUSED --          free for user software
	
!ifndef CONFIG_RS232_UP9600 {
	!addr TBUFFR    = $33C  ; $33C-$3FB  [!] tape buffer, our usage details differ
} else {
    !addr REVTAB    = $37C  ; $37C-$3FB  -- WIP -- [!] RS-232 precalculated data
}

	;                 $3FC     $3FC-$3FF  -- UNUSED --          free for user software


;
; Definitions for extended IEC functionality
;

	!set IEC_NORMAL  = 0 ; has to be 0, always!
!ifdef CONFIG_IEC_JIFFYDOS {
	!set IEC_JIFFY   = 1 ; has to be 1, always!
}
!ifdef CONFIG_IEC_DOLPHINDOS {
	!set IEC_DOLPHIN = 2
}
!ifdef HAS_IEC_BURST {
	!set IEC_BURST   = 3
}
!ifdef CONFIG_MB_M65 {
	!set IEC_CBDOS   = 4
}


;
; Definitions for tape functionality
;

!ifdef HAS_TAPE {

!ifdef HAS_TAPE_AUTOCALIBRATE {

	!addr __normal_time_S             = IRQTMP+0          ; duration of the short pulse
	!addr __normal_time_M             = IRQTMP+1          ; duration of the medium pulse

	!addr __turbo_half_S              = IRQTMP+0          ; half-duration of the short pulse
	!addr __turbo_half_L              = IRQTMP+1          ; half-duration of the long pulse
}

	!addr __pulse_threshold           = SVXT              ; pulse classification threshold
	!addr __pulse_threshold_ML        = SYNO              ; M/L pulse classification threshold, for normal only
}

!ifdef CONFIG_TAPE_TURBO {

	!addr __tape_turbo_bytestore      = STACK             ; location of byte storage helper routine
}
