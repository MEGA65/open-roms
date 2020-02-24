// #LAYOUT# STD *        #TAKE
// #LAYOUT# X16 *        #IGNORE
// #LAYOUT# *   KERNAL_0 #TAKE
// #LAYOUT# *   *        #IGNORE

//
// Keyboard matrix, based on
//
// - [RG64] C64 Programmers Reference Guide        - pages 379-381
// - [CM64] Computes Mapping the Commodore 64      - pages 38-39
// - http://commodore128.mirkosoft.sk/keyboard.html (C128 extension)
// - http://www.zimmers.net/cbmpics/cbm/c65/c65manual.txt

// Values can be computed by running a program like:
// 10 GET A$ : IF A$ = "" GOTO10
// 20 PRINT ASC(A$) : GOTO10
// and converting the values 


kb_matrix:

__kb_matrix_normal:
	.byte $14,$0D,$1D,$88,$85,$86,$87,$11
	.byte $33,$57,$41,$34,$5A,$53,$45,$00
	.byte $35,$52,$44,$36,$43,$46,$54,$58
	.byte $37,$59,$47,$38,$42,$48,$55,$56
	.byte $39,$49,$4A,$30,$4D,$4B,$4F,$4E
	.byte $2B,$50,$4C,$2D,$2E,$3A,$40,$2C
	.byte $5C,$2A,$3B,$13,$00,$3D,$5E,$2F
	.byte $31,$5F,$00,$32,$20,$00,$51,$03

__kb_matrix_shift:
	.byte $94,$8D,$9D,$8C,$89,$8A,$8B,$91
	.byte $23,$77,$61,$24,$7A,$73,$65,$00
	.byte $25,$72,$64,$26,$63,$66,$74,$78
	.byte $27,$79,$67,$28,$62,$68,$75,$76
	.byte $29,$69,$6A,$92,$6D,$6B,$6F,$6E
	.byte $DB,$70,$6C,$DD,$3E,$5B,$BA,$3C
	.byte $A9,$C0,$5D,$93,$00,$3D,$DE,$3F
	.byte $21,$5F,$00,$22,$A0,$00,$71,$83

__kb_matrix_vendor:
	.byte $94,$8D,$9D,$8C,$89,$8A,$8B,$91
	.byte $96,$B3,$B0,$97,$AD,$AE,$B1,$00
	.byte $98,$B2,$AC,$99,$BC,$BB,$A3,$BD
	.byte $9A,$B7,$A5,$9B,$BF,$B4,$B8,$BE
	.byte $30,$A2,$B5,$30,$A7,$A1,$B9,$AA
	.byte $A6,$AF,$B6,$DC,$3E,$5B,$A4,$3C
	.byte $A8,$DF,$5D,$93,$00,$3D,$DE,$3F
	.byte $81,$5F,$00,$95,$a0,$00,$AB,$83

__kb_matrix_ctrl:
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $1C,$17,$01,$9F,$1A,$13,$05,$00
	.byte $9C,$12,$04,$1E,$03,$06,$14,$18
	.byte $1F,$19,$07,$9E,$02,$08,$15,$16
	.byte $12,$09,$0A,$92,$0D,$0B,$0F,$0E
#if CONFIG_EDIT_TABULATORS
	.byte $00,$10,$0C,$00,KEY_TAB_FW,$1B,$00,KEY_TAB_BW
#else
	.byte $00,$10,$0C,$00,$00,$1B,$00,$00
#endif
	.byte $1C,$00,$1D,$00,$00,$1F,$1E,$00
	.byte $90,$06,$00,$05,$00,$00,$11,$00
