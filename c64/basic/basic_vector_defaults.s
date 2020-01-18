// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// Default values for BASIC vectors - described in:
//
// - [RG64] C64 Programmers Reference Guide   - pages 68-70
// - [CM64] Computes Mapping the Commodore 64 - page 318
//

basic_vector_defaults_1:

	.word ERROR            // IERROR
	.word MAIN             // IMAIN
	.word CHRNCH           // ICHRNCH
	.word QPLOP            // IQPLOP
	.word GONE             // IGONE
	.word EVAL             // IEVAL

basic_vector_defaults_2:

	.word basic_adray1     // ADRAY1
	.word basic_adray2     // ADRAY2
