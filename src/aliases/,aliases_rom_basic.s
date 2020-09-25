
	; BASIC startup vectors


!ifdef CONFIG_PLATFORM_COMMANDER_X16 {

	!addr IBASIC_COLD_START  = $C000
	!addr IBASIC_WARM_START  = $C002

} else {

	!addr IBASIC_COLD_START  = $A000
	!addr IBASIC_WARM_START  = $A002
}
