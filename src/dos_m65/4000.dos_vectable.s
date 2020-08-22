
// A vector table to integrate DOS with the MEGA65 Kernal

.word dos_INIT
.word dos_HASUNIT
.word dos_ACPTR
.word dos_CIOUT
.word dos_LISTEN
.word dos_SECOND
.word dos_TALK
.word dos_TKSA
.word dos_UNTLK
.word dos_UNLSN


// Dummy implementations - XXX to be replaced with real ones

dos_INIT:
	nop
dos_HASUNIT:
	nop
dos_ACPTR:
	nop
dos_CIOUT:
	nop
dos_LISTEN:
	nop
dos_SECOND:
	nop
dos_TALK:
	nop
dos_TKSA:
	nop
dos_UNTLK:
	nop
dos_UNLSN:
	nop

	sec
	rts
