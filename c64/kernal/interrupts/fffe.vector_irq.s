// #LAYOUT# STD *        #TAKE
// #LAYOUT# *   KERNAL_0 #TAKE
// #LAYOUT# *   *        #IGNORE


// $FFFE - CPU IRQ Vector.
// This is non-controvertial, as it is a 6502 CPU requirement, and we just have to point
// it to whatever IRQ routine we make.

	.word hw_entry_irq
