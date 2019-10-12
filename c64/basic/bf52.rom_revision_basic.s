
//
// !!! PROPOSAL ONLY !!! PROPOSAL ONLY !!! NOT FOR USING EXTERNALLY YET !!!
//
//
// Do not change! Locations of the following data should be constant - now and forever!
//
// If you want to integrate Open ROMs support in your emulator, FPGA ccomputer, etc. - this
// is the official way to recognize the ROM and it's revision.
//


rom_revision_basic:

	// $BF52

	.text "OR"               // Magic string, after "Open ROMs"
	.byte CONFIG_ID          // Config file ID, might change between revisions

rom_revision_basic_string:

	.text "DEVEL SNAPSHOT"   // Actual ROM revision string
	.byte $00

__rom_revision_basic_end:
