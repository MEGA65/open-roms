;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# X16 BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

;
; Startup banner, to be displayed during cold start
;


!macro  BANNER_TEXT {

!ifdef CONFIG_BRAND_CUSTOM {
	!pet "open roms "
	+CONFIG_BRAND_CUSTOM
} else ifdef CONFIG_BRAND_GENERIC {
	!pet "open roms generic build"
} else ifdef CONFIG_BRAND_TESTING {
	!pet "open roms testing build"
} else ifdef CONFIG_MB_U64 {
	!pet "open roms for ultimate 64"
}

}

startup_banner:

!ifdef CONFIG_BANNER_SIMPLE {

	!pet "    " 
	+BANNER_TEXT
	!byte $00

} else ifdef CONFIG_BANNER_FANCY {

	+BANNER_TEXT
	!byte $00

rainbow_logo:

	!set SET_COLOR_0 = $05
	!set SET_COLOR_1 = $1C
	!set SET_COLOR_2 = $81
	!set SET_COLOR_3 = $9E
	!set SET_COLOR_4 = $1E
	!set SET_COLOR_5 = $9F

!ifdef CONFIG_MB_U64 {

	!byte SET_COLOR_1, $B8, $B8, $B8, $B8, $B8, $B8, $0D
    !byte SET_COLOR_2, $B8, $B8, $B8, $B8, $B8, $B8, $0D
    !byte SET_COLOR_3, $B8, $B8, $B8, $B8, $B8, $B8, $0D
    !byte SET_COLOR_4, $B8, $B8, $B8, $B8, $B8, $B8, $0D
    !byte SET_COLOR_5, $B8, $B8, $B8, $B8, $B8, $B8, $0D
    !byte SET_COLOR_0, $00

    !set BANNER_SPACING = $09

} else {

	!byte SET_COLOR_1, $12, $A4, $A4, $A4, $A4, $A4, $A4, $A4, $0D
    !byte SET_COLOR_3, $12, $A4, $A4, $A4, $A4, $A4, $A4, $0D
    !byte SET_COLOR_4, $12, $A4, $A4, $A4, $A4, $A4, $0D
    !byte SET_COLOR_5, $12, $A4, $A4, $A4, $A4, $92
    !byte SET_COLOR_0, $00

    !set BANNER_SPACING = $0A
}

}
