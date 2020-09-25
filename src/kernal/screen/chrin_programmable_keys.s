;; #LAYOUT# STD *        #TAKE
;; #LAYOUT# X16 *        #IGNORE
;; #LAYOUT# *   KERNAL_0 #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; Keyboard part of the CHRIN routine - programmable keys support
; Output: if Carry clear, programmable key was handled
;


!ifdef CONFIG_PROGRAMMABLE_KEYS {

chrin_programmable_keys:

	; Check if the key is programmable

	ldx #(__programmable_keys_codes_end - programmable_keys_codes - 1)
@1:
	cmp programmable_keys_codes, x
	beq @2
	dex
	bpl @1

	; This is not a programmable key

	sec
	rts
@2:
	; .X contains index of the key code, we need offset to key string instead

	lda programmable_keys_offsets, x
	tax

	; Print all the characters assigned to key
@3:
	lda programmable_keys_strings, x
	beq @4
	jsr CHROUT ; our implementation preserves .X too
	inx
	bne @3     ; jumps always
@4:
	clc
	rts

} ; CONFIG_PROGRAMMABLE_KEYS
