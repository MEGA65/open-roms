	;; Key board matrixes:
	;; unshifted, shifted, control and C= modified
	;; 64 bytes for each


keyboard_matrixes:
	;; Unshifted matrix built by refering to
	;; Compute's Mapping the 64 p38-39
	;; and C64 PRG pages 379-381
	.byte 20,13,29,136,133,134,15,17
	.byte $33,87,$41,$34,90,83,$45,$00
	.byte $35,$52,$44,$36,$43,$46,$54,88
	.byte $37,89,$47,$38,$42,$48,$55,$56
	.byte $39,$49,$4A,$30,$4D,$4B,$4F,$4E
	.byte 43,$50,$4C,45,46,58,$40,44
	.byte $23,42,59,$13,$00,61,94,47
	.byte $31,95,$00,$32,$20,$00,$51,3

	;; XXX - Implement shifted

	;; XXX - Implement control modified

	;; XXX - Implement C= modified
