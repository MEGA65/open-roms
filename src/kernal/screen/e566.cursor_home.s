;; #LAYOUT# STD *        #TAKE
;; #LAYOUT# X16 *        #IGNORE
;; #LAYOUT# *   KERNAL_0 #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; Home the cursor, described in:
;
; - [CM64] Computes Mapping the Commodore 64 - page 216
;


cursor_home:

	lda #$00
	sta PNTR                           ; current column (logical)
	sta TBLX                           ; current row

	; FALLTROUGH to the next routine
