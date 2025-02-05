;; #LAYOUT# STD *        #TAKE
;; #LAYOUT# X16 *        #IGNORE
;; #LAYOUT# *   KERNAL_0 #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; Init screen at reset
;
; https://www.c64-wiki.com/wiki/646
; https://www.lemon64.com/forum/viewtopic.php?t=18490
;
; Information on what the code at E536 does is a bit contradictory
; It seems as if the text color at $286 is set to the value in A
; and then the screen is cleared.
; Tests indicate that this is the what happens.
    

init_screen:

    sta $0286
    jmp clear_screen
