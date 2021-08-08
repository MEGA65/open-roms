;; #LAYOUT# M65 KERNAL_0 #TAKE
;; #LAYOUT# *   *        #IGNORE

; Reset (hardware initialization) to be used when Open ROMs is used under hypervisor


m65_hypervisor_reset:

	; Proceed like with normal reset, skip problematic parts

	sei                                ; disable the interrupts, as fast as possible
	cld                                ; Kernal is not designed to operate in decimal mode

	lda #$00
	sta NMINV+1                        ; soft-disable custom NMI interrupt handler

	; Do not reset the stack (see, ldx #$FF, txs) - we need to know where to return
	
	jsr m65_reset_part                 ; init MEGA65 specific hardware, shutdown VIC-IV, clear native mode mark
	ldx #$28                           ; 40 columns, screen disabled for now
	stx VIC_SCROLX

	jsr IOINIT_skip_DOS                ; better not to initialize DOS under hypervisor, risk of incompatibility
	jsr m65_reset_part_skip_palette    ; also skip palette setting, but do RAMTAS, RESTOR, CINT

	; Restore hypervisor memory mapping and quit

	lda #$00                           ; lower memory  - megabyte $00
	ldx #$0F                           ; lower memory  - request to set the megabyte
	ldy #$FF                           ; higher memory - megabyte $FF
	ldz #$0F                           ; higher memory - request to set the megabyte

	map

	tax                                ; lower memory  - keep unmapped (.A is already 0)
	tay                                ; higher memory - lower 16 bits of the offset are also 0's
	ldz #$3F                           ; higher memory - map is %0011 = $3, offset is $FF0

	map
	eom

	cli
	rts

m65_reset_common:

	jsr JRAMTAS
	jsr JRESTOR
	jmp JCINT
