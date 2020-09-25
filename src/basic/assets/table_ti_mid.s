;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

;
; Table to TI$ special variable support
;

table_TI_mid:

!ifndef CONFIG_RS232_UP9600 {

	!byte $F5                ; 10 hours    = 2169000 ticks
	!byte $4B                ; 1 hour      =  216000 ticks
	!byte $8C                ; 10 minutes  =   36000 ticks
	!byte $0E                ; 1 minute    =    3600 ticks
	!byte $02                ; 10 seconds  =     600 ticks
	!byte $00                ; 1 second    =      60 ticks

} else {

	!byte $28                ; 10 hours    = 2304000 ticks
	!byte $84                ; 1 hour      =  230400 ticks
	!byte $96                ; 10 minutes  =   38400 ticks
	!byte $0F                ; 1 minute    =    3840 ticks
	!byte $02                ; 10 seconds  =     640 ticks
	!byte $00                ; 1 second    =      64 ticks

}
