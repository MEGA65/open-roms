// #LAYOUT# STD *        #TAKE
// #LAYOUT# *   KERNAL_0 #TAKE
// #LAYOUT# *   *        #IGNORE

//
// Official Kernal routine, described in:
//
// - [RG64] C64 Programmers Reference Guide   - page 286
// - [CM64] Computes Mapping the Commodore 64 - page 231
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


#if !CONFIG_TAPE_AUTODETECT

#if CONFIG_TAPE_NORMAL
	cmp #$01
	beq_16 load_tape_normal
#endif
#if CONFIG_TAPE_TURBO
	cmp #$07
	beq_16 load_tape_turbo
#endif

#else // CONFIG_TAPE_AUTODETECT

	cmp #$01
	beq_16 load_tape_auto
	cmp #$07
	beq_16 load_tape_auto

#endif


#if CONFIG_IEC
	jsr iec_check_devnum_lvs
	bcc_16 load_iec
#endif


	jmp lvs_illegal_device_number
