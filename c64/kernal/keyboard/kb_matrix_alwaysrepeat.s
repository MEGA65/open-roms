
//
// Matrix ids of keys which should be repeated regardless of RPTFLG
//
// Values based on:
// - [CM64] Compute's Mapping the Commodore 64 - page 58
//


#if !CONFIG_LEGACY_SCNKEY && !CONFIG_KEY_REPEAT_ALWAYS


kb_matrix_alwaysrepeat:

	.byte $3C // SPACE
	.byte $02 // CRSR LEFT/RIGHT
	.byte $07 // CRSR UP/DOWN	
	.byte $00 // INS/DEL

__kb_matrix_alwaysrepeat_end:


#endif // no CONFIG_LEGACY_SCNKEY and no CONFIG_KEY_REPEAT_ALWAYS
