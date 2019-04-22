	;; Clear screen etc, show READY prompt.

basic_warm_start:
	jsr ready_message
	jmp basic_main_loop
	
