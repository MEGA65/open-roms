// #LAYOUT# STD *        #TAKE
// #LAYOUT# *   KERNAL_0 #TAKE
// #LAYOUT# *   *        #IGNORE


// $FFFA - CPU NMI Hanlder
// Uncontrovertial as this is also a CPU requirement.

vector_nmi:

	.word hw_entry_nmi
