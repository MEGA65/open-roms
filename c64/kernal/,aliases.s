
// XXX get rid of this file

#if CONFIG_MEMORY_MODEL_60K

	// Under-ROM routines
	// (BASIC also includes them. XXX - We should de-duplicate them in a safe manner)
	.label missed_nmi_flag = $2A7
	.label tiny_nmi_handler = $2A8	
	.label peek_under_roms = tiny_nmi_handler+peek_under_roms_routine-tiny_nmi_handler_routine
	.label poke_under_roms = tiny_nmi_handler+poke_under_roms_routine-tiny_nmi_handler_routine
	.label memmap_allram = tiny_nmi_handler+memmap_allram_routine-tiny_nmi_handler_routine
	.label memmap_normal = tiny_nmi_handler+memmap_normal_routine-tiny_nmi_handler_routine

#endif // CONFIG_MEMORY_MODEL_60K
