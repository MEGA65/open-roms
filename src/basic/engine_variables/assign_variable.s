;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE


assign_variable:

	; Fetch variable/array name

	jsr fetch_variable_name
	+bcs do_SYNTAX_error

	; Check for array

	lda DIMFLG
	bpl assign_variable_not_array_1

	; This is an array - push return address to the stack, will be needed later

	lda #>(assign_variable_arr_ret-1)
	pha
	lda #<(assign_variable_arr_ret-1)
	pha

	; Store FOUR6 on tha stack

	lda FOUR6
	pha

	; Retrieve all the coordinates

	ldx #$00
@1:
	inx
	jsr helper_fetch_arr_coord

	lda LINNUM+1
	pha
	lda LINNUM+0
	pha

	; Check if more dimensions are given

	cpy #$00
	beq @1

	; Store number of dimensions on the stack

	+phx_trash_a

	; Fetch assignment operator and continue

	jsr injest_assign

	lda #$FF                           ; force DIMFLG to be array
	+bra assign_variable_common_1

assign_variable_not_array_1:

	; Require assignment operator

	jsr injest_assign

	; Check for special variables

	jsr is_var_TI_string
	+beq assign_variable_TI_string

	jsr is_var_TI
	+beq do_SYNTAX_error

	jsr is_var_ST
	+beq do_SYNTAX_error

	; Push the DIMFLG and VARNAM to the stack - it might get overridden

	lda DIMFLG

	; FALLTROUGH

assign_variable_common_1:

	pha
	lda VARNAM+0
	pha
	lda VARNAM+1
	pha

	; Evaluate the expression

	jsr FRMEVL

	; Restore VARNAM and DIMFLG

	pla
	sta VARNAM+1
	pla
	sta VARNAM+0
	pla
	sta DIMFLG ; XXX is it needed?

	; Check if array

	bpl assign_variable_not_array_2

	; Yes, this is an array - preserve FAC1 values which might get overwritten
	; XXX adapt this for floats!

	ldx #$04
@2:
	lda __FAC1,x
	sta __FAC2,x
	dex
	bpl @2

	; Get array address

	jsr find_array
	bcc @3

	; Array does not exist - we will have to create one with default parameters

	; XXX implement this

	jmp do_NOT_IMPLEMENTED_error
@3:
	; Fetch the number of dimensions

	pla
	sta __FAC1+0
	tax

	; Fetch the address of the variable

	jmp fetch_variable_arr_calc_pos              ; RTS goes to assign_variable_arr_ret

assign_variable_arr_ret:

	; Restore FAC1 values
	; XXX adapt this for floats!

	ldx #$04
@4:
	lda __FAC2,x
	sta __FAC1,x
	dex
	bpl @4
	bmi assign_variable_common_2                 ; branch always

assign_variable_not_array_2:

	; Retrieve the variable address

	jsr fetch_variable_find_addr

	; FALLTROUGH

assign_variable_common_2:

	; Determine variable type

	lda #$00
	clc
	bit VARNAM+0
	bpl @5
	adc #$01
@5:
	bit VARNAM+1
	bpl @6
	adc #$80
@6:
	; Determine what to assign

	bmi assign_string
	beq assign_float

	; FALLTROUGH

	; XXX integer and float probably have much in common

assign_integer:

	lda VALTYP
	+bmi do_TYPE_MISMATCH_error

!ifdef CONFIG_MEMORY_MODEL_60K {
	
	; XXX
	; XXX: implement this
	; XXX

} else ifdef CONFIG_MEMORY_MODEL_46K_OR_50K {
	; XXX consider optimized version without multiple JSRs

	; XXX
	; XXX: implement this
	; XXX

} else { ; CONFIG_MEMORY_MODEL_38K

	; XXX
	; XXX: implement this
	; XXX
}
	jmp do_NOT_IMPLEMENTED_error

assign_float:

	lda VALTYP
	+bmi do_TYPE_MISMATCH_error

!ifdef CONFIG_MEMORY_MODEL_60K {
	
	; XXX
	; XXX: implement this
	; XXX

} else ifdef CONFIG_MEMORY_MODEL_46K_OR_50K {
	; XXX consider optimized version without multiple JSRs

	; XXX
	; XXX: implement this
	; XXX

} else { ; CONFIG_MEMORY_MODEL_38K

	; XXX
	; XXX: implement this
	; XXX
}

	jmp do_NOT_IMPLEMENTED_error

assign_string:

	; Check if value type matches
	
	lda VALTYP
	+bpl do_TYPE_MISMATCH_error

	; Copy the string descriptor to DSCPNT

	jsr helper_strdesccpy

	; First special case - check if the new string has size 0

	lda __FAC1+0
	bne assign_string_not_empty

	; Yes, it is empty - free the old one

	jsr varstr_free

	; Set the new variable as empty string

	ldy #$00
	lda #$00

!ifdef CONFIG_MEMORY_MODEL_60K {
	ldx #<VARPNT
	jsr poke_under_roms
} else { ; CONFIG_MEMORY_MODEL_38K || CONFIG_MEMORY_MODEL_46K || CONFIG_MEMORY_MODEL_50K
	sta (VARPNT), y
}

	rts

