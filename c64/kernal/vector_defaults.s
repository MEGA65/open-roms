
;;
;; Default values for Kernal vectors - described in:
;;
;; - [RG64] C64 Programmer's Reference Guide   - page 293 (RESTOR), 304 (VECTOR)
;; - [CM64] Compute's Mapping the Commodore 64 - page 237
;;

vector_defaults:
	.word default_irq_handler    ;; CINV
	.word default_brk_handler    ;; CBINV
	.word default_nmi_handler    ;; NMINV

	.word open                   ;; IOPEN
	.word close                  ;; ICLOSE
	.word chkin                  ;; ICHKIN
	.word ckout                  ;; ICKOUT
	.word clrchn                 ;; ICLRCH
	.word chrin                  ;; IBASIN
	.word chrout                 ;; IBSOUT
	.word stop                   ;; ISTOP
	.word getin                  ;; IGETIN
	.word clall                  ;; ICLALL
	.word default_brk_handler    ;; USRCMD
	.word load                   ;; ILOAD 
	.word save                   ;; ISAVE
