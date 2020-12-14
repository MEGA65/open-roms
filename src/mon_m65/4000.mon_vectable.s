
; A vector table to integrate BSMON with the MEGA65 Kernal

!ifdef CONFIG_DEV_BSMON {

!word xtest
!word Mon_Call
!word Mon_Break
!word Mon_Switch

} else { rts }
