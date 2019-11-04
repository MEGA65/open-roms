
//
// Official Kernal routine, described in:
//
// - [RG64] C64 Programmer's Reference Guide   - page 295
// - [CM64] Compute's Mapping the Commodore 64 - page 220
//
// CPU registers that has to be preserved (see [RG64]): none
//

// Variables used:
// - KEYTAB  - keyboard matrix pointer
// - DELAY   - counter for first delay between key repeats
// - KOUNT   - counter for next delays between key repeats
// - SHFLAG  - SHIFT / CTRL / VENDOR keypress status
// - NDX     - number of characters in keyboard buffer
// - XMAX    - maximum size of keyboard buffer
// - LSTX    - matrix coordinate of last pressed key
// - LSTSHF  - previous status of SHFLAG
// - MODE    - flag, whether charset toggle (SHIFT+VENDOR) is allowed
// - RPTFLG  - whether key repeat is allowed



#if !CONFIG_LEGACY_SCNKEY

// Routine takes some ideas from TWW/CTR proposal, see here:
// - http://codebase64.org/doku.php?id=base:scanning_the_keyboard_the_correct_and_non_kernal_way


SCNKEY:

#if CONFIG_KEYBOARD_C65 && CONFIG_MB_MEGA_65

	// Idea by Paul Gardner-Stephen

	lda VIC_XPOS                       // check raster X position
	cmp VIC_XPOS                       // if it changes, we are on a MEGA65 with VIC-IV registers already visible
	bne scnkey_viciv_mode

	// We are on machine that is not in VIC-IV IO mode, so try enabling it (harmless on C64/C65)
	// If we are on a C65 (or MEGA65 with C65 VIC-III IO mode selected), the above test would
	// have failed, but we could already be in C65 IO mode. In that case, this will disable C65 IO
	// mode when done. This is not ideal, but as MEGA65s start C65 mode with VIC-IV IO mode
	// selected anyway, it should not be a big problem in practice.

	lda #$A5
	sta VIC_KEY
	lda #$96
	sta VIC_KEY

	jsr scnkey_viciv_mode

	sta VIC_KEY
	rts

scnkey_viciv_mode:

#endif

	// Prepare for SHFLAG update

	lda SHFLAG
	sta LSTSHF
	lda #$00
	sta SHFLAG

#if !CONFIG_JOY2_CURSOR && CONFIG_KEY_FAST_SCAN

	// Check for any activity - speed optimization, but cannot be done
	// that early if we are to scan the joystick #2

	ldx #$00
	stx CIA1_PRA                       // connect all the rows
#if CONFIG_KEYBOARD_C128
	stx VIC_XSCAN
#endif
	dex                                // puts $FF
	cpx CIA1_PRB
	beq scnkey_no_keys

#endif

	// Retrieve SHIFT / VENDOR / CTRL / ALT / CAPS LOCK status

#if CONFIG_KEYBOARD_C128_CAPS_LOCK

	// First check if this is really a C128 - to avoid false positive
	ldx #$00
	stx VIC_XSCAN
	dex                                // puts $FF
	cpx VIC_XSCAN
	beq !+                             // branch if C64, C128 will keep some bits cleared

	lda CPU_R6510
	and #$40
	bne !+                             // branch if no CAPS LOCK

	lda #KEY_CAPS_LOCK
	sta SHFLAG
!:

#if !CONFIG_KEYBOARD_C128
	stx VIC_XSCAN                      // disconnect C128 keys if no C128 keyboard is supported
#endif

#endif

#if CONFIG_KEYBOARD_C65_CAPS_LOCK

	lda C65_EXTKEYS_PR
	and #$01
	bne !+                             // branch if no CAPS LOCK

	lda #KEY_CAPS_LOCK
	sta SHFLAG
!:

#if !CONFIG_KEYBOARD_C65
	ldx #$FF
	stx C65_EXTKEYS_PR                 // disconnect C128 keys if no C128 keyboard is supported
#endif

#endif

	ldy #(__kb_matrix_bucky_confmask_end - kb_matrix_bucky_confmask - 1)
scnkey_bucky_loop:
	lda kb_matrix_bucky_confmask, y
	sta CIA1_PRA
#if CONFIG_KEYBOARD_C128
	lda kb_matrix_bucky_confmask_c128, y
	sta VIC_XSCAN
#endif
#if CONFIG_KEYBOARD_C65
	lda kb_matrix_bucky_confmask_c65, y
	sta C65_EXTKEYS_PR
#endif
	lda kb_matrix_bucky_testmask, y
	and CIA1_PRB
	bne !+                             // branch if not pressed
	lda SHFLAG
	ora kb_matrix_bucky_shflag, y
	sta SHFLAG
!:
	dey
	bpl scnkey_bucky_loop

	// Set KEYTAB vector

	jsr via_keylog // XXX for some CPUs we have indirect jsr

