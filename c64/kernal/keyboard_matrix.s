	;; Key board matrixes:
	;; unshifted, shifted, control and C= modified
	;; 64 bytes for each


keyboard_matrixes:
	;; Unshifted matrix built by refering to
	;; Compute's Mapping the 64 p38-39
	;; and C64 PRG pages 379-381
	.byte $14,$0D,$1D,$88,$85,$86,$87,17
	.byte $33,87,$41,$34,$5A,83,$45,$00
	.byte $35,$52,$44,$36,$43,$46,$54,88
	.byte $37,$59,$47,$38,$42,$48,$55,$56
	.byte $39,$49,$4A,$30,$4D,$4B,$4F,$4E
	.byte $2B,$50,$4C,45,46,58,$40,44
	.byte $5C,$2A,59,$13,$00,$3D,$5E,$2F
	.byte $31,$5F,$00,$32,$20,$00,$51,$03

	;; Shifted keyboard
	;; Values computed by running a program like:
	;; 10 GETA$:IFA$=""GOTO10
	;; 20 ?ASC(A$):GOTO10
	;; and converting the values 
	.byte $94,$8D,$9D,$8C,$89,$8A,$8B,$91
	.byte $23,$77,$61,$24,$7A,$73,$65,$00
	.byte $25,$72,$64,$26,$63,$66,$74,$78
	.byte $27,$79,$67,$28,$62,$68,$75,$76
	.byte $29,$69,$6A,$92,$6D,$6B,$6F,$6E
	.byte $DB,$70,$6C,$DD,$3E,$5B,$BA,$3C
	.byte $A9,$C0,$5D,$93,$00,$3D,$DE,$3F
	.byte $21,$5F,$00,$22,$A0,$00,$71,$83

	;; Vendor key modified keyboard
	.byte $94,$8D,$9D,$8C,$89,$8A,$8B,$91
	.byte $96,$B3,$B0,$97,$AD,$AE,$B1,$00
	.byte $98,$B2,$AC,$99,$BC,$BB,$A3,$BD
	.byte $9A,$B7,$A5,$9B,$BF,$B4,$B8,$BE
	.byte $30,$A2,$B5,$30,$A7,$A1,$B9,$AA
	.byte $A6,$AF,$B6,$DC,$3E,$5B,$A4,$3C
	.byte $A8,$DF,$5D,$93,$00,$3D,$DE,$3F
	.byte $81,$5F,$00,$95,$a0,$00,$AB,$83

	;; Control modified keyboard
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $1C,$17,$01,$9F,$1A,$13,$05,$00
	.byte $9C,$12,$04,$1E,$03,$06,$14,$18
	.byte $1F,$19,$07,$9E,$02,$08,$15,$16
	.byte $12,$09,$0A,$92,$0D,$0B,$0F,$0E
	.byte $00,$10,$0C,$00,$00,$1B,$00,$00
	.byte $1C,$00,$1D,$00,$00,$1F,$1E,$00
	.byte $90,$06,$00,$05,$00,$00,$11,$00


keyboard_matrix_lookup:
	;; Work out if normal, shifted, control or Vendor
	;; modified keyboard. 
	;; Table contains the offsets into keyboard_matrixes
	;; that should be used for different values of
	;; the bottom 3 bits of key_bucky_state
	;; Interaction is simple to work out when playing
	;; with a C64:
	;; CONTROL trumps SHIFT or Vendor
	;; Vendor + SHIFT = DOES NOTHING
	;; All 3 does CONTROL
	.byte $00 		; Normal
	.byte $40		; Shifted
	.byte $80		; Control
	.byte $80		; Control + SHIFT
	.byte $C0		; Vendor
	.byte $C0 		; Vendor + SHIFT
	.byte $80		; Vendor+ CTRL
	.byte $80		; Vendor + CTRL + SHIFT

