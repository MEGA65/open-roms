;; #LAYOUT# STD *        #TAKE
;; #LAYOUT# X16 *        #IGNORE
;; #LAYOUT# *   KERNAL_0 #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; Matrix ids of keys which should be repeated regardless of RPTFLG
;
; Values based on:
; - [CM64] Computes Mapping the Commodore 64 - page 58
;


!ifndef CONFIG_KEY_REPEAT_ALWAYS {


kb_matrix_alwaysrepeat:

	!byte $3C ; SPACE
	!byte $02 ; CRSR LEFT/RIGHT
	!byte $07 ; CRSR UP/DOWN	
	!byte $00 ; INS/DEL

__kb_matrix_alwaysrepeat_end:


}