assign_string_not_empty:

	; Check if the source and destination strings are the same

	lda DSCPNT+1
	cmp __FAC1+1
	bne assign_string_not_same
	iny
	lda DSCPNT+2
	cmp __FAC1+2
	bne assign_string_not_same

	; If we are here, than both source and destination strings are the same - nothing more to be done

	rts

assign_string_not_same:

	; Strings are not the same - check if the new one is located within the text area, between TXTTAB and VARTAB

	lda VARTAB+1
	cmp __FAC1+2
	bcc assign_string_not_text_area
	bne @7
	lda VARTAB+0
	cmp __FAC1+1
	bcc assign_string_not_text_area	
@7:
	lda __FAC1+2
	cmp TXTTAB+1
	bcc assign_string_not_text_area
	bne @8
	lda __FAC1+1
	cmp TXTTAB+0
	bcc assign_string_not_text_area
@8:
	; String is located within text area - great, just copy the descriptor

!ifdef CONFIG_MEMORY_MODEL_60K {
	
	; .X already contains #<VARPNT

	ldy #$00
	lda __FAC1+0
	jsr poke_under_roms
	iny
	lda __FAC1+1
	jsr poke_under_roms
	iny
	lda __FAC1+2
	jsr poke_under_roms

} else { ; CONFIG_MEMORY_MODEL_38K || CONFIG_MEMORY_MODEL_46K || CONFIG_MEMORY_MODEL_50K

	ldy #$00
	lda __FAC1+0
	sta (VARPNT), y
	iny
	lda __FAC1+1
	sta (VARPNT), y
	iny
	lda __FAC1+2
	sta (VARPNT), y
}

	rts

assign_string_not_text_area:

	; Check if the old string belongs to the string area (is above FRETOP)

	jsr helper_cmp_fretop

!ifdef HAS_SMALL_BASIC {
	bcc assign_string_no_optimizations
} else {
	bcc assign_string_try_takeover
}

	; FALLTROUGH

assign_string_try_reuse:

	; Check if we can reuse old string memory

	lda DSCPNT+0
	cmp __FAC1+0

!ifdef HAS_SMALL_BASIC {

	; If size of both string equals - simply reuse it

	+beq helper_strvarcpy

	; No special case optimization is possible - but first get rid of the old string

	jsr varstr_free

	; FALLTROUGH

} else {

	; If size of both string equals - simply reuse it

	bne assign_string_try_takeover_free
	jmp helper_strvarcpy
}

assign_string_no_optimizations:

	; Allocate memory for the new string

	lda __FAC1+0
	ldy #$00

!ifdef CONFIG_MEMORY_MODEL_60K {

	ldx #<VARPNT
	jsr poke_under_roms

} else { ; CONFIG_MEMORY_MODEL_38K || CONFIG_MEMORY_MODEL_46K || CONFIG_MEMORY_MODEL_50K
	
	sta (VARPNT), y
}

	jsr varstr_alloc

	; Copy the string and quit

	jmp helper_strvarcpy


!ifndef HAS_SMALL_BASIC {

assign_string_try_takeover_free:

	jsr varstr_free

	; FALLTROUGH

assign_string_try_takeover:

	; Check if the new string is a temporary one - if so, takeover the allocation

	ldx #$19

	; FALLTROUGH

assign_string_tmp_check_loop:

	cpx TEMPPT
	beq assign_string_no_optimizations ; branch if this is not a temporary string

	lda $01, x
	cmp __FAC1+1
	bne assign_string_tmp_check_next

	lda $02, x
	cmp __FAC1+2
	bne assign_string_tmp_check_next

	lda $01, x
	beq assign_string_tmp_check_next

	; This is a temporary string - takeover the content

!ifdef CONFIG_MEMORY_MODEL_60K {

	ldy #$00
	+phx_trash_a
	lda $00, x
	ldx #<VARPNT
	jsr poke_under_roms
	+plx_trash_a

	iny
	+phx_trash_a
	lda $01, x
	sta INDEX+0
	ldx #<VARPNT
	jsr poke_under_roms
	+plx_trash_a
	
	iny
	+phx_trash_a
	lda $02, x
	sta INDEX+1
	ldx #<VARPNT
	jsr poke_under_roms
	+plx_trash_a

} else {

	ldy #$00
	lda $00, x
	sta (VARPNT), y

	iny
	lda $01, x
	sta INDEX+0
	sta (VARPNT), y

	iny
	lda $02, x
	sta INDEX+1
	sta (VARPNT), y
}

	; Mark the temporary string as free

	lda #$00
	sta $00, x

	; Now we need to copy VARPNT to back-pointer

	lda __FAC1+0
	jsr helper_INDEX_up_A

!ifdef CONFIG_MEMORY_MODEL_60K {

	ldx #<INDEX

	ldy #$00
	lda VARPNT+0
	jsr poke_under_roms

	iny
	lda VARPNT+1
	jsr poke_under_roms

} else {

	ldy #$00
	lda VARPNT+0
	sta (INDEX), y

	iny
	lda VARPNT+1
	sta (INDEX), y
}

	rts

assign_string_tmp_check_next:

	inx
	inx
	inx
	bne assign_string_tmp_check_loop           ; branch always
}
