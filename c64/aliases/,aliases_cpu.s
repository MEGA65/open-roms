//
// Provide pseudocommands to make CPU optimizations easier
//


//
// Stack manipulation - some CPUs will leave .A unchanged, some will use it as temporary storage, so consider .A trashed
//


.pseudocommand phx_trash_a
{
#if CONFIG_CPU_WDC_65C02 || CONFIG_CPU_CSG_65CE02 || CONFIG_CPU_WDC_65816
	phx
#else
	txa
	pha
#endif	
}

.pseudocommand phy_trash_a
{
#if CONFIG_CPU_WDC_65C02 || CONFIG_CPU_CSG_65CE02 || CONFIG_CPU_WDC_65816
	phy
#else
	tya
	pha
#endif	
}

.pseudocommand plx_trash_a
{
#if CONFIG_CPU_WDC_65C02 || CONFIG_CPU_CSG_65CE02 || CONFIG_CPU_WDC_65816
	plx
#else
	pla
	tax
#endif	
}

.pseudocommand ply_trash_a
{
#if CONFIG_CPU_WDC_65C02 || CONFIG_CPU_CSG_65CE02 || CONFIG_CPU_WDC_65816
	ply
#else
	pla
	tay
#endif	
}
