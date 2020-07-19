// #LAYOUT# STD *       #TAKE
// #LAYOUT# M65 *       #TAKE
// #LAYOUT# X16 BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE


// See https://www.c64-wiki.com/wiki/Memory_(BASIC) for BASIC memory organization


do_new:	

#if (ROM_LAYOUT_M65 && SEGMENT_BASIC_0)

	jsr     map_BASIC_1
	jsr_ind VB1__do_new
	jmp     map_NORMAL

do_clr:

	jsr     map_BASIC_1
	jsr_ind VB1__do_clr
	jmp     map_NORMAL

do_restore:

	jsr     map_BASIC_1
	jsr_ind VB1__do_restore
	jmp     map_NORMAL

#else

	// See Computes Mapping the Commodore 64 - page 96

	ldy #$00
	tya
	sta (TXTTAB),y
	iny
	sta (TXTTAB),y

	// The book does not mention this, but IMHO it is necessary to initialize VARTAB here too

	clc
	lda TXTTAB+0
	adc #$02
	sta VARTAB+0
	lda TXTTAB+1
	adc #$00
	sta VARTAB+1

do_clr:

	// See Computes Mapping the Commodore 64 - page 96

	// XXX check if original ROM does this too
	jsr JCLALL

	lda MEMSIZ+0
	sta FRETOP+0 
	lda MEMSIZ+1
	sta FRETOP+1 

	// The book is not precise here $31-$32 is definitely not the end of BASIC text

	lda VARTAB+0
	sta ARYTAB+0
	sta STREND+0

	lda VARTAB+1
	sta ARYTAB+1
	sta STREND+1	

	// This is a good place to reset the temporary string stack

	jsr tmpstr_free_all_reset

	// FALLTROUGH (confirmed on real C64 that CLR indeed resets DATPTR)

do_restore:

	// See Computes Mapping the Commodore 64 - page 98
	// Initial DATPTR value checked on real C64

#if HAS_OPCODES_65CE02

	lda TXTTAB+0
	sta DATPTR+0
	lda TXTTAB+1
	sta DATPTR+1

	dew DATPTR

#else

	sec
	lda TXTTAB+0
	sbc #$01
	sta DATPTR+0
	lda TXTTAB+1
	sbc #$00
	sta DATPTR+1

#endif

	rts


#endif // ROM layout
