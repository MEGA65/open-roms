
//
// Provide pseudocommands (and other goodies) to make CPU optimizations easier
//

#if CONFIG_CPU_WDC_65C02 || CONFIG_CPU_CSG_65CE02 || CONFIG_CPU_CSG_4510 || CONFIG_CPU_M65_45GS02 || CONFIG_CPU_WDC_65816
	.cpu _65c02
	#define HAS_OPCODES_65C02
	#define HAS_BCD_SAFE_INTERRUPTS
#endif

#if CONFIG_CPU_CSG_65CE02 || CONFIG_CPU_CSG_4510 || CONFIG_CPU_M65_45GS02
	#define HAS_OPCODES_65CE02
#endif

#if CONFIG_CPU_CSG_4510 || CONFIG_CPU_M65_45GS02
	#define HAS_OPCODES_4510
#endif

#if CONFIG_CPU_M65_45GS02
	#define HAS_OPCODES_45GS02
#endif

#if CONFIG_CPU_WDC_65816
	#define HAS_OPCODES_65816
#endif



//
// These are not exactly for optimization - but to encourage proper usage of panic screen
//

.pseudocommand panic code
{
	// If case no panic screen is used, we can skip providing error codes within Kernal
#if CONFIG_PANIC_SCREEN
	lda code
#endif
	jmp ($E4B7)
}



//
// Macros for generating jumptables
//


.macro put_jumptable_lo(list)
{
	.for (var i = 0; i < list.size(); i++)
	{
		.byte mod((list.get(i) - 1), $100)
	}
}

.macro put_jumptable_hi(list)
{
	.for (var i = 0; i < list.size(); i++)
	{
		.byte floor((list.get(i) - 1) / $100)
	}
}

#if HAS_OPCODES_65C02

.macro put_jumptable(list)
{
	.for (var i = 0; i < list.size(); i++)
	{
		.word list.get(i)
	}
}

#endif



//
// Trick to skip a 2-byte instruction
//

.pseudocommand skip_2_bytes_trash_nvz { .byte $2C }



//
// Memory mapping for C65 and Mega65
//

#if HAS_OPCODES_4510

.pseudocommand map { .byte $5C }
.pseudocommand eom { .byte $EA }

#endif



//
// Some additional 65CE02 instructions
//

#if HAS_OPCODES_65CE02

// CPU flags support

.pseudocommand cle { .byte $02 }
.pseudocommand see { .byte $03 }

// .B register support

.pseudocommand tab { .byte $5B }
.pseudocommand tba { .byte $7B }

// .Z register support

.pseudocommand inz { .byte $1B }
.pseudocommand dez { .byte $3B }
.pseudocommand phz { .byte $DB }
.pseudocommand plz { .byte $FB }
.pseudocommand taz { .byte $4B }
.pseudocommand tza { .byte $6B }

// 16-bit data processing

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

// Zero page bit handling

.pseudocommand rmb0 addr
{
	.var arg = addr.getValue()
	.if (arg > $FF) .error "RMB0 requires zeropage address"
	.byte $07, arg
}

.pseudocommand rmb1 addr
{
	.var arg = addr.getValue()
	.if (arg > $FF) .error "RMB1 requires zeropage address"
	.byte $17, arg
}

.pseudocommand rmb2 addr
{
	.var arg = addr.getValue()
	.if (arg > $FF) .error "RMB2 requires zeropage address"
	.byte $27, arg
}

.pseudocommand rmb3 addr
{
	.var arg = addr.getValue()
	.if (arg > $FF) .error "RMB3 requires zeropage address"
	.byte $37, arg
}

.pseudocommand rmb4 addr
{
	.var arg = addr.getValue()
	.if (arg > $FF) .error "RMB4 requires zeropage address"
	.byte $47, arg
}

.pseudocommand rmb5 addr
{
	.var arg = addr.getValue()
	.if (arg > $FF) .error "RMB5 requires zeropage address"
	.byte $57, arg
}

.pseudocommand rmb6 addr
{
	.var arg = addr.getValue()
	.if (arg > $FF) .error "RMB6 requires zeropage address"
	.byte $67, arg
}

