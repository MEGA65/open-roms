	;; Skip the gap between $C000-$DFFF
	.checkpc $C000
	.advance $2000,$00
	.checkpc $E000
