
;; #CONFIG# ID $03 ; should be 1 byte, different for each config file!

;
; Please read CONFIG.md before modifying this file!
;

; Idea:
; - sane defaults for the Ultimate 64 FPGA computer
; - do not enable features which are a significant compatibility risk



; --- Hardware platform and brand

;; #CONFIG# PLATFORM_COMMODORE_64      YES
;; #CONFIG# MB_U64                     YES


; --- Memory model

;; #CONFIG# MEMORY_MODEL_38K           NO
;; #CONFIG# MEMORY_MODEL_46K           NO
;; #CONFIG# MEMORY_MODEL_50K           YES
;; #CONFIG# MEMORY_MODEL_60K           NO


; --- IEC bus configuration

;; #CONFIG# IEC                        YES
;; #CONFIG# IEC_DOLPHINDOS             YES
;; #CONFIG# IEC_DOLPHINDOS_FAST        YES
;; #CONFIG# IEC_JIFFYDOS               YES
;; #CONFIG# IEC_JIFFYDOS_BLANK         YES


; --- Tape deck configuration

;; #CONFIG# TAPE_NORMAL                YES
;; #CONFIG# TAPE_TURBO                 YES
;; #CONFIG# TAPE_AUTODETECT            YES
;; #CONFIG# TAPE_NO_KEY_SENSE          NO
;; #CONFIG# TAPE_NO_MOTOR_CONTROL      NO


; --- Sound support

;; #CONFIG# SID_2ND_ADDRESS            NO
;; #CONFIG# SID_3RD_ADDRESS            NO
;; #CONFIG# SID_D4XX                   YES
;; #CONFIG# SID_D5XX                   YES
;; #CONFIG# SID_D6XX                   NO
;; #CONFIG# SID_D7XX                   NO


; --- Keyboard settings

;; #CONFIG# KEYBOARD_C128              NO
;; #CONFIG# KEYBOARD_C128_CAPS_LOCK    NO
;; #CONFIG# KEY_REPEAT_DEFAULT         NO
;; #CONFIG# KEY_REPEAT_ALWAYS          NO
;; #CONFIG# KEY_FAST_SCAN              YES
;; #CONFIG# JOY1_CURSOR                NO
;; #CONFIG# JOY2_CURSOR                NO

;; #CONFIG# PROGRAMMABLE_KEYS          YES

;; #CONFIG# KEYCMD_RUN                 "\5FL"

;; #CONFIG# KEYCMD_F1                  "@8$"
;; #CONFIG# KEYCMD_F2                  "LOAD"
;; #CONFIG# KEYCMD_F3                  "@9$"
;; #CONFIG# KEYCMD_F4                  "RUN:"
;; #CONFIG# KEYCMD_F5                  "@10$"
;; #CONFIG# KEYCMD_F6                  NO
;; #CONFIG# KEYCMD_F7                  "@11$"
;; #CONFIG# KEYCMD_F8                  NO

;; #CONFIG# KEYCMD_HELP                "LIST"


; --- Screen editor

;; #CONFIG# EDIT_STOPQUOTE             YES


; --- Software features

;; #CONFIG# PANIC_SCREEN               YES
;; #CONFIG# DOS_WEDGE                  NO
;; #CONFIG# TAPE_WEDGE                 YES
;; #CONFIG# TAPE_HEAD_ALIGN            NO
;; #CONFIG# BCD_SAFE_INTERRUPTS        YES


; --- BASIC features

;; #CONFIG# TRANSCENDENTAL_FUNCTIONS   NO


; --- Eye candy

;; #CONFIG# COLORS_BRAND               YES
;; #CONFIG# BANNER_SIMPLE              YES
;; #CONFIG# BANNER_FANCY               NO
;; #CONFIG# SHOW_FEATURES              YES


; --- Debug options

;; #CONFIG# DBG_STUBS_BRK              NO
;; #CONFIG# DBG_PRINTF                 NO


; --- Other

;; #CONFIG# COMPRESSION_LVL_2          NO
