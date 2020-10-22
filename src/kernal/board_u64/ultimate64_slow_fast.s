;; #LAYOUT# STD *        #TAKE
;; #LAYOUT# *   KERNAL_0 #TAKE
;; #LAYOUT# *   *        #IGNORE


!ifdef CONFIG_MB_U64 {

U64_SLOW:

	lda #$00                           ; for U64_TURBOCTL - badlines, 1MHz

	+skip_2_bytes_trash_nvz

	; FALLTROUGH

U64_FAST:

	lda #$0F                           ; for U64_TURBOCTL - badlines, 48MHz
	sta SCPU_SPEED_TURBO               ; any value will do

	rts
}
