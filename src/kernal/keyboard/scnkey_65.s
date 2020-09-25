;; #LAYOUT# STD *        #TAKE
;; #LAYOUT# X16 *        #IGNORE
;; #LAYOUT# *   KERNAL_0 #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; Keyboard scanning routine extension for C65 keyboards
;
; - [CM128] Computes Mapping the Commodore 128 - pages 212 (SHFLAG)
; - https://github.com/MEGA65/c65-specifications/blob/master/c65manualupdated.txt (matrix)
;


!ifdef CONFIG_KEYBOARD_C65 { !ifndef CONFIG_LEGACY_SCNKEY {


; Inlining this within SCNKEY would both overcomplicate the implementation
; and disrupt a lot of branches (they would cross the 127 bytes distance limit)

; .Y is now $FF - try to put there a key code from extended keyboard

scnkey_65:

	sty CIA1_PRA                       ; disconnect classic keys

	lda #$00
	sta C65_EXTKEYS_PR                 ; connect C65 keys

	lda #%00000101                     ; filter out bucky keys: ALT, NO_SCRL
	ora CIA1_PRB

	cmp #$FF
	beq scnkey_65_done                 ; skip if no key pressed from this row

	; At least one key is pressed - decode it
	ldy #$07
scnkey_matrix_65_loop:
	cmp kb_matrix_row_keys, y
	bne @1                             ; not this particular key
	tya                                ; now .A contains key offset within a row
	clc
	adc kb_matrix_row_offsets, x       ; now .A contains key offset from the matrix start
	adc #$41                           ; now .A contains offset after the standard matrix
	tay
	jmp scnkey_65_done
@1:
	dey
	bpl scnkey_matrix_65_loop

	; FALLTROUGH, multiple keys must have been pressed

scnkey_65_no_keys:

	pla                                ; get rid of return address from the stack
	pla

	jmp scnkey_no_keys                 ; pass controll to original routine


scnkey_65_done:

	ldx #$FF
	stx C65_EXTKEYS_PR                 ; connect C65 keys

	rts


} } ; CONFIG_KEYBOARD_C65 and no CONFIG_LEGACY_SCNKEY
