;; #LAYOUT# STD *        #TAKE
;; #LAYOUT# X16 *        #IGNORE
;; #LAYOUT# *   KERNAL_0 #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; Official Kernal routine, described in:
;
; - [RG64] C64 Programmers Reference Guide   - page 295
; - [CM64] Computes Mapping the Commodore 64 - page 220
;
; CPU registers that has to be preserved (see [RG64]): none
;

; Variables used:
; - KEYTAB  - keyboard matrix pointer
; - DELAY   - counter for first delay between key repeats
; - KOUNT   - counter for next delays between key repeats
; - SHFLAG  - SHIFT / CTRL / VENDOR keypress status
; - NDX     - number of characters in keyboard buffer
; - XMAX    - maximum size of keyboard buffer
; - LSTX    - matrix coordinate of last pressed key
; - LSTSHF  - previous status of SHFLAG
; - MODE    - flag, whether charset toggle (SHIFT+VENDOR) is allowed
; - RPTFLG  - whether key repeat is allowed



!ifndef CONFIG_LEGACY_SCNKEY {

; Routine takes some ideas from TWW/CTR proposal, see here:
; - http://codebase64.org/doku.php?id=base:scanning_the_keyboard_the_correct_and_non_kernal_way


SCNKEY:

!ifdef CONFIG_MB_M65 { !ifdef CONFIG_M65_KB_DEV {

	jsr M65_MODEGET
	+bcc m65_scnkey
} }

	; Prepare for SHFLAG update

	lda SHFLAG
	sta LSTSHF
	lda #$00
	sta SHFLAG

!ifndef CONFIG_JOY2_CURSOR { !ifdef CONFIG_KEY_FAST_SCAN {

	; Check for any activity - speed optimization, but cannot be done
	; that early if we are to scan the joystick #2

	ldx #$00
	stx CIA1_PRA                       ; connect all the rows
!ifdef CONFIG_KEYBOARD_C128 {
	stx VIC_XSCAN
}
	dex                                ; puts $FF
	cpx CIA1_PRB
	beq scnkey_no_keys

} }

	; Retrieve SHIFT / VENDOR / CTRL / ALT / CAPS LOCK status

!ifdef CONFIG_KEYBOARD_C128_CAPS_LOCK {

	; First check if this is really a C128 - to avoid false positive
	ldx #$00
	stx VIC_XSCAN
	dex                                ; puts $FF
	cpx VIC_XSCAN
	beq @1                             ; branch if C64, C128 will keep some bits cleared

	lda CPU_R6510
	and #$40
	bne @1                             ; branch if no CAPS LOCK

	lda #KEY_FLAG_CAPSL
	sta SHFLAG
@1:

!ifndef !CONFIG_KEYBOARD_C128 {
	stx VIC_XSCAN                      ; disconnect C128 keys if no C128 keyboard is supported
} }

	ldy #(__kb_matrix_bucky_confmask_end - kb_matrix_bucky_confmask - 1)
scnkey_bucky_loop:
	lda kb_matrix_bucky_confmask, y
	sta CIA1_PRA
!ifdef CONFIG_KEYBOARD_C128 {
	lda kb_matrix_bucky_confmask_c128, y
	sta VIC_XSCAN
}
	lda kb_matrix_bucky_testmask, y
	and CIA1_PRB
	bne @3                             ; branch if not pressed
	lda SHFLAG
	ora kb_matrix_bucky_shflag, y
	sta SHFLAG
@3:
	dey
	bpl scnkey_bucky_loop

	; Set KEYTAB vector

	lda KEYLOG+1
	bne @11
	jsr scnkey_set_keytab              ; KEYLOG routine on zeropage? most likely vector not set
	+bra scnkey_keytab_set_done

@11:
!ifdef HAS_OPCODES_65CE02 {
	jsr (KEYLOG)
} else {
	jsr scnkey_via_keylog
}

scnkey_keytab_set_done:

!ifdef CONFIG_JOY2_CURSOR {

	; Check for control port 2 activity

	ldx #$00
	stx CIA1_DDRA                      ; set port to input to read joystick

	lda CIA1_PRA                       ; read the joystick 2 status

	dex                                ; puts $FF
	stx CIA1_DDRA                      ; set port back to output

	and #%00001111                     ; filter out anything but joystick movement
	cmp #%00001111

	bne scnkey_joystick_filtered

!ifdef CONFIG_KEY_FAST_SCAN {

	inx                                ; puts $00
	stx CIA1_PRA                       ; connect all the rows
!ifdef CONFIG_KEYBOARD_C128 {
	stx VIC_XSCAN
}
	dex                                ; puts $FF
	cpx CIA1_PRB
	beq scnkey_no_keys

} ; CONFIG_KEY_FAST_SCAN
} ; CONFIG_JOY2_CURSOR

	; Check for control port 1 activity (can interfere with keyboard)

	jsr keyboard_disconnect            ; disconnect all the rows, .X will be $FF
	cpx CIA1_PRB                       ; only control port activity will be reported
!ifdef CONFIG_JOY1_CURSOR {
	bne scnkey_joystick_1              ; use joystick for cursor keys
} else {
	bne scnkey_no_keys                 ; if activity detected do not scan the keyboard
}

	; Check if KEYTAB is not 0 (happens if more than one bucky key is pressed)
	; High byte equal to 0 = table considered invalid
	
	lda KEYTAB+1
	beq scnkey_no_keys

	; Scan the keyboard matrix

	ldy #$FF                           ; offset in key matrix table, $FF for not found yet
!ifdef CONFIG_KEYBOARD_C128 {
	jsr scnkey_128
}
	ldx #$07
scnkey_matrix_loop:
	lda kb_matrix_row_keys, x
	sta CIA1_PRA
	lda kb_matrix_bucky_filter, x      ; filter out bucky keys
	ora CIA1_PRB
	cmp #$FF
	beq scnkey_matrix_loop_next        ; skip if no key pressed from this row
	cpy #$FF
	bne scnkey_no_keys                 ; jam, more than one key pressed
	; We have at least one key pressed in this row, we need to find which one exactly
	ldy #$07
scnkey_matrix_loop_inner:
	cmp kb_matrix_row_keys, y
	bne @4                             ; not this particular key
	tya                                ; now .A contains key offset within a row
	clc
	adc kb_matrix_row_offsets, x       ; now .A contains key offset from the matrix start
	tay
	jmp scnkey_matrix_loop_next
@4:
	dey
	bpl scnkey_matrix_loop_inner
	bmi scnkey_no_keys                 ; branch always, multiple keys must have been pressed
scnkey_matrix_loop_next:
	dex
	bpl scnkey_matrix_loop

	; Scanning complete - check if we got a key

	cpy #$FF
	beq scnkey_no_keys

	; To be extra sure, check for possible control port 1 interference once again

	jsr keyboard_disconnect            ; disconnect all the rows, .X will be $FF
	cpx CIA1_PRB                       ; only control port activity will be reported
	beq scnkey_got_key                 ; branch if joystick activity NOT detected

	; FALLTROUGH

scnkey_no_keys:

	; Mark no key press

	lda #$40
	sta LSTX
	rts

!ifdef CONFIG_JOY1_CURSOR {

scnkey_joystick_1:

	; Prepare joystick 1 status

	lda CIA1_PRB
	and #%00001111                     ; filter out anything but movement

	; FALLTROUGH
}

!ifdef CONFIG_JOY1_OR_JOY2_CURSOR {

scnkey_joystick_filtered:

	; Set appropriate keyboard matrix and key code for joystick event

	ldy #$03
@5:
	cmp kb_matrix_joy_status, y
	beq @6 
	dey
	bpl @5

	; Not found

	rts
@6:
	; Found

	lda kb_matrix_joy_keytab_lo, y
	sta KEYTAB+0
	lda kb_matrix_joy_keytab_hi, y
	sta KEYTAB+1
	lda kb_matrix_joy_keytab_idx, y
	tay
	
	; FALLTROUGH
}

scnkey_got_key: ; .Y should now contain the key offset in matrix pointed by KEYTAB

	cpy LSTX
	beq scnkey_try_repeat              ; branch if the same key as previously
	sty LSTX

	; Reset key repeat counters - see [CM64] page 58

	; Note: according to [CM64] it should be $10 for initializing DELAY, $06 for
	; initializing KOUNT for the first time and $04 for subsequent ones - but replicating
	; this would make our implementation longer, probably without improving the compatibility.
	;
	; Besides - since I am the one who writes the code, I will make the values exactly how I like them :D

!ifndef CONFIG_RS232_UP9600 {
	lda #$16
} else {
	lda #$18
}
	sta DELAY

	; FALLTROUGH

scnkey_output_key:

	; Check if we have free space in the keyboard buffer

	lda NDX
	cmp XMAX
	bcs scnkey_buffer_full             ; no space in buffer

	; Reinitialize secondary counter

	lda #$03
	sta KOUNT

	; Retrieve the PETSCII code

!ifdef CONFIG_KEYBOARD_C128 {

	cpy #$40
	bcc scnkey_output_get_keycode

	lda kb_matrix_128 - $41, y         ; retrieve key code from C128 extended matrix
	jmp scnkey_got_petscii

	; FALLTROUGH

scnkey_output_get_keycode:

	lda (KEYTAB), y	                   ; retrieve key code from standard matrix

} ; CONFIG_KEYBOARD_C128

!ifdef CONFIG_KEYBOARD_C128_CAPS_LOCK {

	; Check if we need special handling for a CAPS LOCK key
	; This is shorter than a separate set of tables

scnkey_handle_caps_lock:

!ifndef CONFIG_KEYBOARD_C128 {
	lda (KEYTAB), y
}
	tax 
	lda SHFLAG
	and #(%00000111 + KEY_FLAG_CAPSL)
	cmp #KEY_FLAG_CAPSL
	bne @7                             ; branch if no special CAPS LOCK handling needed

	cpx #$41                           ; 'A'
	bcc @7
	cpx #$5B                           ; 'Z' + 1
	bcs @7

	txa
	clc
	adc #$20                           ; turn lowercase into uppercase
	tax 
@7:
	txa

} ; CONFIG_KEYBOARD_C128_CAPS_LOCK

!ifndef CONFIG_KEYBOARD_C128 { !ifndef CONFIG_KEYBOARD_C128_CAPS_LOCK {

	lda (KEYTAB), y
} }

	; Output PETSCII code to the keyboard buffer

scnkey_got_petscii:

	beq scnkey_no_keys                 ; branch if we have no PETSCII code for this key
	ldy NDX
	sta KEYD, y
	inc NDX

	; FALLTROUGH

scnkey_done:

	rts

scnkey_try_repeat:

!ifndef CONFIG_KEY_REPEAT_ALWAYS {

	; Check whether we should repeat keys - first the flag, afterwards hardcoded list

	lda RPTFLG
	bmi scnkey_handle_repeat           ; branch if we should repeat always

	tya
	ldx #(__kb_matrix_alwaysrepeat_end - kb_matrix_alwaysrepeat - 1)
@9:
	cmp kb_matrix_alwaysrepeat, x
	beq scnkey_handle_repeat
	dex
	bpl @9
	bmi scnkey_done

scnkey_handle_repeat:

} ; no CONFIG_KEY_REPEAT_ALWAYS

	; Countdown before first repeat

	lda DELAY
	beq @10
	dec DELAY

	rts
@10:
	; Countdown before subsequent repeats

	lda KOUNT
	beq scnkey_output_key               ; if second counter is also 0, we can repeat the key
	dec KOUNT

	rts

scnkey_buffer_full:

	; Keyboard buffer was full - at least make sure the key
	; will be repeated as soon as possible

	lda #$00
	sta DELAY
	sta KOUNT

	rts

} ; no CONFIG_LEGACY_SCNKEY
