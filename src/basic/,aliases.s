
//
// Helper aliases to make the code more readable
// Always use double underscore in label names
// to allow automatic VICE label conflict prevention
//

	// Temporary variables for various routines
	.label __tokenise_work1 = $07 // CHARAC
	.label __tokenise_work2 = $08 // ENDCHR
	.label __tokenise_work3 = $0B // COUNT
	.label __tokenise_work4 = $0F // GARBFL
	.label __tokenise_work5 = $0C // DIMFLG
