#if ROM_LAYOUT_STD || (ROM_LAYOUT_M65 && SEGMENT_KERNAL_0)

//
// Print the carriage return
//

print_return:
    lda #$0D // carriage return code
    jmp JCHROUT


#endif // ROM layout
