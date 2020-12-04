;; #LAYOUT# STD *        #TAKE
;; #LAYOUT# X16 *        #IGNORE
;; #LAYOUT# *   KERNAL_0 #TAKE
;; #LAYOUT# M65 KERNAL_C #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; Helper table for determining keyboard matrix decoding table on the C64 keyboard
;
; When more than one bucky keey is pressed, decoding keys is asking for trouble,
; so never allow this.
;


kb_matrix_lookup:

!ifndef SEGMENT_KERNAL_C {

	!byte (__kb_matrix_normal - kb_matrix)  ; %000 Normal
	!byte (__kb_matrix_shift  - kb_matrix)  ; %001 SHIFT
	!byte (__kb_matrix_vendor - kb_matrix)  ; %010 VENDOR	
	!byte $FF                               ; %011 SHIFT+VENDOR
	!byte (__kb_matrix_ctrl   - kb_matrix)  ; %100 CTRL
	!byte $FF                               ; %101 SHIFT+CTRL
	!byte $FF                               ; %110 VENDOR+CTRL
	!byte $FF                               ; %111 SHIFT+VENDOR+CTRL

} else {

	; MEGA65 native mode - no CAPS LOCK active

	!word __kb_matrix_normal                ; %0.000 Normal
	!word __kb_matrix_shift                 ; %0.001 SHIFT
	!word __kb_matrix_vendor                ; %0.010 VENDOR	
	!word $0000                             ; %0.011 SHIFT+VENDOR
	!word __kb_matrix_ctrl                  ; %0.100 CTRL
	!word $0000                             ; %0.101 SHIFT+CTRL
	!word $0000                             ; %0.110 VENDOR+CTRL
	!word $0000                             ; %0.111 SHIFT+VENDOR+CTRL

	; MEGA65 native mode - CAPS LOCK pressed

	!word __kb_matrix_caps                  ; %1.000 Normal
	!word __kb_matrix_shift                 ; %1.001 SHIFT
	!word __kb_matrix_vendor                ; %1.010 VENDOR	
	!word $0000                             ; %1.011 SHIFT+VENDOR
	!word __kb_matrix_ctrl                  ; %1.100 CTRL
	!word $0000                             ; %1.101 SHIFT+CTRL
	!word $0000                             ; %1.110 VENDOR+CTRL
	!word $0000                             ; %1.111 SHIFT+VENDOR+CTRL
}
