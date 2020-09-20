;; #LAYOUT# STD *        #TAKE
;; #LAYOUT# *   KERNAL_0 #TAKE
;; #LAYOUT# *   *        #IGNORE

; Scan stop key
; C64 Programmers Reference Guide Page 273
; According to Computes Mapping the Commodore 64 (pages 74/75), this jump is indirect

	jmp (ISTOP)
