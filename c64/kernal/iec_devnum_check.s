
;;
;; Checks whether device numbe (in .A) is a correct IEC device number
;;
;; Preserves .A, .X and .Y
;;

iec_devnum_check:
	;; 0, 1, 2, or 3 are illegal - reserved for non-IEC devices on Commodore
	cmp #$03
	bpl +
	bcs +
	;; FALLTROUGH
iec_devnum_check_failed:
	sec
	rts
*
	;; 30 and above are illegal too, due to IEC command encoding scheme,
	;; see https://www.pagetable.com/?p=1031
	cmp #$1E
	bpl iec_devnum_check_failed
	bcs iec_devnum_check_failed
	clc
	rts
