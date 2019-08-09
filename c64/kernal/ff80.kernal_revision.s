
;;
;; This byte identifies Kernal revision. Sources:
;; - [CM64]  Compute's Mapping the Commodore 64 (page 242/243)
;; - [MM]    Marko Mäkelä article, http://www.zimmers.net/anonftp/pub/cbm/firmware/computers/c64/revisions.txt
;; - [VICE]  Checked with ROMs included in VICE emulator
;;
;; IDEA: put here a value, that is different from any version currently known, as
;; a warning that this is not a Commodore Kernal. Currently known numbers for C64 are:
;;
;; - $00 - [CM64] then current number    [MM] 901227-02             [VICE] C64 Revision 2
;; - $03 - [CM64] (not mentionned)       [MM] 901227-02, 901227-03  [VICE] C64 Revision 3
;; - $43 - [CM64] (not mentionned)       [MM] 251104-04             [VICE] SX-64
;; - $64 - [CM64] PET64 ROM              [MM] (not mentionned)      [VICE] PET64
;; - $AA - [CM64] first version of ROM   [MM] 901227-01             [VICE] C64 Revision 1
;;
;; Values from unofficial ROMs:
;; - $03 - SuperCPU ROM 1.40, 2.04, also unofficial 0.7 ROM from [VICE]
;; 
;; Values from other Commodore machines:
;; C128:
;; - $01 - see https://www.pagetable.com/?p=1058
;; - $02 - unreleased updated ROM, see https://www.pagetable.com/?p=1058
;;
;; XXX check more unofficial C64 ROMs (JiffyDOS, DolphinDOS, etc.) and other machines
;;     VIC-20, PET, CBM II, 264 series, C65 prototypes, other sources for C128 ROMs
;;


kernal_revision:
    .byte $FF
