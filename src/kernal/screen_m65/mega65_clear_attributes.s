// #LAYOUT# M65 KERNAL_1 #TAKE
// #LAYOUT# *   *        #IGNORE


m65_clear_attributes:

	lda COLOR
	and #$0F
	sta COLOR

	rts
