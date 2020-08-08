// #LAYOUT# M65 KERNAL_1 #TAKE
// #LAYOUT# *   *        #IGNORE


// Table of parameters for VIC control register B

m65_scrtab_vic_ctrlb:

	.byte %00100000 // 40x25 + extended attributes
	.byte %10100000 // 80x25 + extended attributes
	.byte %10100100 // 80x50 + extended attributes
