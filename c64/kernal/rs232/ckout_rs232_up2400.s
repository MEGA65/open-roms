#if ROM_LAYOUT_STD || (ROM_LAYOUT_M65 && SEGMENT_KERNAL_0)

//
// RS-232 part of the CKOUT routine
//


#if CONFIG_RS232_UP2400


ckout_rs232:
	STUB_IMPLEMENTATION() // XXX provide implementation for both UP2400 and UP9600


#endif // CONFIG_RS232_UP2400


#endif // ROM layout
