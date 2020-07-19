// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// Allocates memory for string - lowers FRETOP (but not below STREND)
//
// Note: We are not going to use the C64-style memory management here, as it implies
// a very slow garbage collector. Instead, we are using a scheme similar to used in
// BASIC V3.5 and later, with 'back-pointers' after each string, telling about the
// location of the string descriptor. 
//
// See:
// - https://www.c64-wiki.com/wiki/Memory_(BASIC)
// - https://sites.google.com/site/h2obsession/CBM/basic/variable-format
//
// Input:
// - VARPNT - pointer to string descriptor, first pointed byte should contain desired length
// Output:
// - fills-in pointer in the string descriptor
//

// NOTE: if FAC1 or FAC2 contains a value (not a string descriptor - these are going to be updated
//       if garbage collector starts), then preserve __FAC1+1/+2 and __FAC2+1/+2 somewhere, as there
//       is a small chance they'll get damaged!

varstr_alloc:

	// Mark garbage collector as not run yet

	lda #$00

	// FALLTROUGH

varstr_alloc_retry:

	sta GARBFL                                   // Computes Mapping the Commodore 64, page 10

	// Backup FRETOP in case of alocation problems

	lda FRETOP+0
	sta INDEX+0
	lda FRETOP+1
	sta INDEX+1

	// Lower FRETOP to make space for the back-pointer

#if !HAS_OPCODES_65CE02

	lda #$02
	jsr helper_FRETOP_down_A

#else // HAS_OPCODES_65CE02 - this time code is slightly longer, but faster

	dew FRETOP
	dew FRETOP

	jsr helper_FRETOP_check

#endif

	bcs varstr_alloc_fail

	// Create the back-pointer to the string descriptor

	ldy #$00
	lda VARPNT+0

#if CONFIG_MEMORY_MODEL_60K
	ldx #<FRETOP
	jsr poke_under_roms
#else // CONFIG_MEMORY_MODEL_38K || CONFIG_MEMORY_MODEL_46K || CONFIG_MEMORY_MODEL_50K
	sta (FRETOP), y
#endif

	iny
	lda VARPNT+1

#if CONFIG_MEMORY_MODEL_60K
	jsr poke_under_roms
#else // CONFIG_MEMORY_MODEL_38K || CONFIG_MEMORY_MODEL_46K || CONFIG_MEMORY_MODEL_50K
	sta (FRETOP), y
#endif

	// Now lower FRETOP again to make space for the string content

	ldy #$00

#if CONFIG_MEMORY_MODEL_60K
	ldx #<VARPNT
	jsr peek_under_roms
#elif CONFIG_MEMORY_MODEL_46K || CONFIG_MEMORY_MODEL_50K
	jsr peek_under_roms_via_VARPNT
#else // CONFIG_MEMORY_MODEL_38K
	lda (VARPNT),y
#endif

	jsr helper_FRETOP_down_A
	bcs varstr_alloc_fail

	// Success - fill in the string descriptor

	ldy #$01

#if CONFIG_MEMORY_MODEL_60K
	ldx #<VARPNT
	lda FRETOP+0
	jsr poke_under_roms
	iny
	lda FRETOP+1
	jsr poke_under_roms
#else // CONFIG_MEMORY_MODEL_38K || CONFIG_MEMORY_MODEL_46K || CONFIG_MEMORY_MODEL_50K
	lda FRETOP+0
	sta (VARPNT), y
	iny
	lda FRETOP+1
	sta (VARPNT), y
#endif

	// The end

	rts

varstr_alloc_fail:

	// Unable to alocate memory - restore FRETOP value

	lda INDEX+0
	sta FRETOP+0
	lda INDEX+1
	sta FRETOP+1

	// Check if it is worth to perform garbage collection and retry

	bit GARBFL
	bpl_16 do_OUT_OF_MEMORY_error

	dec GARBFL                                   // $00 -> $FF
	jsr varstr_garbage_collect

	jmp_8 varstr_alloc_retry
