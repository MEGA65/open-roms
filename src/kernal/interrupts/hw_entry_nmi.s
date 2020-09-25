;; #LAYOUT# STD *        #TAKE
;; #LAYOUT# *   KERNAL_0 #TAKE
;; #LAYOUT# *   *        #IGNORE


hw_entry_nmi:

	sei                      ; do not allow IRQ to interfere, see https://www.c64-wiki.com/wiki/Interrupt

!ifndef HAS_OPCODES_65CE02 { !ifdef CONFIG_BCD_SAFE_INTERRUPTS {

	cld                      ; clear decimal flag to allow using it without disabling interrupts
} }

	; Call interrupt routine (only if initialised)
	pha

!ifndef CONFIG_MB_M65 {      ; XXX temporarily disabled for MEGA65, seems to cause crash during startup - to be investigated

	lda NMINV+1              ; consider zeropage NMI address as uninitialized vector
	beq @1                   ; this allows safer interrupt vector modifications 
	pla
	jmp (NMINV)
@1:

}

	; Vector not initialized - call default interrupt routine
	pla
	jmp default_nmi_handler
