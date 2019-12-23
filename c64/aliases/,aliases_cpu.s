//
// Provide pseudocommands (and other goodies) to make CPU optimizations easier
//


#if CONFIG_CPU_WDC_65C02 || CONFIG_CPU_CSG_65CE02 || CONFIG_CPU_WDC_65816
	.cpu _65c02
	#define HAS_OPCODES_65C02
#endif

#if CONFIG_CPU_CSG_65CE02
	#define HAS_OPCODES_65CE02
#endif

#if CONFIG_CPU_WDC_65816
	#define HAS_OPCODES_65816
#endif


#if CONFIG_CPU_WDC_65C02 || CONFIG_CPU_CSG_65CE02 || CONFIG_CPU_WDC_65816
	#define HAS_BCD_SAFE_INTERRUPTS
#endif


//
// These are not exactly for optimization - but to encourage proper usage of panic screen
//

.pseudocommand panic code
{
	// If case no panic screen is used, we can skip providing error codes within Kernal
#if CONFIG_PANIC_SCREEN || !SEGMENT_KERNAL
	lda code
#endif
	jmp ($E4B7)
}


//
// Trick to skip a 2-byte instruction
//


.pseudocommand skip_2_bytes_trash_nvz
{
	.byte $2C
}


//
// Some additional 65CE02 instructions
//


#if HAS_OPCODES_65CE02

.pseudocommand dew addr
{
	.var arg = addr.getValue()
	.if (arg > $FF) .error "DEW requires zeropage address"
	.byte $C3, arg
}

.pseudocommand inw addr
{
	.var arg = addr.getValue()
	.if (arg > $FF) .error "INW requires zeropage address"
	.byte $E3, arg
}

#endif


//
// Stack manipulation - some CPUs will leave .A unchanged, some will use it as temporary storage, so consider .A trashed
//


.pseudocommand phx_trash_a
{
#if HAS_OPCODES_65C02
	phx
#else
	txa
	pha
#endif	
}

.pseudocommand phy_trash_a
{
#if HAS_OPCODES_65C02
	phy
#else
	tya
	pha
#endif	
}

.pseudocommand plx_trash_a
{
#if HAS_OPCODES_65C02
	plx
#else
	pla
	tax
#endif	
}

.pseudocommand ply_trash_a
{
#if HAS_OPCODES_65C02
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
#if HAS_OPCODES_65CE02
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
#if HAS_OPCODES_65CE02
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
#if HAS_OPCODES_65CE02 && XXX_DISABLED        // XXX causes problems with XEMU, investigate why
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
#if HAS_OPCODES_65CE02
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
#if HAS_OPCODES_65CE02
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
#if HAS_OPCODES_65CE02
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
#if HAS_OPCODES_65CE02
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
#if HAS_OPCODES_65CE02
	.var offset = mod($10000 + dst.getValue() - *, $10000)
	.byte $73, mod(offset, $100), floor(offset / $100)
#else
	bvc __l
	jmp dst
__l:
#endif
}
