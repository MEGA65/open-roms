;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE
 
; init - copy CHRGET and CHRGOT from ROM to zero page
;        We only use this for the 38K memory model for maximum C64 compatibility
;
; Input: Nothing
; Output: Nothing
; Clobbers: A, Y
;
; See also:
; https://www.c64-wiki.com/wiki/CHRGET
;

!ifdef CONFIG_MEMORY_MODEL_38K {

copy_CHRGET:
    ldy #23         ; Last index to copy
@1: lda MOVCHG,Y
    sta CHRGET,Y
    dey
    bpl @1
    rts
    
}
