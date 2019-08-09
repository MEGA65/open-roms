
;; In our implementation CHKIN and CKOUT are closely tied,
;; placing it here would cause a collision

chkin:
    jmp chkin_real
