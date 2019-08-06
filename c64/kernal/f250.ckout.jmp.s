
;; In our implementation CHKIN and CKOUT are closely tied,
;; placing it here would cause a collision

ckout:
    jmp ckout_real
