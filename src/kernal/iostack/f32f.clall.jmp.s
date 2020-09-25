;; #LAYOUT# STD *        #TAKE
;; #LAYOUT# *   KERNAL_0 #TAKE
;; #LAYOUT# *   *        #IGNORE


; Our implementation is longer than the original one,
; placing it here would cause a collision with CLRCHN


CLALL:
    jmp clall_real
