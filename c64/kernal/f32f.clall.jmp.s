
;; Our implementation is longer than the original one,
;; placing it here would cause a collision with CLRCHN

clall:
    jmp clall_real
