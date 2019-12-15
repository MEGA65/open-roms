
//
// Official Kernal routine, described in:
//
// - [RG64] C64 Programmer's Reference Guide   - page 293/294
// - [CM64] Compute's Mapping the Commodore 64 - page 231/232
// - IEC reference at http://www.zimmers.net/anonftp/pub/cbm/programming/serial-bus.pdf
//
// CPU registers that has to be preserved (see [RG64]): none
//

SAVE:

	// Reset status
	jsr kernalstatus_reset

#if CONFIG_MEMORY_MODEL_60K
	// We need our helpers to get to filenames under ROMs or IO area
	jsr install_ram_routines
#endif

	// Check whether we support the requested device
	lda FA

#if CONFIG_IEC
	jsr iec_check_devnum_lvs
	bcc_far save_iec
#endif

	jmp lvs_illegal_device_number 
