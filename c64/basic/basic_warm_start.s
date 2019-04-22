	;; Clear screen etc, show READY prompt.

basic_warm_start:
	* 	inc $d020
	jmp -
	
