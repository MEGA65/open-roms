;; #LAYOUT# STD *        #TAKE
;; #LAYOUT# *   KERNAL_0 #TAKE
;; #LAYOUT# *   *        #IGNORE

; Output character to channel
; C64 Programmers Reference Guide Page 272
; According to Computes Mapping the Commodore 64 (pages 74/75), this jump is indirect

	jmp (IBSOUT)
