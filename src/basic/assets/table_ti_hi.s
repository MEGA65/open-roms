// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// Table to TI$ special variable support
//

table_TI_hi:

#if !CONFIG_RS232_UP9600

	.byte $20                // 10 hours    = 2169000 ticks
	.byte $03                // 1 hour      =  216000 ticks
	.byte $00                // 10 minutes  =   36000 ticks
	.byte $00                // 1 minute    =    3600 ticks
	.byte $00                // 10 seconds  =     600 ticks
	.byte $00                // 1 second    =      60 ticks

#else

	.byte $23                // 10 hours    = 2304000 ticks
	.byte $03                // 1 hour      =  230400 ticks
	.byte $00                // 10 minutes  =   38400 ticks
	.byte $00                // 1 minute    =    3840 ticks
	.byte $00                // 10 seconds  =     640 ticks
	.byte $00                // 1 second    =      64 ticks

#endif