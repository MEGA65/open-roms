;; #IMPORT# KERNAL_0 = KERNAL_0_combined.sym
;; #IMPORT# BASIC_0  = BASIC_0_combined.sym

;
; Definitions for calling MEGA65 segment KERNAL_0 routines from MON_1
;

;; #ALIAS# SETMSG                      = KERNAL_0.SETMSG
;; #ALIAS# STOP                        = KERNAL_0.STOP
;; #ALIAS# SCREEN                      = KERNAL_0.SCREEN

;; #ALIAS# monitor_exit                = KERNAL_0.m65_shadow_BZP
;; #ALIAS# monitor_memread_helper      = KERNAL_0.proxy_M1_memread
;; #ALIAS# monitor_memwrite_helper     = KERNAL_0.proxy_M1_memwrite

;; #ALIAS# CHRIN                       = KERNAL_0.proxy_M1_CHRIN
;; #ALIAS# CHROUT                      = KERNAL_0.proxy_M1_CHROUT

;; #ALIAS# wedge_dos_monitor           = BASIC_0.wedge_dos_monitor


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
