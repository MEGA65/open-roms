
;;
;; Official Kernal routine, described in:
;;
;; - [RG64] C64 Programmer's Reference Guide   - page 293 (RESTOR), 304 (VECTOR)
;; - [CM64] Compute's Mapping the Commodore 64 - page 237
;;
;; CPU registers that has to be preserved (see [RG64]): none
;;

restor:

	clc ;; clear carry - for writing to system table
	ldx #<vector_defaults
	ldy #>vector_defaults

	;; FALLTHROUGH

vector:

.scope

	;; Temporary storage location
	.alias _caller_arr_ptr CMP0

	;; According to 'Compute's Mapping the Commodore 64' page 237,
	;; the CBM implementation does not disable IRQs - yet, the
	;; 'C64 Programmers Reference Guide' does not contain such
	;; warning and does not mention any preparations needed, so...
	;; better safe than sorry, disable the IRQ for the duration
	;; of vector manipulation
	php
	cli
	
	;; Prepare the user data pointer
	stx _caller_arr_ptr + 0
	sty _caller_arr_ptr + 1
	
	;; Select routine variant - store or restore vectors
	ldy #$1F
	bcc vector_restore
	
	;; FALLTHROUGH
	
vector_store:
*
	lda CINV, y
	sta (_caller_arr_ptr), y
	dey
	bpl -
	
	;; Restore status register (IRQ) before return
	plp
	rts
	
vector_restore:
*
	lda (_caller_arr_ptr), y
	sta CINV, y
	dey
	bpl -

	;; Restore status register (IRQ) before return
	plp
	rts

.scend

	;; XXX below we have quite a lot of data... should we decouple them?

vector_defaults:
	.word default_irq_handler    ;; CINV
	.word $0000                  ;; CBINV    XXX implement this
	.word $0000                  ;; NMINV    XXX implement this
	
	.word open     ;; IOPEN
	.word close    ;; ICLOSE
	.word chkin    ;; ICHKIN
	.word ckout    ;; ICKOUT
	.word clrchn   ;; ICLRCH
	.word chrin    ;; IBASIN
	.word chrout   ;; IBSOUT
	.word stop     ;; ISTOP
	.word getin    ;; IGETIN
	.word clall    ;; ICLALL
	.word $0000    ;; USRCMD   XXX implement this
	.word load     ;; ILOAD
	.word save     ;; ISAVE
