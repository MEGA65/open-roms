
	// BASIC startup vectors


#if ROM_LAYOUT_X16

	.label IBASIC_COLD_START  = $C000
	.label IBASIC_WARM_START  = $C002

#else

	.label IBASIC_COLD_START  = $A000
	.label IBASIC_WARM_START  = $A002

#endif
