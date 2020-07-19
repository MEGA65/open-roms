// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// Table to TI$ special variable support
//

table_TI_lo:

	.byte $80                // 10 hours    = 2169000 ticks
	.byte $C0                // 1 hour      =  216000 ticks
	.byte $A0                // 10 minutes  =   36000 ticks
	.byte $10                // 1 minute    =    3600 ticks
	.byte $58                // 10 seconds  =     600 ticks
	.byte $3C                // 1 second    =      60 ticks
