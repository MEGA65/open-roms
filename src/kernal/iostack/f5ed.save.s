;; #LAYOUT# STD *        #TAKE
;; #LAYOUT# *   KERNAL_0 #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; Official Kernal routine, described in:
;
; - [RG64] C64 Programmers Reference Guide   - page 293/294
; - [CM64] Computes Mapping the Commodore 64 - page 231/232
; - IEC reference at http://www.zimmers.net/anonftp/pub/cbm/programming/serial-bus.pdf
;
; CPU registers that has to be preserved (see [RG64]): none
;

SAVE:

	; Reset status
	jsr kernalstatus_reset

!ifdef CONFIG_MEMORY_MODEL_60K {
	; We need our helpers to get to filenames under ROMs or IO area
	jsr install_ram_routines
}

	; Check whether we support the requested device
	lda FA

!ifdef CONFIG_IEC {
	jsr iec_check_devnum_lvs
	+bcc save_iec
}

	jmp lvs_illegal_device_number 
