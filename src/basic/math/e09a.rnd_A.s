;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

;
; Random number generator routine
;
; Input:
; - .A (0 - reinitialize the seed with random value, $80 or above - create seed from FAC1)
;
; Output:
; - FAC1
;
; See also:
; - https://www.atarimagazines.com/compute/issue72/random_numbers.php
;

rnd_A:

	cmp #$00
	+beq rnd_seed_init

	cmp #$80
	+bcc rnd_generate

	jmp rnd_seed_from_FAC1
