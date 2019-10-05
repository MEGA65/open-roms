
//
// Default values for Kernal vectors - described in:
//
// - [RG64] C64 Programmer's Reference Guide   - page 293 (RESTOR), 304 (VECTOR)
// - [CM64] Compute's Mapping the Commodore 64 - page 237
//

vector_defaults:
	.word default_irq_handler    // CINV
	.word default_brk_handler    // CBINV
	.word default_nmi_handler    // NMINV

	.word OPEN                   // IOPEN
	.word CLOSE                  // ICLOSE
	.word CHKIN                  // ICHKIN
	.word CKOUT                  // ICKOUT
	.word CLRCHN                 // ICLRCH
	.word CHRIN                  // IBASIN
	.word CHROUT                 // IBSOUT
	.word STOP                   // ISTOP
	.word GETIN                  // IGETIN
	.word CLALL                  // ICLALL
	.word default_brk_handler    // USRCMD
	.word LOAD                   // ILOAD 
	.word SAVE                   // ISAVE
