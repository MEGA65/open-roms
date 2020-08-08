// #LAYOUT# M65 KERNAL_1 #TAKE
// #LAYOUT# *   *        #IGNORE


m65_scrtab_vic_ctrlb:        // parameters for VIC control register B

	.byte %00100000 // 40x25 + extended attributes
	.byte %10100000 // 80x25 + extended attributes
	.byte %10100100 // 80x50 + extended attributes

m65_scrtab_txtwidth:         // width of the text screen

	.byte 40
	.byte 80
	.byte 80

m65_scrtab_txtheight:        // height of the text screen

	.byte 25
	.byte 25
	.byte 50
