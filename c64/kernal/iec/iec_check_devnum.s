
//
// Checks whether device number (in .A) is a correct IEC device number
//
// Preserves .A, .X and .Y
//


#if CONFIG_IEC

iec_check_devnum_lvs: // for load/verify/save

	cmp #$08 // below 8 are illegal for load/save
	bcc iec_check_devnum_failed

	// FALLTROUGH

iec_check_devnum_oc: // for open/close

	cmp #$04 // below 4 are illegal, reserved for non-IEC devices on Commodore
	bcc iec_check_devnum_failed

	// 31 and above are illegal too, due to IEC command encoding scheme,
	// see https://www.pagetable.com/?p=1031
	cmp #$1F // sets carry for 31 or above
	rts

iec_check_devnum_failed:

	sec // indicate non-IEC device
	rts

#endif // CONFIG_IEC
