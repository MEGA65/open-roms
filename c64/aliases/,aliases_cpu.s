//
// Provide pseudocommands to make CPU optimizations easier
//


//
// This one is not for optimization - but to encourage proper usage of panic screen
//

.pseudocommand panic code
{
	lda code
	jmp (panic_vector)
}


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


//
// Branches with far offsets, substitutes by Bxx + JMP for CPUs not supporting the instruction
//


.pseudocommand bcs_far dst
{
#if CONFIG_CPU_CSG_65CE02
	.var offset = mod($10000 + dst.getValue() - *, $10000)
	.byte $B3, mod(offset, $100), floor(offset / $100)
#else
	bcc __l
	jmp dst
__l:
#endif
}

.pseudocommand bcc_far dst
{
#if CONFIG_CPU_CSG_65CE02
	.var offset = mod($10000 + dst.getValue() - *, $10000)
	.byte $93, mod(offset, $100), floor(offset / $100)
#else
	bcs __l
	jmp dst
__l:
#endif
}

.pseudocommand beq_far dst
{
#if CONFIG_CPU_CSG_65CE02
	.var offset = mod($10000 + dst.getValue() - *, $10000)
	.byte $F3, mod(offset, $100), floor(offset / $100)
#else
	bne __l
	jmp dst
__l:
#endif
}

.pseudocommand bne_far dst
{
#if CONFIG_CPU_CSG_65CE02
	.var offset = mod($10000 + dst.getValue() - *, $10000)
	.byte $D3, mod(offset, $100), floor(offset / $100)
#else
	beq __l
	jmp dst
__l:
#endif
}

.pseudocommand bmi_far dst
{
#if CONFIG_CPU_CSG_65CE02
	.var offset = mod($10000 + dst.getValue() - *, $10000)
	.byte $33, mod(offset, $100), floor(offset / $100)
#else
	bpl __l
	jmp dst
__l:
#endif
}

.pseudocommand bpl_far dst
{
#if CONFIG_CPU_CSG_65CE02
	.var offset = mod($10000 + dst.getValue() - *, $10000)
	.byte $13, mod(offset, $100), floor(offset / $100)
#else
	bmi __l
	jmp dst
__l:
#endif
}

.pseudocommand bvc_far dst
{
#if CONFIG_CPU_CSG_65CE02
	.var offset = mod($10000 + dst.getValue() - *, $10000)
	.byte $53, mod(offset, $100), floor(offset / $100)
#else
	bvs __l
	jmp dst
__l:
#endif
}

.pseudocommand bvs_far dst
{
#if CONFIG_CPU_CSG_65CE02
	.var offset = mod($10000 + dst.getValue() - *, $10000)
	.byte $73, mod(offset, $100), floor(offset / $100)
#else
	bvc __l
	jmp dst
__l:
#endif
}
