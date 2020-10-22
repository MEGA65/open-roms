;; #LAYOUT# STD *        #TAKE
;; #LAYOUT# CRT KERNAL_1 #TAKE
;; #LAYOUT# M65 KERNAL_1 #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; Tape (turbo) helper routine - bit reading
;

; Based on routine by enthusi/Onslaught, found here:
; - https://codebase64.pokefinder.org/doku.php?id=base:turbotape_loader_source


!ifdef CONFIG_TAPE_TURBO {


tape_turbo_get_bit:
	
	jsr tape_common_get_pulse
	bcs @1

	clc
	ror
	sta __turbo_half_S                 ; store half of the last measurement result for short pulse

	lda #$01
!ifdef CONFIG_MB_M65 {
	sta SID_SIGVOL + __SID_R1_OFFSET
	sta SID_SIGVOL + __SID_L1_OFFSET
} else {
	sta SID_SIGVOL
}
	lda #$06
	sta VIC_EXTCOL
	sec
	rts
@1:
	clc
	ror
	sta __turbo_half_L                 ; store half of the last measurement result for long pulse

	lda #$00
!ifdef CONFIG_MB_M65 {
	sta SID_SIGVOL + __SID_R1_OFFSET
	sta SID_SIGVOL + __SID_L1_OFFSET
} else {
	sta SID_SIGVOL
}
	sta VIC_EXTCOL
	clc
	rts


} ; CONFIG_TAPE_TURBO
