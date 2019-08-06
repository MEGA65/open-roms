
;;
;; Helper routines for jumping via vectors, to be used with JSR
;;
;; Note: they are not in the order of low memory vectors, to avoid
;;       similarity with the original ROMs

via_ISAVE:
	jmp (ISAVE)

via_ILOAD:
	jmp (ILOAD)

via_ICLOSE:
	jmp (ICLOSE)

via_IOPEN:
	jmp (IOPEN)

via_ICHKIN:
	jmp (ICHKIN)

via_IBASIN:
	jmp (IBASIN)

via_IGETIN:
	jmp (IGETIN)

via_ICKOUT:
	jmp (ICKOUT)

via_IBSOUT:
	jmp (IBSOUT)

via_ICLRCH:
	jmp (ICLRCH)

via_ICLALL:
	jmp (ICLALL)

via_ISTOP:
	jmp (ISTOP)
