
; Helper routines for low-level disk operations


lowlevel_fd_ensure_presence_refresh:

	jsr lowlevel_fd_wait_clr_BUSY     ; to be extra sure

	; XXX stepping head is definitely needed, but probably still not enough

	; lda #%00011000                     ; step head 1 track in (XXX: check if it is really in)
	; sta FDC_COMMAND  ; $D081
	; jsr lowlevel_fd_wait_clr_BUSY

	; lda #%00010000                     ; step head 1 track out (XXX: check if it is really out)
	; sta FDC_COMMAND  ; $D081
	; jsr lowlevel_fd_wait_clr_BUSY

	; FALLTROUGH

lowlevel_fd_ensure_presence:

	lda FDC_STATUS_B ; $D083           ; check if disk is inserted
	and #$08
	beq @not_present
	rts

@not_present:

	pla
	pla

	jsr lowlevel_fd_motor_off          ; if disk not present, disable drive motor

	; XXX set error code, invalidate buffers, etc.

	sec
	rts

lowlevel_fd_motor_on:

	lda FDC_CONTROL
	and #%00100000
	bne lowlevel_fd_rts               ; if motor already enabled, do nothing

	; XXX find out why it is not disabled at all 
	; lda #%00100000                     ; enable drive motor and LED
	; tsb FDC_CONTROL  ; $D080

	; Allow some time for spin-up; according to https://wiki.osdev.org/Floppy_Disk_Controller
	; 300 ms should be more than enough
	
	; XXX reenable this
	; phx
	; ldx #$0F
	; jsr wait_x_bars
	; plx

	bra lowlevel_fd_wait_clr_BUSY

lowlevel_fd_motor_off:

	lda #%00100000                     ; disable drive motor and LED
	trb FDC_CONTROL  ; $D080

	; FALLTROUGH

lowlevel_fd_wait_clr_BUSY:

	bit FDC_STATUS_A ; $D082
	bmi lowlevel_fd_wait_clr_BUSY

	rts

lowlevel_fd_wait_set_RDREQ:

	bit FDC_STATUS_B ; $D083
	bpl lowlevel_fd_wait_set_RDREQ

	; FALLTROUGH

lowlevel_fd_rts:

	rts
