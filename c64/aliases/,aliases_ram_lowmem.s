;;
;; Names of ZP and low memory locations (only the implemented ones)
;; (https://www.c64-wiki.com/wiki/Zeropage)
;;

	;; $000-$001 - 6502 CPU registers

	;; Registers for SYS call
	.alias sys_reg_a $30c
	.alias sys_reg_x $30d
	.alias sys_reg_y $30e
	.alias sys_reg_p $30f
	.alias sys_jmp   $310

	;; Kernal vectors - interrupts
	.alias CINV      $0314
	.alias CBINV     $0316 
	.alias NMINV     $0318
	
	;; Kernal vectors - routines
	.alias IOPEN     $031A
	.alias ICLOSE    $031C
	.alias ICHKIN    $031E
	.alias ICKOUT    $0320
	.alias ICLRCH    $0322
	.alias IBASIN    $0324
	.alias IBASOUT   $0326
	.alias ISTOP     $0328
	.alias IGETIN    $032A
	.alias ICLALL    $032C
	.alias USRCMD    $032E
	.alias ILOAD     $0330
	.alias ISAVE     $0331
