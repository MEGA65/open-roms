#if ROM_LAYOUT_STD || (ROM_LAYOUT_M65 && SEGMENT_KERNAL_0)

//
// Print the space character
//

print_space:
    lda #$20 // space code
    jmp JCHROUT


#endif // ROM layout
