;; #LAYOUT# M65 KERNAL_0 #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; MEGA65 pseudo-IEC internal DOS support
;


!addr VDOS_INIT    = $4020 +  0 * 2
!addr VDOS_UNITCHK = $4020 +  1 * 2
!addr VDOS_UNITSET = $4020 +  2 * 2
!addr VDOS_UNITNUM = $4020 +  3 * 2
!addr VDOS_ACPTR   = $4020 +  4 * 2
!addr VDOS_CIOUT   = $4020 +  5 * 2
!addr VDOS_LISTEN  = $4020 +  6 * 2
!addr VDOS_SECOND  = $4020 +  7 * 2
!addr VDOS_TALK    = $4020 +  8 * 2
!addr VDOS_TKSA    = $4020 +  9 * 2
!addr VDOS_UNTLK   = $4020 + 10 * 2
!addr VDOS_UNLSN   = $4020 + 11 * 2


m65dos_init:

	; Initializes the DOS internal variables

	jsr map_DOS_1
	jsr (VDOS_INIT)
	bra m65dos_end_1

m65dos_unitchk:                        ; XXX expose to BASIC

	; Checks is the unit number is supported by the internal DOS
	; Input:  .A - unit number to check
	; Output: Carry set if not supported, otherwise .A contains unit type (0 = SD card, 1 = internal floppy, 2 = RAM disk)

	jsr map_DOS_1
	jsr (VDOS_UNITCHK)
	bra m65dos_end_1

m65dos_unitset:                        ; XXX expose to BASIC

	; Set the unit number
	; Input:  .X - unit number, .A - unit type (as in m65dos_chkunit)
	; Output: Carry set means error

	jsr map_DOS_1
	jsr (VDOS_UNITSET)
	bra m65dos_end_1

m65dos_unitnum:                        ; XXX expose to BASIC

	; Set the unit number
	; Input:  .A - unit type (as in m65dos_chkunit)
	; Output: .A - unit number, Carry set means error

	jsr map_DOS_1
	jsr (VDOS_UNITNUM)
	bra m65dos_end_1

m65dos_acptr:

	jsr map_DOS_1
	jsr (VDOS_ACPTR)

	; FALLTROUGH

m65dos_end_1:

	jmp map_NORMAL                    ; ACPTR is slightly faster

m65dos_ciout:

	jsr map_DOS_1
	jsr (VDOS_CIOUT)

	; FALLTROUGH

m65dos_end_2:

	jmp map_NORMAL                    ; CIOUT is slightly faster

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
