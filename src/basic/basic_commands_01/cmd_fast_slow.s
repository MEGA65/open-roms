// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE


#if CONFIG_MB_MEGA_65

	// Command implementation for Mega65

	// XXX - I think there are some bit-set instructions in 65CE02...

cmd_slow:

	lda #$40
	skip_2_bytes_trash_nvz

	// FALLTROUGH

cmd_fast:

	lda #$41
	sta CPU_D6510
	rts


#elif CONFIG_MB_ULTIMATE_64

	// Command implementation for Ultimate 64 - SuperCPU compatible way should be enough

cmd_slow:

	sta SCPU_SPEED_NORMAL
	rts

cmd_fast:

	sta SCPU_SPEED_TURBO
	rts

#elif CONFIG_PLATFORM_COMMODORE_64

	// Command implementation for generic C64 platform

cmd_slow:

	// Try to disable turbo in SuperCPU compatible way
	sta SCPU_SPEED_NORMAL

	// Try to disable turbo mode in C128 compatible way

	lda #$00
	beq !+                                       // branch always

cmd_fast:

	// Try to enable turbo in SuperCPU compatible way
	sta SCPU_SPEED_TURBO

	// Try to enable turbo mode in C128 compatible way
	lda #$01
!:
	sta VIC_CLKRATE
	rts

#else

cmd_slow:

	nop                                          // just to prevent double label

	// FALLTROUGH

cmd_fast:

	jmp do_NOT_IMPLEMENTED_error

#endif
