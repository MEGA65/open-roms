;; #LAYOUT# STD *        #TAKE
;; #LAYOUT# CRT KERNAL_1 #TAKE
;; #LAYOUT# M65 KERNAL_1 #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; Tape (turbo) helper routine - byte reading
;
; Returns byte in .A
;

; Based on routine by enthusi/Onslaught, found here:
; - https://codebase64.pokefinder.org/doku.php?id=base:turbotape_loader_source


!ifdef CONFIG_TAPE_TURBO {


tape_turbo_get_byte:

	+phx_trash_a
	lda #$01
	sta INBIT                          ; init the to-be-read byte with 1 (canary bit to mark loop end)
@1:
	jsr tape_turbo_get_bit	
	rol INBIT
	bcc @1	                           ; is the initial 1 shifted into carry already?
	+plx_trash_a

!ifdef HAS_TAPE_AUTOCALIBRATE {

	; Compensate for tape speed variations

	lda __turbo_half_S                 ; half of the last value for bit '0'
	clc
	adc __turbo_half_L                 ; half of the last value for bit '1'
	
	sec
	sbc __pulse_threshold              ; now we have a diff between current threshold and calculated one
	beq tape_turbo_get_byte_done       ; branch if threshold correction not needed

	bpl @2

	lda __pulse_threshold
	cmp #($BF - 10)
	beq tape_turbo_get_byte_done       ; do not decrease threshold too far no matter what

	dec __pulse_threshold
	bne tape_turbo_get_byte_done       ; branch always
@2:
	lda __pulse_threshold
	cmp #($BF + 10)
	beq tape_turbo_get_byte_done       ; do not increase threshold too far no matter what

	inc __pulse_threshold
}

tape_turbo_get_byte_done:

	lda INBIT
	rts


} ; CONFIG_TAPE_TURBO
