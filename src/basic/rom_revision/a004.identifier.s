;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# X16 BASIC_0 #TAKE-OFFSET 2000
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE


; Computes Mapping the 64, p89 - 8 character name

!ifdef CONFIG_MB_M65 {

	; 'M65BASIC'

	!byte $4D, $36, $35                ; 'M65'

} else {

	; 'ORGBASIC', Open ROMs Generic BASIC

	!byte $4F, $52, $47                ; 'ORG'
}

	!byte $42, $41, $53, $49, $43      ; 'BASIC'
