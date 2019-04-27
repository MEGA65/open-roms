	;; Clear screen etc, show READY prompt.

basic_warm_start:
	jsr install_ram_routines
	
	jmp basic_main_loop
	
