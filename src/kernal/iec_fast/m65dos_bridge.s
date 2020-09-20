;; #LAYOUT# M65 KERNAL_0 #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; MEGA65 pseudo-IEC internal DOS support
;


!addr VDOS_INIT    = $4000 +  0 * 2
!addr VDOS_CHKUNIT = $4000 +  1 * 2
!addr VDOS_SETUNIT = $4000 +  2 * 2
!addr VDOS_ACPTR   = $4000 +  3 * 2
!addr VDOS_CIOUT   = $4000 +  4 * 2
!addr VDOS_LISTEN  = $4000 +  5 * 2
!addr VDOS_SECOND  = $4000 +  6 * 2
!addr VDOS_TALK    = $4000 +  7 * 2
!addr VDOS_TKSA    = $4000 +  8 * 2
!addr VDOS_UNTLK   = $4000 +  9 * 2
!addr VDOS_UNLSN   = $4000 + 10 * 2


m65dos_init:

	; Initializes the DOS internal variables

	jsr map_DOS_1
	jsr (VDOS_INIT)
	bra m65dos_end_1

m65dos_chkunit:                        ; XXX expose to BASIC

	; Checks is the unit number is supported by the internal DOS
	; Input:  .A - unit number to check
	; Output: Carry set if not supported, otherwise .A contains unit type (0 = SD card, 1 = internal floppy, 2 = RAM disk)

	jsr map_DOS_1
	jsr (VDOS_CHKUNIT)
	bra m65dos_end_1

m65dos_setunit:                        ; XXX expose to BASIC

	; Set the unit number
	; Input:  .A - unit number, .X - unit type (as in m65dos_chkunit)
	; Output: Carry set means error

	jsr map_DOS_1
	jsr (VDOS_SETUNIT)
	bra m65dos_end_1

m65dos_acptr:

	jsr map_DOS_1
	jsr (VDOS_ACPTR)

	; FALLTROUGH

m65dos_end_1:

	jmp map_NORMAL_from_DOS_1          ; ACPTR is slightly faster

m65dos_ciout:

	jsr map_DOS_1
	jsr (VDOS_CIOUT)

	; FALLTROUGH

m65dos_end_2:

	jmp map_NORMAL_from_DOS_1          ; CIOUT is slightly faster

m65dos_listen:

	jsr map_DOS_1
	jsr (VDOS_LISTEN)
	bra m65dos_end_2

m65dos_second:

	jsr map_DOS_1
	jsr (VDOS_SECOND)
	bra m65dos_end_2

m65dos_talk:

	jsr map_DOS_1
	jsr (VDOS_TALK)
	bra m65dos_end_2

m65dos_tksa:

	jsr map_DOS_1
	jsr (VDOS_TKSA)
	bra m65dos_end_2

m65dos_untlk:

	jsr map_DOS_1
	jsr (VDOS_UNTLK)
	bra m65dos_end_2

m65dos_unlsn:

	jsr map_DOS_1
	jsr (VDOS_UNLSN)
	bra m65dos_end_2
