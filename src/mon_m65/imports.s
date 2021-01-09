;; #IMPORT# KERNAL_0 = KERNAL_0_combined.sym

;
; Definitions for calling MEGA65 segment KERNAL_0 routines from MON_1
;

;; #ALIAS# SETMSG                      = KERNAL_0.SETMSG
;; #ALIAS# STOP                        = KERNAL_0.STOP
;; #ALIAS# SCREEN                      = KERNAL_0.SCREEN

;; #ALIAS# monitor_exit                = KERNAL_0.m65_shadow_BZP
;; #ALIAS# monitor_memread_helper      = KERNAL_0.proxy_M1_memread

;; #ALIAS# CHRIN                       = KERNAL_0.proxy_M1_CHRIN
;; #ALIAS# CHROUT                      = KERNAL_0.proxy_M1_CHROUT
;; #ALIAS# SECOND                      = KERNAL_0.proxy_M1_SECOND
;; #ALIAS# TKSA                        = KERNAL_0.proxy_M1_TKSA
;; #ALIAS# ACPTR                       = KERNAL_0.proxy_M1_ACPTR
;; #ALIAS# CIOUT                       = KERNAL_0.proxy_M1_CIOUT
;; #ALIAS# UNTLK                       = KERNAL_0.proxy_M1_UNTLK
;; #ALIAS# UNLSN                       = KERNAL_0.proxy_M1_UNLSN
;; #ALIAS# LISTEN                      = KERNAL_0.proxy_M1_LISTEN
;; #ALIAS# TALK                        = KERNAL_0.proxy_M1_TALK


; 'Print immediate', original implementation by Mike Barry, adapted to 65CE02, modified to preserve .Y
; see http://www.6502.org/source/io/primm.htm

PRIMM:

	pla            ; get low part of (string address-1)
	sta PTR1
	pla            ; get high part of (string address-1)
	sta PTR2
	phy
	+bra @2
@1:
	jsr CHROUT     ; output a string char
@2:
	inc PTR1       ; advance the string pointer
	bne @3
    inc PTR2
@3:
	ldy #$00
	lda (PTR1), y  ; get string char
	bne @1         ; output and continue if not NUL
	ply
	lda PTR2
	pha
	lda PTR1
	pha

	rts