#if CONFIG_JOY2_CURSOR

	// Check for control port 2 activity

	ldx #$00
	stx CIA1_DDRA                      // set port to input to read joystick

	lda CIA1_PRA                       // read the joystick 2 status

	dex                                // puts $FF
	stx CIA1_DDRA                      // set port back to output

	and #%00001111                     // filter out anything but joystick movement
	cmp #%00001111

	bne scnkey_joystick_filtered

#if CONFIG_KEY_FAST_SCAN

	inx                                // puts $00
	stx CIA1_PRA                       // connect all the rows
#if CONFIG_KEYBOARD_C128
	stx VIC_XSCAN
#endif
#if CONFIG_KEYBOARD_C65
	stx C65_EXTKEYS_PR
#endif
	dex                                // puts $FF
	cpx CIA1_PRB
	beq scnkey_no_keys

#endif // CONFIG_KEY_FAST_SCAN

#endif // CONFIG_JOY2_CURSOR

	// Check for control port 1 activity (can interfere with keyboard)

	jsr keyboard_disconnect            // disconnect all the rows, .X will be $FF
	cpx CIA1_PRB                       // only control port activity will be reported
#if CONFIG_JOY1_CURSOR
	bne scnkey_joystick_1              // use joystick for cursor keys
#else
	bne scnkey_no_keys                 // if activity detected do not scan the keyboard
#endif

	// Check if KEYTAB is not 0 (happens if more than one bucky key is pressed)
	// High byte equal to 0 = table considered invalid
	
	lda KEYTAB+1
	beq scnkey_no_keys

	// Scan the keyboard matrix

	ldy #$FF                           // offset in key matrix table, $FF for not found yet
#if CONFIG_KEYBOARD_C128
	jsr scnkey_128
#endif
#if CONFIG_KEYBOARD_C65
	jsr scnkey_65
#endif
	ldx #$07
scnkey_matrix_loop:
	lda kb_matrix_row_keys, x
	sta CIA1_PRA
	lda kb_matrix_bucky_filter, x      // filter out bucky keys
	ora CIA1_PRB
	cmp #$FF
	beq scnkey_matrix_loop_next        // skip if no key pressed from this row
	cpy #$FF
	bne scnkey_no_keys                 // jam, more than one key pressed
	// We have at least one key pressed in this row, we need to find which one exactly
	ldy #$07
scnkey_matrix_loop_inner:
	cmp kb_matrix_row_keys, y
	bne !+                             // not this particular key
	tya                                // now .A contains key offset within a row
	clc
	adc kb_matrix_row_offsets, x       // now .A contains key offset from the matrix start
	tay
	jmp scnkey_matrix_loop_next
!:
	dey
	bpl scnkey_matrix_loop_inner
	bmi scnkey_no_keys                 // branch always, multiple keys must have been pressed
scnkey_matrix_loop_next:
	dex
	bpl scnkey_matrix_loop

	// Scanning complete - check if we got a key

	cpy #$FF
	beq scnkey_no_keys

	// To be extra sure, check for possible control port 1 interference once again

	jsr keyboard_disconnect            // disconnect all the rows, .X will be $FF
	cpx CIA1_PRB                       // only control port activity will be reported
	beq scnkey_got_key                 // branch if joystick activity NOT detected

	// FALLTROUGH

scnkey_no_keys:

	// Mark no key press

	lda #$40
	sta LSTX
	rts

#if CONFIG_JOY1_CURSOR

scnkey_joystick_1:

	// Prepare joystick 1 status

	lda CIA1_PRB
	and #%00001111                     // filter out anything but movement

	// FALLTROUGH

#endif

#if CONFIG_JOY1_CURSOR || CONFIG_JOY2_CURSOR

scnkey_joystick_filtered:

	// Set appropriate keyboard matrix and key code for joystick event

	ldy #$03
!:
	cmp kb_matrix_joy_status, y
	beq !+ 
	dey
	bpl !-

	// Not found

	rts
!:
	// Found

	lda kb_matrix_joy_keytab_lo, y
	sta KEYTAB+0
	lda kb_matrix_joy_keytab_hi, y
	sta KEYTAB+1
	lda kb_matrix_joy_keytab_idx, y
	tay
	
	// FALLTROUGH

#endif

scnkey_got_key: // .Y should now contain the key offset in matrix pointed by KEYTAB

	cpy LSTX
	beq scnkey_try_repeat              // branch if the same key as previously
	sty LSTX

	// Reset key repeat counters - see [CM64] page 58

	// Note: according to [CM64] it should be $10 for initializing DELAY, $06 for
	// initializing KOUNT for the first time and $04 for subsequent ones - but replicating
	// this would make our implementation longer, probably without improving the compatibility.
	//
	// Besides - since I am the one who writes the code, I will make the values exactly how I like them :D

	lda #$16
	sta DELAY

	// FALLTROUGH

