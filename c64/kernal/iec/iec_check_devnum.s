
//
// Checks whether device number (in .A) is a correct IEC device number
//
// Preserves .A, .X and .Y
//

iec_check_devnum:
	// 0, 1, 2, or 3 are illegal - reserved for non-IEC devices on Commodore
	cmp #$04
	bcs !+
	// FALLTROUGH
iec_check_devnum_failed:
	sec // indicate non-IEC device
	rts
!:
	// 31 and above are illegal too, due to IEC command encoding scheme,
	// see https://www.pagetable.com/?p=1031
	cmp #$1F
	bcs iec_check_devnum_failed
	// Carry is clear here - indicates IEC device
	rts
