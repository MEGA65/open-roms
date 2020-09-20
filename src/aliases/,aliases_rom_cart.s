
!ifdef CONFIG_PLATFORM_COMMODORE_64 {

	; Cartridge ROM locations

	!addr ICART_COLD_START  = $8000  ; $8000-$8001, cartridge cold start vector
	!addr ICART_WARM_START  = $8002  ; $8002-$8003, cartridge warm start vector (RESTORE key)
	!addr CART_SIG          = $8004  ; $8004-$8008, signature for cartridge detection
}
