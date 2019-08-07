# New features


Here are the features of the Open ROMs not found in the original ROMs from the 80s:

* improved keyboard scanning, supports multi-key roll-over and rejection of spurious joystick input
* joystick (port 1) can be used to move text cursor
* uses RAM under ROM and I/O: 61436 bytes free
* cold/warm start silences 4 SID chips - assumes addresses $D400, $D420, $D440, $D460
* extended `LOAD` command
    * start/end addresses are displayed, in the Final cartridge style
    * command with just the file name tries to use the last device if it's number seems sane; otherwise uses 8
    * secondary address over 255 is considered a start address
* DOS wedge (direct mode only) - `@<drive_number>`, `@<command>`, `@$`, `@$<params>`, `@`

NOTE: extra features and their syntax can change in the future!

# Features missing


The following ROM features are currently missing:

* most BASIC commands
* BASIC variables
* BASIC expression parsing
* floating point routines
* tape support
* RS-232 support
* warm start (RUN/STOP + RESTORE) - NMI/BRK handling is not implemented at all
* breaking Kernal routines with RUN/STOP key

Features currently being worked on:

* IEC support needs more work; alternative drive ROMs (JiffyDOS, DolphinDOS, etc) usually don't work with current implementation, SAVE / VERIFY are not implemented, etc.

# API status


Status of the various APIs and variables from the original ROMs


## Page 0


TODO


## Pages 2 & 3


TODO


## BASIC


TODO


## Kernal


Note: only the jump table addresses are currently supported, real routine addresses are different!


### Official Kernal routines

NOTE: Even the 'DONE' routines won't support features described as missing in one of the previous chapters!

<br />

| Address   | Name     | Status   |  Remarks                                           |
| --------- | :------- | :------: | :------------------------------------------------: |
| `$FF81`   | `CINT`   | DONE     |                                                    |
| `$FF84`   | `IOINIT` | DONE     |                                                    |
| `$FF87`   | `RAMTAS` | DONE     |                                                    |
| `$FF8A`   | `RESTOR` | DONE     |                                                    |
| `$FF8D`   | `VECTOR` | DONE     |                                                    |
| `$FF90`   | `SETMSG` | DONE     |                                                    |
| `$FF93`   | `SECOND` | DONE     |                                                    |
| `$FF96`   | `TKSA`   | DONE     |                                                    |
| `$FF99`   | `MEMTOP` | DONE     |                                                    |
| `$FF9C`   | `MEMBOT` | DONE     |                                                    |
| `$FF9F`   | `SCNKEY` | DONE     | could be better integrated with ROM (aliases)      |
| `$FFA2`   | `SETTMO` | DONE     |                                                    |
| `$FFA5`   | `ACPTR`  | DONE     |                                                    |
| `$FFA8`   | `CIOUT`  | DONE     |                                                    |
| `$FFAB`   | `UNTLK`  | DONE     |                                                    |
| `$FFAE`   | `UNLSN`  | DONE     |                                                    |
| `$FFB1`   | `LISTEN` | DONE     |                                                    |
| `$FFB4`   | `TALK`   | DONE     |                                                    |
| `$FFB7`   | `READST` | DONE     |                                                    |
| `$FFBA`   | `SETFLS` | DONE     |                                                    |
| `$FFBD`   | `SETNAM` | DONE     |                                                    |
| `$FFC0`   | `OPEN`   | DONE     |                                                    |
| `$FFC3`   | `CLOSE`  | DONE     |                                                    |
| `$FFC6`   | `CHKIN`  | DONE     |                                                    |
| `$FFC9`   | `CHKOUT` | PARTIAL  |                                                    |
| `$FFCC`   | `CLRCHN` | DONE     |                                                    |
| `$FFCF`   | `CHRIN`  | PARTIAL  |                                                    |
| `$FFD2`   | `CHROUT` | PARTIAL  |                                                    |
| `$FFD5`   | `LOAD`   | PARTIAL  | no VERIFY support yet, no STOP key support         |
| `$FFD8`   | `SAVE`   | NOT DONE |                                                    |
| `$FFDB`   | `SETTIM` | NOT DONE |                                                    |
| `$FFDE`   | `RDTIM`  | NOT DONE |                                                    |
| `$FFE1`   | `STOP`   | DONE     |                                                    |
| `$FFE4`   | `GETIN`  | PARTIAL  | only some devices supported                        |
| `$FFE7`   | `CLALL`  | DONE     |                                                    |
| `$FFEA`   | `UDTIM`  | NOT DONE | checking for STOP key present in SCNKEY instead    |
| `$FFED`   | `SCREEN` | DONE     |                                                    |
| `$FFF0`   | `PLOT`   | NOT DONE |                                                    |
| `$FFF3`   | `IOBASE` | DONE     |                                                    |

<br />

### Unofficial Kernal locations

TODO
