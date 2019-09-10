
// In our implementation CHKIN and CKOUT are closely tied,
// placing it here would cause a collision

CKOUT:
    jmp ckout_real
