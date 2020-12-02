;; #LAYOUT# M65 KERNAL_C #TAKE
;; #LAYOUT# *   *        #IGNORE


m65_scnkey_init_keylog:

	lda #<m65_scnkey_set_keytab
	sta KEYLOG+0
	lda #>m65_scnkey_set_keytab
	sta KEYLOG+1

	rts
