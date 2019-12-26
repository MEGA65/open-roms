
//
// DolphinDOS protocol support for IEC - optimized load loop
//


#if CONFIG_IEC_DOLPHINDOS && !CONFIG_MEMORY_MODEL_60K


load_dolphindos:

	// Timing is critical for some parts, do not allow interrupts
	sei

	// A trick to shorten EAL update time
	ldy #$FF

	// FALLTROUGH

load_dolphindos_loop:



	panic #$00 // XXX this routine is not finished yet


#endif // CONFIG_IEC_DOLPHINDOS and not CONFIG_MEMORY_MODEL_60K
