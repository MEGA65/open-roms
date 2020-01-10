#if ROM_LAYOUT_STD || (ROM_LAYOUT_M65 && SEGMENT_KERNAL_0)

//
// This byte (hex $FF80, dec 65408) identifies Kernal revision on several machines. Although not all
// of the, used it for versioning purpose, here is the list of all the values I could find. Sources:
// - [CM64]  Computes Mapping the Commodore 64 (page 242/243)
// - [MM]    Marko Mäkelä article, http://www.zimmers.net/anonftp/pub/cbm/firmware/computers/c64/revisions.txt
// - [VICE]  Checked with ROMs included in VICE emulator
// - [XEMU]  Checked with ROMs retrieved by XEMU emulator
//
// IDEA: put here a value, that is different from any version currently known, as
// a warning that this is not a Commodore Kernal or anything already known.
//
// C64 - values from the official ROMs:
// - $00 - [CM64] then current number    [MM] 901227-02             [VICE] C64 Revision 2
// - $03 - [CM64] (not mentionned)       [MM] 901227-02, 901227-03  [VICE] C64 Revision 3
// - $43 - [CM64] (not mentionned)       [MM] 251104-04             [VICE] SX-64
// - $64 - [CM64] PET64 ROM              [MM] (not mentionned)      [VICE] PET64
// - $AA - [CM64] first version of ROM   [MM] 901227-01             [VICE] C64 Revision 1
//
// C64 - values from unofficial 3rd party ROMs:
// - $00 - Turbo Trans, Turbo Access, Turbo Process
// - $03 - SuperCPU ROM 1.40, 2.04, also unofficial 0.7 ROM from [VICE],
//         DolphinDOS 2.0, JiffyDOS 6.01, EXOS V3/4,
//         Datel Mercury V3 US, Datel DOS-ROM V1.2, Datel Turbo ROM II V3.2+,
//         Turbo Process US,
//         burst CIA 1/2 Kernal by Albert, SD2IEC Kernal 1.0/2.0/2.1/2.2 by Claus
// - $4A - S-JiffyDOS
// - $53 - Professional DOS V1, SpeedDOS Plus 2.7
// - $C3 - Cockroach Turbo ROM V1
//
// PET:
// - $40 - [VICE] PET 2001-8N
// - $A7 - [VICE] PET 30XX
// - $AA - [VICE] PET 40XX, PET 80XX, SuperPET
//
// CBM II:
// - $E0 - [VICE] 5x0, 6x0, 7x0 models
//
// VIC-20:
// - $16 - [VICE] all models, also VIC-20 JiffyDOS PAL/NTSC
//
// 264 family:
// - $01 - [VICE] 364
// - $05 - [VICE] C16, C116, Plus/4
// - $06 - (unofficial) JiffyDOS NTSC
// - $81 - [VICE] 232
// - $86 - (unofficial) JiffyDOS PAL
//
// C128:
// - $01 - see https://www.pagetable.com/?p=1058
// - $02 - unreleased updated ROM, see https://www.pagetable.com/?p=1058
//
// Commodore prototypes:
// - $04 - [XEMU] 64 mode ROM of the C65 prototype, ROM 910111
// - $FF - [XEMU] C65 native mode, ROM 910111
// - $FF - [XEMU] Commodore LCD
//
// Non-Commodore machines:
// - $FF - Commander X16 (emulator r28)
//


kernal_revision:
    .byte $F0 // chosen not to conflict with anything known so far


#endif // ROM layout
