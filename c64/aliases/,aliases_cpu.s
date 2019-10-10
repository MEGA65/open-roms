
//
// Provide pseudocommands to make CPU optimizations easier
//


.pseudocommand _phx
{
#if CONFIG_CPU_WDC_65C02 || CONFIG_CPU_WDC_65816
	phx
#else
	txa
	pha
#endif	
}

.pseudocommand _phy
{
#if CONFIG_CPU_WDC_65C02 || CONFIG_CPU_WDC_65816
	phy
#else
	tya
	pha
#endif	
}

.pseudocommand _plx
{
#if CONFIG_CPU_WDC_65C02 || CONFIG_CPU_WDC_65816
	plx
#else
	pla
	tax
#endif	
}

.pseudocommand _ply
{
#if CONFIG_CPU_WDC_65C02 || CONFIG_CPU_WDC_65816
	ply
#else
	pla
	tay
#endif	
}
