
;
; Z80 Virtual Machine BIOS for CP/M
;


; Virtual BIOS memory map

; $FE00 - $FE63 - jumptable, 3*33 bytes
; $FE63 - $FE84 - magic HALT instructions to select BIOS routines
; $FE85 - $FFFF - unassigned as of yet

!addr zvm_BIOS_return = Z80_instr_C9 ; RET instruction


zvm_BIOS_vectable:

	!word zvm_BIOS_00_BOOT
	!word zvm_BIOS_01_WBOOT
	!word zvm_BIOS_02_CONST
	!word zvm_BIOS_03_CONIN
	!word zvm_BIOS_04_CONOUT
	!word zvm_BIOS_05_LIST
	!word zvm_BIOS_06_AUXOUT
	!word zvm_BIOS_07_AUXIN
	!word zvm_BIOS_08_HOME
	!word zvm_BIOS_09_SELDSK
	!word zvm_BIOS_10_SETTRK
	!word zvm_BIOS_11_SETSEC
	!word zvm_BIOS_12_SETDMA
	!word zvm_BIOS_13_READ
	!word zvm_BIOS_14_WRITE
	!word zvm_BIOS_15_LISTST
	!word zvm_BIOS_16_SECTRN
	!word zvm_BIOS_17_CONOST
	!word zvm_BIOS_18_AUXIST
	!word zvm_BIOS_19_AUXOST
	!word zvm_BIOS_20_DEVTBL
	!word zvm_BIOS_21_DEVINI
	!word zvm_BIOS_22_DRVTBL
	!word zvm_BIOS_23_MULTIO
	!word zvm_BIOS_24_FLUSH
	!word zvm_BIOS_25_MOVE
	!word zvm_BIOS_26_TIME
	!word zvm_BIOS_27_SELMEM
	!word zvm_BIOS_28_SETBNK
	!word zvm_BIOS_29_XMOVE
	!word zvm_BIOS_30_USERF
	!word zvm_BIOS_31_RESERV1
	!word zvm_BIOS_32_RESERV2

zvm_BIOS_00_BOOT:            ; Cold start

	; XXX !!!

	; FALLTROUGH

zvm_BIOS_01_WBOOT:           ; Warm start
zvm_BIOS_31_RESERV1:         ; Reserved   
zvm_BIOS_32_RESERV2:         ; Reserved

	; Reset BIOS vectors to point to bank 1

	; XXX setup VEC_MOVE_fetch, VEC_MOVE_store, VEC_DISKIO_store

	; XXX !!!

zvm_BIOS_02_CONST:           ; Check if input character available

	; XXX !!!

zvm_BIOS_03_CONIN:           ; Console input

	; XXX !!!

zvm_BIOS_04_CONOUT:          ; Console output

	; XXX

zvm_BIOS_05_LIST:            ; Provide list of character output devices

	; XXX

zvm_BIOS_06_AUXOUT:          ; AUX output

	; XXX

zvm_BIOS_07_AUXIN:           ; AUX input

	; XXX

zvm_BIOS_08_HOME:            ; Go to track 0

	; XXX !!!

zvm_BIOS_09_SELDSK:          ; Select drive

	; XXX !!!

zvm_BIOS_10_SETTRK:          ; Set track number

	; XXX !!!

zvm_BIOS_11_SETSEC:          ; Set sector number

	; XXX !!!

zvm_BIOS_12_SETDMA:          ; Set DMA address

	; XXX !!!

zvm_BIOS_13_READ:            ; Read sector

	; XXX !!!

zvm_BIOS_14_WRITE:           ; Write sector

	; XXX !!!

zvm_BIOS_15_LISTST:          ; List status
zvm_BIOS_17_CONOST:          ; Console output status

	; Always report the printer / output console as ready
	lda #$FF
	sta REG_A
	jmp zvm_BIOS_return

zvm_BIOS_16_SECTRN:          ; Convert logical to physical sector

	; XXX !!!

zvm_BIOS_18_AUXIST:          ; AUX input status

	; XXX

zvm_BIOS_19_AUXOST:          ; AUX output status

	; XXX

zvm_BIOS_20_DEVTBL:          ; Character device table address

	; XXX

zvm_BIOS_21_DEVINI:          ; Initialize character device

	; XXX

zvm_BIOS_22_DRVTBL:          ; Disk drive table address

	; XXX

zvm_BIOS_23_MULTIO:          ; Set number of logically consecutive sectors

	; XXX !!!

zvm_BIOS_24_FLUSH:           ; Force buffer flushing for user deblocking

	; XXX !!!

zvm_BIOS_25_MOVE:            ; Memory move

	lda REG_B
	ora REG_C
	beq @2                   ; branch if nothing to be copied
@1:
	jsr (VEC_MOVE_fetch)
	jsr (VEC_MOVE_store)
	inw REG_DE ; source address
	inw REG_HL ; destination address
	dew REG_BC ; count
	bne @1
@2:
    ; XXX setup VEC_MOVE_fetch (to bank 1), VEC_MOVE_store (to bank 1)
    jmp zvm_BIOS_return

zvm_BIOS_26_TIME:            ; Get or set time

	; XXX !!!

zvm_BIOS_27_SELMEM:          ; Select memory bank

	; XXX !!!
    ; XXX setup VEC_MOVE_fetch (REG_A), VEC_MOVE_store (REG_A)

zvm_BIOS_28_SETBNK:          ; Set bank for disk DMA operation

	; XXX !!!
    ; XXX setup VEC_DISKIO_store (REG_A)

zvm_BIOS_29_XMOVE:           ; Set bank if buffer is in bank other than 1 or 2

	; XXX !!!
    ; XXX setup VEC_MOVE_fetch (REG_C), VEC_MOVE_store (REG_B)

zvm_BIOS_30_USERF:           ; Implementation-specific functionality

	; XXX implement function to save RAM DISK back to SD CARD
