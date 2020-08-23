// #LAYOUT# M65 KERNAL_0 #TAKE
// #LAYOUT# *   *        #IGNORE

//
// MEGA65 pseudo-IEC internal DOS support
//


.label VDOS_INIT    = $4000 +  0 * 2
.label VDOS_CHKUNIT = $4000 +  1 * 2
.label VDOS_SETUNIT = $4000 +  2 * 2
.label VDOS_ACPTR   = $4000 +  3 * 2
.label VDOS_CIOUT   = $4000 +  4 * 2
.label VDOS_LISTEN  = $4000 +  5 * 2
.label VDOS_SECOND  = $4000 +  6 * 2
.label VDOS_TALK    = $4000 +  7 * 2
.label VDOS_TKSA    = $4000 +  8 * 2
.label VDOS_UNTLK   = $4000 +  9 * 2
.label VDOS_UNLSN   = $4000 + 10 * 2


m65dos_init:

	// Initializes the DOS internal variables

	jsr map_DOS_1
	jsr_ind VDOS_INIT
	jmp_8 !+

m65dos_chkunit:                        // XXX expose to BASIC

	// Checks is the unit number is supported by the internal DOS
	// Input:  .A - unit number to check
	// Output: Carry set if not supported, otherwise .A contains unit type (0 = SD card, 1 = internal floppy, 2 = RAM disk)

	jsr map_DOS_1
	jsr_ind VDOS_CHKUNIT
	jmp_8 !+

m65dos_setunit:                        // XXX expose to BASIC

	// Set the unit number
	// Input:  .A - unit number, .X - unit type (as in m65dos_chkunit)
	// Output: Carry set means error

	jsr map_DOS_1
	jsr_ind VDOS_SETUNIT
	jmp_8 !+

m65dos_acptr:

	jsr map_DOS_1
	jsr_ind VDOS_ACPTR
!:
	jmp map_NORMAL_from_DOS_1          // ACPTR is slightly faster

m65dos_ciout:

	jsr map_DOS_1
	jsr_ind VDOS_CIOUT
!:
	jmp map_NORMAL_from_DOS_1          // CIOUT is slightly faster

m65dos_listen:

	jsr map_DOS_1
	jsr_ind VDOS_LISTEN
	jmp_8 !-

m65dos_second:

	jsr map_DOS_1
	jsr_ind VDOS_SECOND
	jmp_8 !-

m65dos_talk:

	jsr map_DOS_1
	jsr_ind VDOS_TALK
	jmp_8 !-

m65dos_tksa:

	jsr map_DOS_1
	jsr_ind VDOS_TKSA
	jmp_8 !-

m65dos_untlk:

	jsr map_DOS_1
	jsr_ind VDOS_UNTLK
	jmp_8 !-

m65dos_unlsn:

	jsr map_DOS_1
	jsr_ind VDOS_UNLSN
	jmp_8 !-
