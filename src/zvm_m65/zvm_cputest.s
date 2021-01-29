
;
; Z80 Virtual Machine CPU test
;


ZVM_cputest:

	; XXX move loading code to separate routine(s)

	; Copy file name to RAM

	ldx #$FF

@loop1:

	inx
	lda ZVM_filename_Z80TEST, x
	sta BUF, x
	bne @loop1

	; Set Z80TEST.COM file name

	ldy #>BUF
	ldx #<BUF
	lda #$2E                           ; dos_setname
	sta HTRAP00
	+nop                               ; required by hypervisor
	+bcc @end

	; Try to find the file

	lda #$34
	sta HTRAP00
	+nop
	+bcc @end

	jsr PRIMM
	!pet "Loading Z80TEST.COM", 0

	; Open the file

	lda #$00
	sta HTRAP00
	+nop
	
	lda #$18
	sta HTRAP00
	+nop

	; Select SD card buffer

	lda #$80
	tsb $D689 ; XXX invent name for the register

	; Prepare pointers

	lda #$FF
	sta BIOS_IOBUFERPTR+3
	lda #$D6
	sta BIOS_IOBUFERPTR+2

	lda #$FF
	sta BIOS_IOBUFERPTR+3
	lda #$D6
	sta BIOS_IOBUFERPTR+2

	lda #$00
	sta BIOS_LOADPTR+3
	lda #$05
	sta BIOS_LOADPTR+2
	lda #$01
	sta BIOS_LOADPTR+1
	lda #$00
	sta BIOS_LOADPTR+1

!addr BIOS_LOADCOUNT         = $48               ; 2 bytes - counter used for loading data


	; Read sectors

@loop2:

	; Set I/O buffer pointer to start

	lda #$6E
	sta BIOS_IOBUFERPTR+1
	lda #$00
	sta BIOS_IOBUFERPTR+0

	; Read up to 512 bytes

	lda #$1A
	sta HTRAP00
	+nop

	; Copy data from buffer to memory

	stx BIOS_LOADCOUNT+0
	sty BIOS_LOADCOUNT+1

	tya
	ora BIOS_LOADCOUNT+0
	beq @load_done

@loop3:

	dew BIOS_LOADCOUNT
	bmi @loop2

	lda [BIOS_IOBUFERPTR],z
	sta [BIOS_LOADPTR],z

	inw BIOS_IOBUFERPTR
	inw BIOS_LOADPTR

	bra @loop3

@load_done:

	; Close the file

	lda #$20
	sta HTRAP00
	+nop

	jsr PRIMM
	!pet "      done", $0D, $0D, 0

	; At this moment we have Z80TEST.COM loaded into memory
	; Install a virtual CP/M, set PC to $0100, and run it!

	lda #$01
	sta REG_PC+1
	dec
	sta BIOS_LOADPTR+1
	lda #$05
	sta BIOS_LOADPTR+0
	lda #$76                           ; HALT
	sta [BIOS_LOADPTR],z
	inc BIOS_LOADPTR
	lda #$FF
	sta [BIOS_LOADPTR],z               ; $FF = CP/M simulation for CPU test

	; Run the software

	jmp ZVM_next

@end:

	rts

ZVM_filename_Z80TEST:

	!pet "z80test.com", 0
