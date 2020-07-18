// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// Table to TI$ special variable support
//

table_TI_hi:

	.byte $36                // 10 hours    = 3600000 ticks
	.byte $05                // 1 hour      =  360000 ticks
	.byte $00                // 10 minutes  =   30000 ticks
	.byte $00                // 1 minute    =    3000 ticks
	.byte $00                // 10 seconds  =     500 ticks
	.byte $00                // 1 second    =      50 ticks
