packed_message_chars:
	.byte $45 ; 'E'  = $1 (nybl)
	.byte $54 ; 'T'  = $2 (nybl)
	.byte $4F ; 'O'  = $3 (nybl)
	.byte $4E ; 'N'  = $4 (nybl)
	.byte $49 ; 'I'  = $5 (nybl)
	.byte $52 ; 'R'  = $6 (nybl)
	.byte $41 ; 'A'  = $7 (nybl)
	.byte $53 ; 'S'  = $8 (nybl)
	.byte $4C ; 'L'  = $9 (nybl)
	.byte $46 ; 'F'  = $a (nybl)
	.byte $44 ; 'D'  = $b (nybl)
	.byte $55 ; 'U'  = $c (nybl)
	.byte $50 ; 'P'  = $d (nybl)
	.byte $43 ; 'C'  = $e (nybl)
	.byte $47 ; 'G'  = $F1 / $xF $47
	.byte $4D ; 'M'  = $F2 / $xF $4D
	.byte $59 ; 'Y'  = $F3 / $xF $59
	.byte $56 ; 'V'  = $F4 / $xF $56
	.byte $42 ; 'B'  = $F5 / $xF $42
	.byte $48 ; 'H'  = $F6 / $xF $48
	.byte $58 ; 'X'  = $F7 / $xF $58
	.byte $57 ; 'W'  = $F8 / $xF $57
	.byte $24 ; '$'  = $F9 / $xF $24
	.byte $27 ; '''  = $Fa / $xF $27
	.byte $0D ; ''  = $Fb / $xF $0D
	.byte $51 ; 'Q'  = $Fc / $xF $51
	.byte $2E ; '.'  = $Fd / $xF $2E
	.byte $23 ; '#'  = $FE/F + $23
	.byte $4B ; 'K'  = $FE/F + $4B
	.byte $28 ; '('  = $FE/F + $28
	.byte $5A ; 'Z'  = $FE/F + $5A
	.byte $2B ; '+'  = $FE/F + $2B
	.byte $2D ; '-'  = $FE/F + $2D
	.byte $2A ; '*'  = $FE/F + $2A
	.byte $2F ; '/'  = $FE/F + $2F
	.byte $5E ; '^'  = $FE/F + $5E
	.byte $3E ; '>'  = $FE/F + $3E
	.byte $3D ; '='  = $FE/F + $3D
	.byte $3C ; '<'  = $FE/F + $3C
packed_message_tokens:
	.byte $00,$01,$02,$ff,$03,$04,$ff,$03
	.byte $05,$04,$ff,$03,$05,$06,$ff,$07
	.byte $05,$08,$ff,$05,$09,$03,$ff,$05
	.byte $0a,$03,$ff,$0b,$0c,$ff,$0d,$07
	.byte $0e,$ff,$0f,$10,$11,$ff,$12,$ff
	.byte $13,$10,$14,$ff,$15,$16,$17,$ff
	.byte $0d,$18,$ff,$19,$ff,$15,$16,$1a
	.byte $ff,$1b,$1c,$ff,$1d,$1e,$ff,$1f
	.byte $20,$ff,$21,$22,$23,$ff,$0d,$24
	.byte $ff,$25,$26,$ff,$27,$00,$28,$ff
	.byte $03,$17,$ff,$29,$00,$2a,$ff,$2b
	.byte $2c,$ff,$1b,$2d,$ff,$2e,$ff,$2f
	.byte $ff,$30,$ff,$31,$ff,$32,$ff,$33
	.byte $ff
	.byte $34
	.byte $ff
	.byte $35
	.byte $36
	.byte $ff
packed_message_words:
	.byte $23,$30,$f2,$74,$f3,$00,$a5,$91
	.byte $80,$a5,$91,$00,$3d,$14,$00,$43
	.byte $20,$a3,$c4,$b0,$b1,$f4,$5e,$10
	.byte $d6,$18,$14,$20,$54,$dc,$20,$3c
	.byte $2d,$c2,$00,$f2,$58,$85,$4f,$47
	.byte $00,$a5,$91,$47,$f2,$10,$59,$91
	.byte $f1,$79,$00,$4c,$f2,$f5,$16,$00
	.byte $41,$f7,$20,$f8,$52,$f6,$3c,$20
	.byte $a3,$60,$8f,$59,$42,$7f,$58,$00
	.byte $61,$2c,$64,$00,$f1,$38,$cf,$42
	.byte $00,$3c,$20,$3a,$00,$b7,$27,$00
	.byte $fc,$c7,$42,$52,$f3,$00,$3f,$56
	.byte $16,$a9,$3f,$57,$00,$f2,$1f,$4d
	.byte $36,$f3,$00,$c4,$b1,$af,$27,$b0
	.byte $82,$72,$1f,$4d,$14,$20,$f5,$7b
	.byte $00,$8c,$f5,$8e,$65,$d2,$00,$61
	.byte $b5,$f2,$fa,$b0,$76,$67,$f3,$00
	.byte $b5,$f4,$58,$53,$40,$f5,$f3,$00
	.byte $ff,$5a,$16,$30,$b5,$61,$e2,$00
	.byte $2f,$59,$d1,$00,$f2,$58,$f2,$72
	.byte $ef,$48,$00,$82,$65,$4f,$47,$00
	.byte $93,$4f,$47,$00,$a3,$6f,$4d,$c9
	.byte $70,$e3,$f2,$d9,$1f,$58,$00,$e7
	.byte $4f,$27,$20,$e3,$42,$54,$c1,$00
	.byte $ac,$4e,$25,$34,$00,$f4,$16,$5a
	.byte $f3,$00,$93,$7b,$00,$61,$7b,$f3
	.byte $fd,$fb,$00,$93,$7b,$54,$f1,$00
	.byte $f4,$16,$5a,$f3,$54,$f1,$00,$87
	.byte $f4,$54,$f1,$00,$16,$63,$60,$f5
	.byte $f3,$21,$80,$a6,$11,$fd,$fb,$fb
	.byte $00
packed_keywords:
	.byte $14,$b0,$a3,$60,$41,$f7,$20,$b7
	.byte $27,$00,$54,$dc,$2f,$23,$00,$54
	.byte $dc,$20,$b5,$f2,$00,$61,$7b,$00
	.byte $91,$20,$f1,$32,$30,$6c,$40,$5a
	.byte $00,$61,$82,$36,$10,$f1,$38,$cf
	.byte $42,$00,$61,$2c,$64,$00,$61,$f2
	.byte $00,$82,$3d,$00,$34,$00,$f8,$75
	.byte $20,$93,$7b,$00,$87,$f4,$10,$f4
	.byte $16,$5a,$f3,$00,$b1,$a0,$d3,$ff
	.byte $4b,$10,$d6,$54,$2f,$23,$00,$d6
	.byte $54,$20,$e3,$42,$00,$95,$82,$00
	.byte $e9,$60,$ef,$4d,$b0,$8f,$59,$80
	.byte $3d,$14,$00,$e9,$38,$10,$f1,$12
	.byte $00,$41,$f8,$00,$27,$f5,$fe,$28
	.byte $23,$00,$a4,$00,$8d,$ef,$28,$00
	.byte $2f,$48,$14,$00,$43,$20,$82,$1d
	.byte $00,$fe,$2b,$fe,$2d,$fe,$2a,$fe
	.byte $2f,$fe,$5e,$74,$b0,$36,$00,$fe
	.byte $3e,$fe,$3d,$fe,$3c,$8f,$47,$40
	.byte $54,$20,$7f,$42,$80,$c8,$60,$a6
	.byte $10,$d3,$80,$8f,$51,$60,$64,$b0
	.byte $93,$f1,$00,$1f,$58,$d0,$e3,$80
	.byte $85,$40,$27,$40,$72,$40,$d1,$1f
	.byte $4b,$00,$91,$40,$82,$6f,$24,$00
	.byte $f4,$79,$00,$78,$e0,$ef,$48,$6f
	.byte $24,$00,$91,$a2,$f9,$00,$65,$f1
	.byte $f6,$2f,$24,$00,$f2,$5b,$f9,$00
	.byte $f1
	.byte $30
	.alias packed_keyword_table_len $DA
