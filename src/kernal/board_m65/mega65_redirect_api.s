;; #LAYOUT# M65 KERNAL_0 #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; ROM routine call redirect for MEGA65 API routines
;

M65_MODESET:

	jsr map_KERNAL_1
	jsr (VK1__M65_MODESET)
	bra m65_api_end

M65_SCRMODEGET:

	jsr map_KERNAL_1
	jsr (VK1__M65_SCRMODEGET)
	bra m65_api_end

M65_SCRMODESET:

	jsr map_KERNAL_1
	jsr (VK1__M65_SCRMODESET)
	bra m65_api_end

M65_CLRSCR:

	jsr map_KERNAL_1
	jsr (VK1__M65_CLRSCR)
	bra m65_api_end

M65_CLRWIN:

	jsr map_KERNAL_1
	jsr (VK1__M65_CLRWIN)

	; FALLTROUGH

m65_api_end:

	jmp map_NORMAL
