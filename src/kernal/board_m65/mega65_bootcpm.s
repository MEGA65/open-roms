;; #LAYOUT# M65 KERNAL_0 #TAKE
;; #LAYOUT# *   *        #IGNORE


BOOTCPM:

	jsr CLALL
	clc
	jsr M65_MODESET

	jsr viciv_init           ; do it now, later it will not be safe anymore
	lda #$01
	jsr M65_SCRMODESET

	jsr map_ZVM_1
	jmp ($2000)
