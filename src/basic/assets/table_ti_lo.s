// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// Table to TI$ special variable support
//

table_TI_lo:

	.byte $80                // 10 hours    = 3600000 ticks
	.byte $40                // 1 hour      =  360000 ticks
	.byte $30                // 10 minutes  =   30000 ticks
	.byte $B8                // 1 minute    =    3000 ticks
	.byte $F4                // 10 seconds  =     500 ticks
	.byte $32                // 1 second    =      50 ticks
