;; #LAYOUT# STD *        #TAKE
;; #LAYOUT# *   KERNAL_0 #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; RS-232 part of the CHROUT routine
;


!ifdef HAS_RS232 {


chrout_rs232:
	+STUB_IMPLEMENTATION     ; XXX provide implementation for both UP2400 and UP9600


} ; HAS_RS232
