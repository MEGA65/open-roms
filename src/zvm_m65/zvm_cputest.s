
;
; Z80 Virtual Machine CPU test
;


ZVM_cputest:

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
	bcc @end

	; Try to find the file

	lda #$34
	sta HTRAP00
	+nop
	bcc @end

	jsr PRIMM
	!pet "Loading 'Z80TEST.COM'... ", 0

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

	; Read sectors

@loop2:

	lda #$1A
	sta HTRAP00
	+nop

	; .X (low byte) and .Y (high byte) contain number of bytes read

	; XXX copy data from buffer at $FFD6E00



	; XXX finish the implementation


@end:

	rts






ZVM_filename_Z80TEST:

	!pet "z80test.com", 0
