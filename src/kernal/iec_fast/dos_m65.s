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

// XXX implement support
