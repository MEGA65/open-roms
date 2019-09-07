# New features


Here are the features of the Open ROMs not found in the original ROMs from the 80s:

* improved keyboard scanning, supports multi-key roll-over and rejection of spurious joystick input
* joystick (port 1) can be used to move text cursor
* uses RAM under ROM and I/O: 61436 bytes free
* cold/warm start silences multiple SID chips - all $D4xx and $D5xx addresses
* wark start due to BRK prints out the instruction address
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
* breaking Kernal routines with RUN/STOP key
* NMI andling is incomplete


# API status


Status of the various APIs and variables from the original ROMs


## Low memory locations (pages 0 - 3)


For the current status of the low memory location implementation andd usage check [this file](c64/aliases/,aliases_ram_lowmem.s). NOTE: available vector to certain routine does not mean that this routine is fully implemented!


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
| `$FF84`   | `IOINIT` | PARTIAL  | CIA initialization incomplete                      |
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
| `$FFDB`   | `SETTIM` | DONE     |                                                    |
| `$FFDE`   | `RDTIM`  | DONE     |                                                    |
| `$FFE1`   | `STOP`   | DONE     |                                                    |
| `$FFE4`   | `GETIN`  | PARTIAL  | only some devices supported                        |
| `$FFE7`   | `CLALL`  | DONE     |                                                    |
| `$FFEA`   | `UDTIM`  | DONE     |                                                    |
| `$FFED`   | `SCREEN` | DONE     |                                                    |
| `$FFF0`   | `PLOT`   | PARTIAL  | cursor blink not handled                           |
| `$FFF3`   | `IOBASE` | DONE     |                                                    |

<br />

### Unofficial Kernal locations

TODO
