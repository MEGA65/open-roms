
;;
;; Default values for Kernal vectors - described in:
;;
;; - [RG64] C64 Programmer's Reference Guide   - page 293 (RESTOR), 304 (VECTOR)
;; - [CM64] Compute's Mapping the Commodore 64 - page 237
;;

vector_defaults:
	.word default_irq_handler    ;; CINV
	.word $0000                  ;; CBINV    XXX implement this, has to be $FE66 for autostart support
	.word $0000                  ;; NMINV    XXX implement this, has to be $FE47 for autostart support

	.word open     ;; IOPEN
	.word close    ;; ICLOSE
	.word chkin    ;; ICHKIN   XXX move routine to $F20E - for autostart support
	.word ckout    ;; ICKOUT   XXX move routine to $F250 - for autostart support
	.word clrchn   ;; ICLRCH
	.word chrin    ;; IBASIN
	.word chrout   ;; IBSOUT
	.word stop     ;; ISTOP
	.word getin    ;; IGETIN
	.word clall    ;; ICLALL
	.word $0000    ;; USRCMD   XXX implement this, has to be $FE66 for autostart support
	.word load     ;; ILOAD 
	.word save     ;; ISAVE
