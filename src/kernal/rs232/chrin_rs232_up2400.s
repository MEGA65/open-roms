;; #LAYOUT# STD *        #TAKE
;; #LAYOUT# *   KERNAL_0 #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; RS-232 part of the CHRIN routine
;


!ifdef CONFIG_RS232_UP2400 {


chrin_rs232:
	+STUB_IMPLEMENTATION     ; XXX provide implementation for both UP2400 and UP9600


} ; CONFIG_RS232_UP2400
