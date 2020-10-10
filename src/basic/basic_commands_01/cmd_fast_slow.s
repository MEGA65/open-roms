;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE


!ifdef CONFIG_MB_M65 {

; NOTE: In native mode the system should not run at 1 MHz speed - it's dangerous,
;       as it uses compound instructions, which are not safe in 1MHz mode

cmd_slow: ; set CPU speed to 1 MHz

	jsr helper_ensure_legacy_mode

	lda #$40
	bra cmd_slow_fast_common

	; FALLTROUGH

cmd_fast: ; set CPU speed to 40 MHz

	jsr helper_ensure_legacy_mode

	lda #$41

	; FALLTROUGH

cmd_slow_fast_common:

	sta CPU_D6510
	rts


	; For MEGA65 Kernal routines are called directly

} else ifdef CONFIG_MB_U64 {

	; Command implementation for Ultimate 64

cmd_slow:

	lda #$00                           ; for U64_TURBOCTL - badlines, 1MHz
	sta SCPU_SPEED_NORMAL              ; any value will do

	; FALLTROUGH

cmd_slow_fast_common:

	sta U64_TURBOCTL
	rts

cmd_fast:

	lda #$0F                           ; for U64_TURBOCTL - badlines, 48MHz
	sta SCPU_SPEED_TURBO               ; any value will do

	bne cmd_slow_fast_common           ; branch always

} else ifdef CONFIG_PLATFORM_COMMODORE_64 {

	; Command implementation for generic C64 platform

cmd_slow:

	; Try to disable turbo in SuperCPU compatible way
	sta SCPU_SPEED_NORMAL

	; Try to disable turbo mode in C128 compatible way

	lda #$00
	beq cmdfastslow_end                ; branch always

cmd_fast:

	; Try to enable turbo in SuperCPU compatible way
	sta SCPU_SPEED_TURBO

	; Try to enable turbo mode in C128 compatible way
	lda #$01
	
	; FALLTROUGH

cmdfastslow_end:
	
	sta VIC_CLKRATE
	rts

} else {

cmd_slow:

	nop                                          ; just to prevent double label

	; FALLTROUGH

cmd_fast:

	jmp do_NOT_IMPLEMENTED_error
}
