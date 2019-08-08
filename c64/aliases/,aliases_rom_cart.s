
	;; Cartridge ROM locations
	.alias ICART_COLD_START    $8000 ; $8000-$8001, cartridge cold start vector
	.alias ICART_WARM_START    $8002 ; $8002-$8003, cartridge warm start vector (RESTORE key)
	.alias CART_SIG            $8004 ; 5 bytes, signature for cartridge detection
