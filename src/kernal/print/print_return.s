;; #LAYOUT# STD *        #TAKE
;; #LAYOUT# *   KERNAL_0 #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; Print the carriage return
;

print_return:
    lda #$0D ; carriage return code
    jmp JCHROUT
