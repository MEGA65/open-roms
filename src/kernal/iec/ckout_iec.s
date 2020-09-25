;; #LAYOUT# STD *        #TAKE
;; #LAYOUT# *   KERNAL_0 #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; IEC part of the CKOUT routine
;


!ifdef CONFIG_IEC {


ckout_iec:

	; Fail if the file is open for reading (secondary address 0)
	
	lda LAT, Y
	+beq ckout_file_not_output

	; Send LISTEN + SECOND first
	lda FAT,Y

	jsr LISTEN
	+bcs chkinout_device_not_present

	lda LAT, Y
	ora #$60
	jsr SECOND
	+bcs chkinout_device_not_present

	jmp ckout_set_device


} ; CONFIG_IEC
