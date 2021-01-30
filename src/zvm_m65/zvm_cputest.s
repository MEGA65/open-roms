
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
	lda #$2E
	sta HTRAP00
	+nop                               ; NOPs are required by hypervisor
	+bcc @end

	; Try to find the file

	lda #$34                           ; dos_findfile
	sta HTRAP00
	+nop
	+bcc @end

	jsr PRIMM
	!pet "Loading Z80TEST.COM", 0

	; Close all the files, to make sure handle is available

	lda #$22                          ; dos_closeall
	sta HTRAP00
	+nop

	; Open the file

	lda #$18                          ; dos_openfile
	sta HTRAP00
	+nop

	; Select SD card buffer

	lda #$80
	tsb $D689 ; XXX invent name for the register

	; Prepare pointers

	lda #$0F
	sta BIOS_IOBUFERPTR+3
	lda #$FD
	sta BIOS_IOBUFERPTR+2

	lda #$00                                     ; $0005:0100 - from CP/M point of view this is start of page 1 in bank 1 
	sta BIOS_LOADPTR+3
	lda #$05
	sta BIOS_LOADPTR+2
	lda #$01
	sta BIOS_LOADPTR+1
	lda #$00
	sta BIOS_LOADPTR+0

	; Read data, 512 byte chunks

	lda #$02                                     ; value means - 2*256 bytes read
	pha

	ldz #$00                                     ; in case hypervisor modified it
 
@loop2:

	pla
	cmp #$02
	bne @load_done

	; Set I/O buffer pointer to start

	lda #$6E
	sta BIOS_IOBUFERPTR+1
	lda #$00
	sta BIOS_IOBUFERPTR+0

	; Read up to 512 bytes

	lda #$1A                                     ; dos_readfile
	sta HTRAP00
	+nop

	; Copy data from buffer to memory

	stx BIOS_LOADCOUNT+0
	sty BIOS_LOADCOUNT+1

	tya
	ora BIOS_LOADCOUNT+0
	beq @load_done                               ; 0 bytes to read - loading is done

	phy                                          ; if 2 - we most likely have something more to read

	; Copy up to 512 bytes from buffer to target memory

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

	lda #$20                                     ; dos_closefile
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
	lda #$76                                     ; HALT
	sta [BIOS_LOADPTR],z
	inc BIOS_LOADPTR
	lda #$FF
	sta [BIOS_LOADPTR],z                         ; $FF = CP/M simulation for CPU test

	; Run the software

	ldz #$00                                     ; in case hypervisor modified it
	jmp ZVM_next

@end:

	ldz #$00                                     ; in case hypervisor modified it
	rts

ZVM_filename_Z80TEST:

	!pet "z80test.com", 0
