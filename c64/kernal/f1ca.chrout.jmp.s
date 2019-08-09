
;; Our implementation is longer than the original one,
;; placing it here would cause a collision with CHKIN

chrout:
    jmp chrout_real
