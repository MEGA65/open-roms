// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE


array_create:

	// First retrieve array name

	jsr fetch_variable_name
	bcs_16 do_SYNTAX_error

	// XXX check if the array already exists

	// It will be easier if we first perform garbage collection (arrays are not declared often)

	jsr varstr_garbage_collect

	// Now, create the array structure

	lda STREND+0
	sta INDEX+0
	lda STREND+1
	sta INDEX+1

	// XXX check if there is enough distance between INDEX and FRETOP

	// Store:
	// - the array name (2 bytes)
	// - offset to the next array (2 bytes) - 0 to mark the last one
	// - initial array dimension - 0

#if CONFIG_MEMORY_MODEL_60K
	
	// XXX: implement this

#else // CONFIG_MEMORY_MODEL_38K || CONFIG_MEMORY_MODEL_46K || CONFIG_MEMORY_MODEL_50K

	ldy #$00
	lda	VARNAM+0
	sta (STREND), y
	iny
	lda	VARNAM+1
	sta (STREND), y
	iny
	lda #$00
	sta (STREND),y
	iny
	sta (STREND),y
	iny
	sta (STREND),y

#endif

	//



	// XXX bit DIMFLG, bmi = use default params



	// XXX

	jsr do_NOT_IMPLEMENTED_error
