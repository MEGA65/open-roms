;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

;
; Default handler for all not-yet-implemented functions
;
; Note: NOPs are here just to make debugging easier (no duplicated labels)!
;


fun_sgn:
	+nop
fun_int:
	+nop
fun_abs:
	+nop
fun_usr:
	+nop
fun_fre:
	+nop
fun_pos:
	+nop
fun_sqr:
	+nop
fun_rnd:
	+nop
fun_log:
	+nop
fun_exp:
	+nop
fun_cos:
	+nop
fun_sin:
	+nop
fun_tan:
	+nop
fun_atn:
	+nop
fun_peek:
	+nop
fun_len:
	+nop
fun_str:
	+nop
fun_val:
	+nop
fun_asc:
	+nop
fun_chr:
	+nop
fun_left:
	+nop
fun_right:
	+nop
fun_mid:
	+nop

	; Unimplemented tokens

	jmp do_NOT_IMPLEMENTED_error
