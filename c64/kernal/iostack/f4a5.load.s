//
// Official Kernal routine, described in:
//
// - [RG64] C64 Programmer's Reference Guide   - page 286
// - [CM64] Compute's Mapping the Commodore 64 - page 231
// - IEC reference at http://www.zimmers.net/anonftp/pub/cbm/programming/serial-bus.pdf
//
// CPU registers that has to be preserved (see [RG64]): none
//


	// Expects that SETLFS and SETNAM are called before hand.
	// $YYXX = load address.
	// (ignored if SETLFS channel = 1, i.e., like ,8,1)
	// If A=1 then VERIFY instead of LOAD.
	// On exit, $YYXX is the highest address into which data
	// will have been placed.

	// XXX add VERIFY support

LOAD:

	// Are we loading or verifying?
	sta VERCKK

	// Store start address of LOAD
	lda MEMUSS+0
	sta STAL+0
	lda MEMUSS+1
	sty STAL+1

	// Reset status
	jsr kernalstatus_reset

#if CONFIG_MEMORY_MODEL_60K
	// We need our helpers to get to filenames under ROMs or IO area
	jsr install_ram_routines
#endif

	// Check whether we support the requested device
	lda FA

	// Try IEC - legal device numbers for LOAD are 8-30
	// Device numbers above 30 can not be used as IEC (see https://www.pagetable.com/?p=1031),
	// as the protocol combines device number with command code in one byte, above 30 it is
	// no longer possible. Original ROMs show ILLEGAL DEVICE NUMBER error only for devices
	// 0-3; our implementation is more strict here

	cmp #$1F
	bcs !+              // >= 31  
	cmp #$08
	bcs_far load_iec    // >= 8
!:
	jmp lvs_illegal_device_number
