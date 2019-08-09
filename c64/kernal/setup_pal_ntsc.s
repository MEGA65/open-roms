
;;
;; Detect video system (PAL/NTSC), use Graham's method, as it's short and reliable
;; see here: https://codebase64.org/doku.php?id=base:detect_pal_ntsc
;;

setup_pal_ntsc:

	lda VIC_RASTER
setup_pal_ntsc_w1:
	cmp VIC_RASTER
	beq setup_pal_ntsc_w1
	bmi setup_pal_ntsc

	;; Result in A, if no interrupt happened during the test:
	;; #$37 -> 312 rasterlines, PAL,  VIC 6569
	;; #$06 -> 263 rasterlines, NTSC, VIC 6567R8
	;; #$05 -> 262 rasterlines, NTSC, VIC 6567R56A

	cmp #$07
	bcs setup_pal

setup_ntsc:
	lda #$00
	beq +

setup_pal:
	lda #$01
*
	sta PALNTSC
	rts
