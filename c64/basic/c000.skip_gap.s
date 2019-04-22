	;; Skip the gap between $C000-$DFFF
	.checkpc $C000
	.advance $DFFF,$00
	.checkpc $E000