scnkey_output_key:

	// Check if we have free space in the keyboard buffer

	lda NDX
	cmp XMAX
	bcs scnkey_early_repeat            // no space in buffer

	// Reinitialize secondary counter

	lda #$03
	sta KOUNT

	// Retrieve the PETSCII code

#if CONFIG_KEYBOARD_C128 || CONFIG_KEYBOARD_C65

	cpy #$40
	bcc !+

#if CONFIG_KEYBOARD_C128
	lda kb_matrix_128 - $41, y         // retrieve key code from C128 extended matrix
#elif CONFIG_KEYBOARD_C65

	// Select key matrix (normal or shifted) for extended C65 keys

	lda SHFLAG
	and #%00000111 // KEY_FLAG_SHIFT + KEY_FLAG_VENDOR + KEY_FLAG_CTRL
	beq scnkey_output_65_no_shift
	cmp #KEY_FLAG_SHIFT
	// XXX how to behave on VENDOR/CTRL key? Harmonize this with claasic keys behavior
	bne scnkey_no_keys                 // no scanning for this bucky key combination

	lda kb_matrix_65_shifted - $41, y
	jmp scnkey_got_petscii

scnkey_output_65_no_shift:

	lda kb_matrix_65 - $41, y 

#endif
	jmp scnkey_got_petscii
!:
	lda (KEYTAB), y	                   // retrieve key code from standard matrix

#endif // CONFIG_KEYBOARD_C128 or CONFIG_KEYBOARD_C65

#if CONFIG_KEYBOARD_C128_CAPS_LOCK || CONFIG_KEYBOARD_C65_CAPS_LOCK

	// Check if we need special handling for a CAPS LOCK key
	// This is shorter than a separate set of tables

scnkey_handle_caps_lock:

#if !CONFIG_KEYBOARD_C128 && !CONFIG_KEYBOARD_C65
	lda (KEYTAB), y
#endif
	tax 
	lda SHFLAG
	and #(%00000111 + KEY_CAPS_LOCK)
	cmp #KEY_CAPS_LOCK
	bne !+                             // branch if no special CAPS LOCK handling needed

	cpx #$41                           // 'A'
	bcc !+
	cpx #$5B                           // 'Z' + 1
	bcs !+

	txa
	clc
	adc #$20                           // turn lowercase into uppercase
	tax 
!:
	txa

#endif // CONFIG_KEYBOARD_C128_CAPS_LOCK or CONFIG_KEYBOARD_C65_CAPS_LOCK

#if !CONFIG_KEYBOARD_C128 && !CONFIG_KEYBOARD_C128_CAPS_LOCK && !CONFIG_KEYBOARD_C65 && !CONFIG_KEYBOARD_C65_CAPS_LOCK

	lda (KEYTAB), y

#endif

	// Output PETSCII code to the keyboard buffer

scnkey_got_petscii:

#if CONFIG_KEYBOARD_C128 && CONFIG_EDIT_TABULATORS

	// Special handling for SHIFT+TAB; it is easier than creating new matrix

	tax
	cmp #KEY_TAB_FW
	bne !+
	lda SHFLAG
	and #KEY_FLAG_SHIFT
	beq !+
	ldx #KEY_TAB_BW
!:
	txa

#endif // CONFIG_KEYBOARD_C128 and CONFIG_EDIT_TABULATORS

	beq scnkey_no_keys                 // branch if we have no PETSCII code for this key
	ldy NDX
	sta KEYD, y
	inc NDX

	// FALLTROUGH

scnkey_done:

	rts

scnkey_try_repeat:

#if !CONFIG_KEY_REPEAT_ALWAYS

	// Check whether we should repeat keys - first the flag, afterwards hardcoded list

	lda RPTFLG
	bmi scnkey_handle_repeat           // branch if we should repeat always

	tya
	ldx #(__kb_matrix_alwaysrepeat_end - kb_matrix_alwaysrepeat - 1)
!:
	cmp kb_matrix_alwaysrepeat, x
	beq scnkey_handle_repeat
	dex
	bpl !-
	bmi scnkey_done

scnkey_handle_repeat:

#endif // no CONFIG_KEY_REPEAT_ALWAYS

	// Countdown before first repeat

	lda DELAY
	beq !+
	dec DELAY

	rts
!:
	// Countdown before subsequent repeats

	lda KOUNT
	beq scnkey_output_key               // if second counter is also 0, we can repeat the key
	dec KOUNT

	rts

scnkey_early_repeat:

	// Keyboard buffer was full - at least make sure the key
	// will be repeated as soon as possible

	lda #$00
	sta DELAY
	sta KOUNT

	rts

via_keylog:
	jmp (KEYLOG)


#endif // no CONFIG_LEGACY_SCNKEY