.pseudocommand rmb7 addr
{
	.var arg = addr.getValue()
	.if (arg > $FF) .error "RMB7 requires zeropage address"
	.byte $77, arg
}

.pseudocommand smb0 addr
{
	.var arg = addr.getValue()
	.if (arg > $FF) .error "SMB0 requires zeropage address"
	.byte $87, arg
}

.pseudocommand smb1 addr
{
	.var arg = addr.getValue()
	.if (arg > $FF) .error "SMB1 requires zeropage address"
	.byte $97, arg
}

.pseudocommand smb2 addr
{
	.var arg = addr.getValue()
	.if (arg > $FF) .error "SMB2 requires zeropage address"
	.byte $A7, arg
}

.pseudocommand smb3 addr
{
	.var arg = addr.getValue()
	.if (arg > $FF) .error "SMB3 requires zeropage address"
	.byte $B7, arg
}

.pseudocommand smb4 addr
{
	.var arg = addr.getValue()
	.if (arg > $FF) .error "SMB4 requires zeropage address"
	.byte $C7, arg
}

.pseudocommand smb5 addr
{
	.var arg = addr.getValue()
	.if (arg > $FF) .error "SMB5 requires zeropage address"
	.byte $D7, arg
}

.pseudocommand smb6 addr
{
	.var arg = addr.getValue()
	.if (arg > $FF) .error "SMB6 requires zeropage address"
	.byte $E7, arg
}

.pseudocommand smb7 addr
{
	.var arg = addr.getValue()
	.if (arg > $FF) .error "SMB7 requires zeropage address"
	.byte $F7, arg
}

// Additional addressing modes

.pseudocommand jsr_ind addr
{
	.var arg = addr.getValue()
	.byte $22, mod(arg, $100), floor(arg / $100)
}

.pseudocommand jsr_ind_x addr
{
	.var arg = addr.getValue()
	.byte $23, mod(arg, $100), floor(arg / $100)
}


// Others, taken from https://github.com/smnjameson/M65_KickAsm_PseudoCommands

.const z  = -999            // allows (base page),z addressing mode
.const sy = -998            // allows (base page, s),y addressing mode
.const AT_IZEROPAGEZ = 13   // adds a pseudo addressing mode
.const AT_INDIRECTX = -5    // adds a pseudo addressing mode

.function GetAdressingModeType(arg) {
	.if(arg == AT_NONE)       .return "AT_NONE"
	.if(arg == AT_IMMEDIATE)  .return "AT_IMMEDIATE"
	.if(arg == AT_INDIRECT)   .return "AT_INDIRECT"
	.if(arg == AT_INDIRECTX)  .return "AT_INDIRECTX"
	.if(arg == AT_ABSOLUTE)   .return "AT_ABSOLUTE"
	.if(arg == AT_ABSOLUTEX)  .return "AT_ABSOLUTEX"
	.if(arg == AT_ABSOLUTEY)  .return "AT_ABSOLUTEY"
	.if(arg == AT_IZEROPAGEX) .return "AT_IZEROPAGEX"
	.if(arg == AT_IZEROPAGEY) .return "AT_IZEROPAGEY"
	.if(arg == AT_IZEROPAGEZ) .return "AT_IZEROPAGEZ"
	.return arg
}

.pseudocommand cpz arg {
	.var value = arg.getValue()
	.var type  = arg.getType()	
	.if(type == AT_IMMEDIATE) {
		.byte $C2, value
	} else .if(type == AT_ABSOLUTE) {
		.if(value <= $FF ) {
			.byte $D4, value
		} else {
			.byte $DC, <value, >value
		}
	} else {
		.error "Invalid adressingmode. 'cpz' doesn't support "+GetAdressingModeType(type)+" mode"
	}
}

.pseudocommand lda arg {
	.var value = arg.getValue()
	.var type  = arg.getType()
	.if(type != AT_IZEROPAGEZ) .error "':lda' only accepts AT_IZEROPAGEZ"
	.if(value > $FF )          .error "':lda ($nn),z' requires zeropage address"
	.byte $B2, value
}

