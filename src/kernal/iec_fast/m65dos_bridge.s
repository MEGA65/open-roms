// #LAYOUT# M65 KERNAL_0 #TAKE
// #LAYOUT# *   *        #IGNORE

//
// MEGA65 pseudo-IEC internal DOS support
//


.label VDOS_INIT    = $4000 +  0 * 2
.label VDOS_CHKUNIT = $4000 +  1 * 2
.label VDOS_ACPTR   = $4000 +  2 * 2
.label VDOS_CIOUT   = $4000 +  3 * 2
.label VDOS_LISTEN  = $4000 +  4 * 2
.label VDOS_SECOND  = $4000 +  5 * 2
.label VDOS_TALK    = $4000 +  6 * 2
.label VDOS_TKSA    = $4000 +  7 * 2
.label VDOS_UNTLK   = $4000 +  8 * 2
.label VDOS_UNLSN   = $4000 +  9 * 2


// XXX connect this to core IEC implementation


m65dos_init:

	jsr map_DOS_1
	jsr_ind VDOS_INIT
	jmp_8 !+

m65dos_chkunit:

	jsr map_DOS_1
	jsr_ind VDOS_CHKUNIT
	jmp_8 !+

m65dos_acptr:

	jsr map_DOS_1
	jsr_ind VDOS_ACPTR
!:
	jmp map_NORMAL_from_DOS_1          // try to make ACPTR slightly faster

m65dos_ciout:

	jsr map_DOS_1
	jsr_ind VDOS_CIOUT
!:
	jmp map_NORMAL_from_DOS_1          // try to make CIOUT slightly faster

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
