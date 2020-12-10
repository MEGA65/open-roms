
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
;; #CONFIG# IEC_JIFFYDOS_BLANK         NO
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

;; #CONFIG# KEYCMD_RUN                 "RUN"

;; #CONFIG# KEYCMD_F1                  "@8$"
;; #CONFIG# KEYCMD_F2                  "LOAD"
;; #CONFIG# KEYCMD_F3                  "@9$"
;; #CONFIG# KEYCMD_F4                  "RUN:"
;; #CONFIG# KEYCMD_F5                  "@10$"
;; #CONFIG# KEYCMD_F6                  "REM F6"
;; #CONFIG# KEYCMD_F7                  "@11$"
;; #CONFIG# KEYCMD_F8                  "MONITOR"

;; #CONFIG# KEYCMD_HELP                "LIST"

;; #CONFIG# KEYCMD_F9                  "REM F9"
;; #CONFIG# KEYCMD_F10                 "\5FL"
;; #CONFIG# KEYCMD_F11                 "REM F11"
;; #CONFIG# KEYCMD_F12                 "\5FHF"
;; #CONFIG# KEYCMD_F13                 "JOYCRSR 2"
;; #CONFIG# KEYCMD_F14                 "JOYCRSR 0"


; --- Screen editor

;; #CONFIG# EDIT_STOPQUOTE             YES


; --- Software features

;; #CONFIG# PANIC_SCREEN               YES
;; #CONFIG# DOS_WEDGE                  YES
;; #CONFIG# TAPE_WEDGE                 YES
;; #CONFIG# TAPE_HEAD_ALIGN            YES
;; #CONFIG# BCD_SAFE_INTERRUPTS        YES


; --- Built-in DOS configuration

;; #CONFIG# CMDRDOS                    NO        ; do not change, DOS is not implemented yet

;; #CONFIG# UNIT_SDCARD                0         ; do not change, DOS is not implemented yet
;; #CONFIG# UNIT_FLOPPY                0         ; do not change, DOS is not implemented yet
;; #CONFIG# UNIT_RAMDISK               0         ; do not change, DOS is not implemented yet


; --- Debug options

;; #CONFIG# DBG_STUBS_BRK              NO
;; #CONFIG# DBG_PRINTF                 NO


; --- Other

;; #CONFIG# COMPRESSION_LVL_2          NO


;; #CONFIG# DEV_BSMON                  NO       ; do not change, BSMON is not integrated yet
