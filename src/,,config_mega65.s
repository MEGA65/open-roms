
;; #CONFIG# ID $02 ; should be 1 byte, different for each config file!

;
; Please read CONFIG.md before modifying this file!
;

; Idea:
; - sane defaults for the MEGA65 FPGA computer
; - do not enable features which are a significant compatibility risk



; --- Hardware platform

;; #CONFIG# PLATFORM_COMMODORE_64      YES
;; #CONFIG# MB_M65                     YES


; --- Memory model

;; #CONFIG# MEMORY_MODEL_38K           NO
;; #CONFIG# MEMORY_MODEL_46K           NO
;; #CONFIG# MEMORY_MODEL_50K           YES


; --- IEC bus configuration

;; #CONFIG# IEC                        YES
;; #CONFIG# IEC_DOLPHINDOS             NO
;; #CONFIG# IEC_DOLPHINDOS_FAST        NO
;; #CONFIG# IEC_JIFFYDOS               NO        ; fastloaders do not work on MEGA65 yet!
;; #CONFIG# IEC_BURST_M65              NO        ; please keep disabled for now


; --- Tape deck configuration

;; #CONFIG# TAPE_NORMAL                YES
;; #CONFIG# TAPE_TURBO                 YES
;; #CONFIG# TAPE_AUTODETECT            YES
;; #CONFIG# TAPE_NO_KEY_SENSE          YES
;; #CONFIG# TAPE_NO_MOTOR_CONTROL      YES


; --- Keyboard settings

;; #CONFIG# KEY_REPEAT_DEFAULT         NO
;; #CONFIG# KEY_REPEAT_ALWAYS          NO
;; #CONFIG# KEY_FAST_SCAN              YES
;; #CONFIG# JOY1_CURSOR                NO
;; #CONFIG# JOY2_CURSOR                NO

;; #CONFIG# PROGRAMMABLE_KEYS          YES

;; #CONFIG# KEYCMD_RUN                 "RUN:"

;; #CONFIG# KEYCMD_F1                  "@8$"
;; #CONFIG# KEYCMD_F2                  "LOAD"
;; #CONFIG# KEYCMD_F3                  "@9$"
;; #CONFIG# KEYCMD_F4                  "\5FL"
;; #CONFIG# KEYCMD_F5                  "@10$"
;; #CONFIG# KEYCMD_F6                  "\5FHF"
;; #CONFIG# KEYCMD_F7                  "@11$"
;; #CONFIG# KEYCMD_F8                  "MONITOR"

;; #CONFIG# KEYCMD_HELP                "LIST"

;; #CONFIG# KEYCMD_F9                  "@27$"
;; #CONFIG# KEYCMD_F10                 "REM F10"
;; #CONFIG# KEYCMD_F11                 "@28$"
;; #CONFIG# KEYCMD_F12                 "@29$"
;; #CONFIG# KEYCMD_F13                 "@30$"
;; #CONFIG# KEYCMD_F14                 "BOOTCPM"


; --- Screen editor

;; #CONFIG# EDIT_STOPQUOTE             YES
;; #CONFIG# VIC_PALETTE                0         ; 0 = default; 1 = C65, 2 = Frodo, 3 = VICE, 4 = Colodore, 5 = community, 6 = Deekay


; --- Software features

;; #CONFIG# PANIC_SCREEN               YES
;; #CONFIG# DOS_WEDGE                  YES
;; #CONFIG# TAPE_WEDGE                 YES
;; #CONFIG# TAPE_HEAD_ALIGN            YES
;; #CONFIG# BCD_SAFE_INTERRUPTS        YES


; --- BASIC features

;; #CONFIG# TRANSCENDENTAL_FUNCTIONS   NO


; --- Built-in DOS configuration

;; #CONFIG# UNIT_SDCARD                27
;; #CONFIG# UNIT_FLOPPY0               0
;; #CONFIG# UNIT_FLOPPY1               0
;; #CONFIG# UNIT_RAMDISK               0


; --- Debug options

;; #CONFIG# DBG_STUBS_BRK              NO
;; #CONFIG# DBG_PRINTF                 NO


; --- Other

;; #CONFIG# COMPRESSION_LVL_2          NO