.pseudocommand ldz arg
{
	.var value = arg.getValue()
	.var type  = arg.getType()	
	.if(type == AT_IMMEDIATE) {
		.byte $A3, value
	} else .if(type == AT_ABSOLUTE) {
		.byte $AB, <value, >value
	} else .if(type == AT_ABSOLUTEX) {
		.byte $BB, <value, >value
	} else {
		.error "Invalid adressingmode. 'ldz' doesn't support "+GetAdressingModeType(type)+" mode"
	}
}

.pseudocommand sta arg {
	.var value = arg.getValue()
	.var type  = arg.getType()
	.if(type != AT_IZEROPAGEZ) .error "':sta' only accepts AT_IZEROPAGEZ"
	.if(value > $FF )          .error "':sta ($nn),z' requires zeropage address"
	.byte $92, value
}

// Flat memory access support

.pseudocommand sta_lp arg {
	.var value = arg.getValue()
	.var type  = arg.getType()
	.if(type != AT_IZEROPAGEZ) .error "'sta_lp' only accepts AT_IZEROPAGEZ"
	.if(value > $FF )          .error "'sta_lp' requires zeropage address"
	nop
	.byte $92, value
}

#endif



//
// Calculation shortcuts
//

.pseudocommand lda_zero                // WARNING: do not use within interrupts
{
#if HAS_OPCODES_65CE02
	tba
#else
	lda #$00
#endif	
}



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

.pseudocommand bcs_16 dst
{
#if HAS_OPCODES_65CE02
	.var offset = mod($10000 + dst.getValue() - *, $10000) -2
	.byte $B3, mod(offset, $100), floor(offset / $100)
#else
	bcc __l
	jmp dst
__l:
#endif
}

.pseudocommand bcc_16 dst
{
#if HAS_OPCODES_65CE02
	.var offset = mod($10000 + dst.getValue() - *, $10000) -2
	.byte $93, mod(offset, $100), floor(offset / $100)
#else
	bcs __l
	jmp dst
__l:
#endif
}

.pseudocommand beq_16 dst
{
#if HAS_OPCODES_65CE02
	.var offset = mod($10000 + dst.getValue() - *, $10000) -2
	.byte $F3, mod(offset, $100), floor(offset / $100)
#else
	bne __l
	jmp dst
__l:
#endif
}

.pseudocommand bne_16 dst
{
#if HAS_OPCODES_65CE02
	.var offset = mod($10000 + dst.getValue() - *, $10000) -2
	.byte $D3, mod(offset, $100), floor(offset / $100)
#else
	beq __l
	jmp dst
__l:
#endif
}

.pseudocommand bmi_16 dst
{
#if HAS_OPCODES_65CE02
	.var offset = mod($10000 + dst.getValue() - *, $10000) -2
	.byte $33, mod(offset, $100), floor(offset / $100)
#else
	bpl __l
	jmp dst
__l:
#endif
}

.pseudocommand bpl_16 dst
{
#if HAS_OPCODES_65CE02
	.var offset = mod($10000 + dst.getValue() - *, $10000) -2
	.byte $13, mod(offset, $100), floor(offset / $100)
#else
	bmi __l
	jmp dst
__l:
#endif
}

.pseudocommand bvc_16 dst
{
#if HAS_OPCODES_65CE02
	.var offset = mod($10000 + dst.getValue() - *, $10000) -2
	.byte $53, mod(offset, $100), floor(offset / $100)
#else
	bvs __l
	jmp dst
__l:
#endif
}

.pseudocommand bvs_16 dst
{
#if HAS_OPCODES_65CE02
	.var offset = mod($10000 + dst.getValue() - *, $10000) -2
	.byte $73, mod(offset, $100), floor(offset / $100)
#else
	bvc __l
	jmp dst
__l:
#endif
}


//
// Near jump, on some CPUs can be substituted with shorter instruction
//

.pseudocommand jmp_8 dst
{
#if HAS_OPCODES_65C02
	bra dst
#else
	jmp dst
#endif
}
