; $FFFE - CPU IRQ Vector.
; This is non-controvertial, as it is a 6502 CPU requirement, and we just have to point
; it to whatever IRQ routine we make.

	.word irq_handler
