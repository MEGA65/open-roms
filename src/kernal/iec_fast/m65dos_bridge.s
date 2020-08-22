// #LAYOUT# M65 KERNAL_0 #TAKE
// #LAYOUT# *   *        #IGNORE

//
// MEGA65 pseudo-IEC internal DOS support
//


.label VDOS_INIT    = $4000
.label VDOS_HASUNIT = $4002
.label VDOS_ACPTR   = $4004
.label VDOS_CIOUT   = $4006
.label VDOS_LISTEN  = $4008
.label VDOS_SECOND  = $400A
.label VDOS_TALK    = $400C
.label VDOS_TKSA    = $400E
.label VDOS_UNTLK   = $4010
.label VDOS_UNLSN   = $4012


// XXX connect this to core IEC implementation


m65dos_init:

	jsr map_DOS_1
	jsr_ind VDOS_INIT
	jmp_8 !+

m65dos_hasunit:

	jsr map_DOS_1
	jsr_ind VDOS_HASUNIT
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
