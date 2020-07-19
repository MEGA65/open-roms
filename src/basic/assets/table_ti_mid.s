// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// Table to TI$ special variable support
//

table_TI_mid:

	.byte $F5                // 10 hours    = 2169000 ticks
	.byte $4B                // 1 hour      =  216000 ticks
	.byte $8C                // 10 minutes  =   36000 ticks
	.byte $0E                // 1 minute    =    3600 ticks
	.byte $02                // 10 seconds  =     600 ticks
	.byte $00                // 1 second    =      60 ticks
