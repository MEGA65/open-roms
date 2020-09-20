;; #LAYOUT# STD *        #TAKE
;; #LAYOUT# *   KERNAL_0 #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; IEC part of the CHKIN routine
;


!ifdef CONFIG_IEC {


chkin_iec:

	; Fail if the file is open for writing (secondary address 1)
	
	lda LAT, Y
	cmp #$01
	+beq chkin_file_not_input

	; Send TALK + TKSA first
	lda FAT,Y

	jsr TALK
	+bcs chkinout_device_not_present

	lda LAT, Y
	ora #$60
	jsr TKSA
	+bcs chkinout_device_not_present

	jmp chkin_set_device

} ; CONFIG_IEC
