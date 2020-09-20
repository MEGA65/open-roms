;; #LAYOUT# STD *        #TAKE
;; #LAYOUT# *   KERNAL_0 #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; Print the space character
;

print_space:
    lda #$20 ; space code
    jmp JCHROUT
