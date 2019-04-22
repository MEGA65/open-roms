	;; BASIC Cold start entry point
	;; Compute's Mapping the 64 p211

basic_cold_start:	
	;; Setup BASIC vectors at $0300
	;; Initialise interpretor
	;; Print start up message
	;; jump into warm start loop
	jmp basic_warm_start
	
	
