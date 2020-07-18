// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// Table to TI$ special variable support
//

table_TI_mid:

	.byte $EE                // 10 hours    = 3600000 ticks
	.byte $7E                // 1 hour      =  360000 ticks
	.byte $75                // 10 minutes  =   30000 ticks
	.byte $0B                // 1 minute    =    3000 ticks
	.byte $01                // 10 seconds  =     500 ticks	
	.byte $00                // 1 second    =      50 ticks
