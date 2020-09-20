;; #LAYOUT# STD *        #TAKE
;; #LAYOUT# *   KERNAL_0 #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; Official Kernal routine, described in:
;
; - [RG64] C64 Programmers Reference Guide   - page 280
; - [CM64] Computes Mapping the Commodore 64 - page 242
;
; CPU registers that has to be preserved (see [RG64]): none
;

CINT:

	jsr cint_legacy
	jmp setup_pal_ntsc
