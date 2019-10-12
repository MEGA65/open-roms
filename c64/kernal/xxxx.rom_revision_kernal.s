
//
// !!! PROPOSAL ONLY !!! PROPOSAL ONLY !!! NOT FOR USING EXTERNALLY YET !!!
//
//
// Do not change! Locations of the following data should be constant - now and forever!
//
// If you want to integrate Open ROMs support in your emulator, FPGA ccomputer, etc. - this
// is the official way to recognize the ROM and it's revision.
//


// XXX we need to find a safe address within $E4D3-$FFFF range, we need 20 bytes


panic_vector: 

	// This vector is to be used by non-Kernal ROMs, if they want to complain
	// about incompatible ROM releases - jump via this vector with .A set to 1

	.byte <panic
	.byte >panic

rom_revision_kernal:

	.text "OR"               // Magic string, after "Open ROMs"
	.byte CONFIG_ID          // Config file ID, might change between revisions

rom_revision_kernal_string:

	.text "DEVEL SNAPSHOT"   // Actual ROM revision string
	.byte $00

__rom_revision_kernal_end:
