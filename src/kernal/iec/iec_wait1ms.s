;; #LAYOUT# STD *        #TAKE
;; #LAYOUT# X16 *        #IGNORE
;; #LAYOUT# *   KERNAL_0 #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; Wait 1 ms (1000 usec)
;
; On NTSC this means 1023 cycles (slightly less on PAL, but we have to be sure).
; We cant count on badlines, as the screen might be disabled.
; Delay here is implemented using VIC-II raster register. Since one raster is
; 63 cycles, we need at least 17 full rasters to be 100% sure we wait enough


!ifdef CONFIG_IEC {


iec_wait1ms:

	ldx #18 ; we probably won't start with the beginning of raster

} ; CONFIG_IEC

	; FALLTROUGH

wait_x_bars: ; additional entry point for delay in screen and tape support
             ; has to preserve .Y and put .X to 0

	lda VIC_RASTER
@1:
	cmp VIC_RASTER
	beq @1
	lda VIC_RASTER
	dex
	bne @1

	; Alternative implementation, using CIA#1 timer B

;	lda #%00001000      ; stop timer B, load latch once
;	sta CIA1_CRB

;	lda #$40
;	sta CIA1_TIMBLO     ; timer B - low byte
;	stx CIA1_TIMBHI     ; timer B - high byte

;	lda #%00001001      ; start timer B, load latch once
;	sta CIA1_CRB
;@1:
;	lda CIA1_ICR
;	and #%00000010
;	beq @1

	; FALLTROUGH

iec_wait_rts: ; dummy RTS, for very short waits

	rts
