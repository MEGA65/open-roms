// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// !!! PROPOSAL ONLY !!! PROPOSAL ONLY !!! NOT FOR USING EXTERNALLY YET !!!
//
//
// Do not change! Locations of the following data should be constant - now and forever!
//
// If you want to integrate Open ROMs support in your emulator, FPGA ccomputer, etc. - this
// is the official way to recognize the ROM and its revision.
//


	// $E4B7

	// This vector is to be used by non-Kernal ROMs, if they want to
	// complain about incompatible ROM releases - do not use it directly,
	// use a 'panic' pseudocommand with error code (will be passed using .A)
	// #P_ERR_ROM_MISMATCH - it should remain stable even between releases

#if CONFIG_PANIC_SCREEN
	.word panic
#else
	.word hw_entry_reset
#endif


rom_revision_kernal:

	// $E4B9

	.text "OR"                // project signature, after "Open ROMs"
	.byte CONFIG_ID           // config file ID, might change between revisions

rom_revision_kernal_string:

	// $E4BC

#if !CONFIG_BRAND_CUSTOM_BUILD
	.text "(DEVEL SNAPSHOT)"  // actual ROM revision string; up to 16 characters
#else
	.text "(CUSTOM BUILD)"
#endif

	.byte $00                 // marks the end of string

__rom_revision_kernal_end:
