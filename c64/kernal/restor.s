; Function defined on pp272-273 of C64 Programmers Reference Guide
restor:

	;; According to 'Compute's Mapping the Commodore 64' p237 this resets 15 vectors
	;; placed starting from $0314
	
	;; XXX simplify this implementation when vector is implemented

	;; Make sure the IRQ is disabled - better safe than sorry
	php
	cli
	
	;; Copy vectors in a loop
	ldx #$1F
*
	lda restor_def_arr, x
	sta CINV, x
	dex
	bpl -
	
	;; Restore status register before return
	plp
	rts
	
restor_def_arr:
	.word $0000    ;; CINV     XXX implement this
	.word $0000    ;; CBINV    XXX implement this
	.word $0000    ;; NMINV    XXX implement this
	
	.word open     ;; IOPEN
	.word close    ;; ICLOSE
	.word chkin    ;; ICHKIN
	.word chkout   ;; ICKOUT
	.word clrchn   ;; ICLRCH
	.word chrin    ;; IBASIN
	.word chrout   ;; IBASOUT
	.word stop     ;; ISTOP
	.word getin    ;; IGETIN
	.word clall    ;; ICLALL
	.word $0000    ;; USRCMD   XXX implement this
	.word load     ;; ILOAD
	.word save     ;; ISAVE
