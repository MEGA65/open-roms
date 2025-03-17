;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# X16 BASIC_0 #TAKE-OFFSET 2000
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

; Just a compatibility jump - our routine is longer than original one

!ifdef CONFIG_MEMORY_MODEL_38K {
    jmp FIN
} else {
    +STUB_IMPLEMENTATION
}
