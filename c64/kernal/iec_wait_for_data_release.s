
iec_wait_for_data_release:
	lda CI2PRA
	;; Check the highest bit, which is DATA IN,
	;; (highest bit set = negative value)
	bpl iec_wait_for_data_release
	rts
