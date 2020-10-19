;; #LAYOUT# STD *        #TAKE
;; #LAYOUT# CRT KERNAL_0 #TAKE
;; #LAYOUT# M65 KERNAL_1 #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; Tape (turbo) helper routine - synchronization handling
;

; Based on routine by enthusi/Onslaught, found here:
; - https://codebase64.pokefinder.org/doku.php?id=base:turbotape_loader_source


!ifdef CONFIG_TAPE_TURBO {


tape_turbo_sync_header:

	; Initial pulse threshold
	lda #$BF                           ; measured 128 bits '0' and 128 bits '1' under VICE, calculated average
	sta __pulse_threshold

	; Synchronize with start of sync sequence
	jsr tape_turbo_sync_first
!ifdef CONFIG_TAPE_AUTODETECT {
	bcs tape_turbo_sync_done
}

	; Perform synchronization, double loop, total $C0 * $04 iterations
	ldx #$C0
@1:
	ldy #$04
@2:
	stx XSAV
	jsr tape_turbo_get_byte
	cmp #$02
	bne tape_turbo_sync_header         ; branch if failure

	dey
	bne @2
	ldx XSAV
	dex
	bne @1

	; FALLTROUGH

tape_turbo_sync_payload:

	jsr tape_turbo_sync_first
!ifdef CONFIG_TAPE_AUTODETECT {
	bcs tape_turbo_sync_done           ; this shopuld not happen
}
	ldx #$09                           ; 9, 8, ...
@3:
 	jsr tape_turbo_get_byte
 	cmp #$02
 	beq @3
 	ldy #$00
@4: 
	cpx INBIT
	bne tape_turbo_sync_payload
	jsr tape_turbo_get_byte
	dex
	bne @4

!ifdef CONFIG_TAPE_AUTODETECT {
	clc
}

	; FALLTROUGH

tape_turbo_sync_done:

	rts


} ; CONFIG_TAPE_TURBO
