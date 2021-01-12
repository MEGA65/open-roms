;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# CRT BASIC_1 #TAKE
;; #LAYOUT# M65 BASIC_1 #TAKE
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE


!ifdef CONFIG_DOS_WEDGE {


!ifdef SEGMENT_M65_BASIC_0 {

wedge_dos_monitor:                               ; entry point for the MONITOR

	jsr m65_shadow_BZP
	jsr map_BASIC_1
	jsr (VB1__wedge_dos_monitor)
	jsr m65_shadow_BZP
	jmp map_MON_1

} else ifdef SEGMENT_M65_BASIC_1 {

wedge_dos_monitor:

	tsx
	stx __wedge_spstore                          ; preserve stack pointer

	lda #$FF                                     ; mark MONITOR-called wedge
	bra wedge_dos_monitor_cont
}

; .X has to contain size of the buffer

wedge_dos:

!ifdef SEGMENT_M65_BASIC_0 {

	jsr map_BASIC_1
	jsr (VB1__wedge_dos)
	jmp map_NORMAL

} else ifdef SEGMENT_CRT_BASIC_0 {

	jsr map_BASIC_1
	jsr JB1__wedge_dos
	jmp map_NORMAL

} else {

	; Prepare buffer - finish it with '0'
	lda #$00
	sta BUF,x

!ifdef CONFIG_MB_M65 {

wedge_dos_monitor_cont:

	sta __wedge_mon                              ; mark BASIC/MONITOR-called wedge
}

	; Close all the channels, so that wedge has full control
	jsr JCLALL

	; Set file parameters, channel 15 is a typical one for commands
	jsr SELDEV                                   ; sets .X register
	lda #$0F
	ldy #$0F
	jsr JSETFLS

	; Setup necessary part of BASIC

	jsr prepare_direct_execution
	jsr fetch_character

	; Now we have to check what the user wants us to do

	; Check if user asked for a status

	ldy #$00
	lda (TXTPTR), y
	+beq wedge_dos_status

	; Check if asked for a directory

	cmp #$24
	+beq wedge_dos_directory

	; Check if asked to change drive number, or if it is a regular command
	
	jsr is_09
	bcc wedge_dos_change_drive
	
	; FALLTROUGH

wedge_dos_command:

!ifndef HAS_SMALL_BASIC {

	; Check if command needs confirmation

	ldy #$00
	lda (TXTPTR), y

	cmp #$52                                     ; 'R' - because 'RD' is a directory removal command
	bne @1

	iny
	lda (TXTPTR), y
	cmp #$44                                     ; 'D'
	bne wedge_dos_command_confirmed
	beq wedge_dos_command_ask
@1:
	cmp #$4E                                     ; 'N' - for the disk format
	beq @2
	cmp #$53                                     ; 'S' - for the file scratch
	bne wedge_dos_command_confirmed
@2:
	; This is probably a dangerous command - check further the syntax,
	; if 'N:', 'S:', 'Nx:' or 'Sx:' (where 'x' is a digit) - ask for confirmation first

	iny
	lda (TXTPTR), y
	cmp #$3A                                     ; ':' - colon
	beq wedge_dos_command_ask

	jsr is_09
	bcs wedge_dos_command_confirmed

	iny
	lda (TXTPTR), y
	cmp #$3A                                     ; ':' - colon
	bne wedge_dos_command_confirmed

	; FALLTROUGH

wedge_dos_command_ask:

	jsr helper_ask_if_sure
	+bcs wedge_dos_clean_exit
	
	; FALLTROUGH

wedge_dos_command_confirmed:

} ; !HAS_SMALL_BASIC

	; Provide command name

	jsr wedge_dos_setnam
	
	jsr JSETNAM
	jsr JOPEN
	+bcs wedge_dos_basic_error

	; Retrieve status, print it if not OK

	jsr JCLALL
	jsr wedge_dos_status_get_no_new_line

	lda BUF+0
	cmp #$30 ; '0'
	bne wedge_dos_status_print

	eor BUF+1
	bne wedge_dos_status_print

	; Clean-up and exit

	jmp wedge_dos_clean_exit

wedge_dos_change_drive:

	; Fetch new drive number, make sure it is sane

	jsr fetch_uint8
	cmp #$08
!ifdef CONFIG_MB_M65 {
	+bcc wedge_dos_wrapper_ILLEGAL_DEVICE_NUMBER_error
} else {
	+bcc do_ILLEGAL_DEVICE_NUMBER_error
}

	; Check if this is end of command, or directory request

	pha
	jsr fetch_character_skip_spaces
	cmp #$24
	beq wedge_dos_change_drive_directory

	; Make sure this is end of command

	cmp #$00
!ifdef CONFIG_MB_M65 {
	+bne wedge_dos_wrapper_SYNTAX_error
} else {
	+bne do_SYNTAX_error
}
	; Store new device number and return to shell

	pla
	sta FA
	jmp shell_main_loop

wedge_dos_status_get:

	; New line - separate status from current display

	jsr print_return

	; FALLTROUGH

wedge_dos_status_get_no_new_line:

	; Here the flow is mostly the same as in the example from
	; https://codebase64.org/doku.php?id=base:reading_the_error_channel_of_a_disk_drive

	; Set remaining file parameters, open the channel

	lda #$00  ; empty file name
	jsr JSETNAM
	jsr JOPEN
	+bcs wedge_dos_basic_error

	; Set channel for input

	ldx #$0F
	jsr JCHKIN
	+bcs wedge_dos_basic_error

	; Fetch the drive status

	ldy #$00

	; FALLTROUGH

wedge_dos_status_get_loop:

	; Check for buffer overflow

	cpy #$50
!ifdef CONFIG_MB_M65 {
	+beq wedge_dos_wrapper_OVERFLOW_error
} else {
	+beq do_OVERFLOW_error
}
	; Check for EOF

	jsr JREADST
	; XXX check for transfer errors
	bne wedge_dos_status_get_done

	; Retrieve a byte and put it into the buffer

	jsr JCHRIN
	+bcs wedge_dos_basic_error

	sta BUF, y
	iny

	bne wedge_dos_status_get_loop                ; branch always

wedge_dos_status_get_done:

	; Strip ending RETURN

	dey
	rts

wedge_dos_status:

	jsr wedge_dos_status_get
	+bra wedge_dos_status_print_no_new_line

wedge_dos_status_print:

	jsr print_return

	; FALLTROUGH

wedge_dos_status_print_no_new_line:

	; Print buffered status

	ldx #$00
@3:
	dey
	bmi @4
	lda BUF, x
	jsr JCHROUT
	inx
	bne @3
@4:
	; Clean-up and exit

	+bra wedge_dos_clean_exit

wedge_dos_change_drive_directory:

	; Store new device number, display directory

	pla
	sta FA

	dec TXTPTR+0                                 ; in direct mode we do not have to care about TXTPTR+1

	; FALLTROUGH

wedge_dos_directory:

	; First change the secondary address to the one suitable for directory loading

	lda #$00                                     ; logical device number
	ldx FA
	ldy #$60
	jsr JSETFLS

	; Provide file name

	jsr wedge_dos_setnam

	; Open the file, set channel for reading

	jsr JOPEN
	bcs wedge_dos_basic_error

	ldx #$00
	jsr JCHKIN
	bcs wedge_dos_basic_error

	; Ignore start address (2 first bytes) - XXX check for errors

	jsr JCHRIN
	bcs wedge_dos_basic_error
	jsr JCHRIN
	bcs wedge_dos_basic_error

	; FALLTROUGH

wedge_dos_directory_line:

	; Load a single line, reuse BASIC input buffer

	ldy #$FF
@5:
	iny
	jsr JCHRIN
	bcs wedge_dos_basic_error
	sta BUF, y
	cpy #$50                                   ; make sure line is not too long
!ifdef CONFIG_MB_M65 {
	+beq wedge_dos_wrapper_OVERFLOW_error
} else {
	+beq do_OVERFLOW_error
}
	jsr JREADST
	bne @6 ; end of file
	cpy #$04 ; 2 bytes (pointer to next line) + 2 bytes (line number) 
	bcc @5
	lda BUF, y
	bne @5

	; End of line, but not end of file

	beq wedge_dos_directory_display
@6:
	lda #K_STS_END_OF_FILE
	sta IOSTATUS ; make sure end of file is marked

	; FALLTROUGH

wedge_dos_directory_display:

	cpy #$05                                     ; protection against malformed directory
	bcc wedge_dos_clean_exit

	lda #$00                                     ; extra protection agains buffer overflow
	sta BUF, y

	; Display line

	ldx #<BUF
	stx OLDTXT+0
	ldx #>BUF
	stx OLDTXT+1
	ldx #OLDTXT
	jsr list_single_line

	; Read & display next line or quit

	lda IOSTATUS
	beq wedge_dos_directory_line

	; FALLTROUGH

wedge_dos_clean_exit:

	jsr JCLALL
!ifdef CONFIG_MB_M65 {
	jmp wedge_dos_wrapper_exit
} else {
	jmp shell_main_loop
}

wedge_dos_basic_error:

	pha
	jsr JCLALL
	pla
!ifdef CONFIG_MB_M65 {
	bra wedge_dos_wrapper_kernal_error
} else {
	jmp do_kernal_error
}

wedge_dos_setnam:

	; Now determine the length of the 'file' name

	ldy #$FF
@7:
	iny
	lda (TXTPTR), y
	bne @7
	
	; Set the name to open

	tya
	ldx TXTPTR+0
	ldy TXTPTR+1

	jmp JSETNAM

!ifdef CONFIG_MB_M65 {

wedge_dos_wrapper_exit:

	bbr7 __wedge_mon, wedge_dos_clean_exit_basic

	; FALLTROUGH

wedge_dos_wrapper_exit_nocheck:

	ldx __wedge_spstore
	txs
	rts

wedge_dos_wrapper_SYNTAX_error:

	bbr7 __wedge_mon, wedge_dos_SYNTAX_error

	; XXX

wedge_dos_wrapper_ILLEGAL_DEVICE_NUMBER_error:

	bbr7 __wedge_mon, wedge_dos_ILLEGAL_DEVICE_NUMBER_error

	; XXX

wedge_dos_wrapper_OVERFLOW_error:

	bbr7 __wedge_mon, wedge_dos_OVERFLOW_error

	; XXX

wedge_dos_wrapper_kernal_error:

	bbr7 __wedge_mon, wedge_dos_kernal_error

	; XXX

	bra wedge_dos_wrapper_exit_nocheck

wedge_dos_SYNTAX_error:

	jmp do_SYNTAX_error

wedge_dos_ILLEGAL_DEVICE_NUMBER_error:

	jmp do_ILLEGAL_DEVICE_NUMBER_error

wedge_dos_OVERFLOW_error:

	jmp do_OVERFLOW_error

wedge_dos_kernal_error:

	jmp do_kernal_error

wedge_dos_clean_exit_basic:

	jmp shell_main_loop


} ; MEGA65 specific code

} ; ROM layout

} ; CONFIG_DOS_WEDGE
