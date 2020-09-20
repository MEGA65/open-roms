;; #LAYOUT# STD *        #TAKE
;; #LAYOUT# *   KERNAL_0 #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; LOAD routine hook for fast loading via UltiDOS
;


u64_load:

	; First check whether the command interface is enabled
	lda U64_IDENTIFICATION
	cmp #U64_MAGIC_ID
	beq !+

u64_load_skip:
	rts
!:
	; XXX find out which device number softIEC is mapped to
	lda current_device_number
	cmp #$20 ; for now use device number 32
	bne u64_load_skip

	; Takeover the flow completely
	pla
	pla

	; Display SEARCHING FOR + filename
	jsr lvs_display_searching_for

	; Whatever the interface was doing - ask to abort it
	jsr u64_load_abort

	; Send a command to open the file
	lda #U64_DOS_CMD_OPEN_FILE
	jsr u64_load_send_cmd
	lda #U64_FA_READ
	jsr u64_load_send_cmd
	jsr u64_load_send_filename
	jsr u64_load_finalize_cmd

	; Check status
	jsr u64_load_check_status
	bcs lvs_file_not_found_error

	; Load first two bytes to determine start address

	; XXX

	jsr printf
	.text "DBG: NOT IMPLEMENTED"
	.byte $0D,0

	jmp lvs_wrap_around_error
	rts

u64_load_abort:
	lda #U64_CTRL_BIT_ABORT
	sta U64_CONTROL
!:
	lda U64_STATUS
	bne !-
	rts

u64_load_send_cmd:

	ldx #U64_TARGET_DOS2
	stx U64_COMMAND_DATA ; target
	sta U64_COMMAND_DATA ; command code
	rts

u64_load_send_filename:
	ldy #0
u64_load_send_filename_loop:
	cpy FNLEN
	bne !+
	rts
!:
	ldx #<current_filename_ptr
	jsr peek_under_roms
	iny

	sta U64_COMMAND_DATA
	jmp u64_load_send_filename_loop

u64_load_finalize_cmd:
	; Push the command for execution
	lda #U64_CTRL_BIT_PUSH_CMD
	sta U64_CONTROL
	; Wait till it is complete
!:
	lda U64_STATUS
	and #U64_STAT_BIT_CMD_BUSY
	bne !-
	rts

u64_load_check_status:
	; Wait till status is available
	lda U64_STATUS
	and #U64_STAT_BIT_STAT_AV
	beq u64_load_check_status

	; Status is ready - check the first character
	lda U64_STATUS_DATA
	jsr JCHROUT ; XXX for test only
	cmp #$30 ; '0'
	bne u64_load_check_status_wrong

	; Check the second status character
	lda U64_STATUS
	and #U64_STAT_BIT_STAT_AV
	beq u64_load_check_status_ok
	lda U64_STATUS_DATA
	jsr JCHROUT ; XXX for test only
	cmp #$30 ; '0'
	beq u64_load_check_status_ok

	; FALLTROUGH
u64_load_check_status_wrong:
	sec
	bcs !+
u64_load_check_status_ok:
	clc
!:
	; Now empty the status queue
	lda U64_STATUS
	and #U64_STAT_BIT_STAT_AV
	beq !+
	lda U64_STATUS_DATA
	jsr JCHROUT ; XXX for test only
	jmp !-
!:
	rts
