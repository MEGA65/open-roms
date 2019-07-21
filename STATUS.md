# New features


Here are the features of the Open ROMs not found in the original ROMs from the 80s:

* improved keyboard scanning, supports multi-key roll-over and rejection of spurious joystick input
* joystick (port 1) can be used to move text cursor
* banking in the BASIC interpreter: 61436 bytes free
* LOAD start/end addresses are displayed, in the Final cartridge style
* LOAD command with just the file name tries to use the last device if it's number seems sane; otherwise uses 8
* LOAD secondary address over 255 is considered a start address; NOTE: syntax will most likely change here in the future!

# Features missing


The following ROM features are currently missing:

* most BASIC commands
* BASIC variables
* BASIC expression parsing
* floating point routines
* tape support
* RS-232 support
* warm start (RUN/STOP + RESTORE) - NMI is not implemented at all
* breaking Kernal routines with RUN/STOP key

Features currently being worked on:

* IEC support
* DOS wedge


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


| Address | Name   | Status   |  Remarks                                |
| ------- | :----: | :------: | :-------------------------------------: |
| $FF81   | CINT   | PARTIAL  | at least PAL/NTSC detection is missing  |
| $FF84   | IOINIT | PARTIAL  | at least SID volume handling is missing |
| $FF87   | RAMTAS | DONE     |                                         |
| $FF8A   | RESTOR | PARTIAL  | CBINV, NMINV, and USRCMD missing        |
| $FF8D   | VECTOR | DONE     |                                         |
| $FF90   | SETMSG | DONE     |                                         |
| $FF93   | SECOND | DONE     |                                         |
| $FF96   | TKSA   | PARTIAL  | should it do a turnaround?              |
| $FF99   | MEMTOP | DONE     |                                         |
| $FF9C   | MEMBOT | DONE     |                                         |
| $FF9F   | SCNKEY | DONE     | could be better integrated with ROM     |
| $FFA2   | SETTMO | NOT DONE |                                         |
| $FFA5   | ACPTR  | NOT DONE | * work in progress                      |
| $FFA8   | CIOUT  | DONE     |                                         |
| $FFAB   | UNTLK  | PARITAL  | * work in progress                      |
| $FFAE   | UNLSN  | DONE     |                                         |
| $FFB1   | LISTEN | DONE     |                                         |
| $FFB4   | TALK   | PARTIAL  | should it do a turnaround?              |
| $FFB7   | READST | DONE     |                                         |
| $FFBA   | SETFLS | DONE     |                                         |
| $FFBD   | SETNAM | DONE     |                                         |
| $FFC0   | OPEN   | DONE     |                                         |
| $FFC3   | CLOSE  | PARTIAL  | * work in progress                      |
| $FFC6   | CHKIN  | PARTIAL  | * work in progress                      |
| $FFC9   | CHKOUT | PARTIAL  | * work in progress                      |
| $FFCC   | CLRCHN | PARTIAL  | * work in progress                      |
| $FFCF   | CHRIN  | NOT DONE | * work in progress                      |
| $FFD2   | CHROUT | NOT DONE | * work in progress                      |
| $FFD5   | LOAD   | PARTIAL  | no VERIFY support yet                   |
| $FFD8   | SAVE   | NOT DONE | * work in progress                      |
| $FFDB   | SETTIM | NOT DONE |                                         |
| $FFDE   | RDTIM  | NOT DONE |                                         |
| $FFE1   | STOP   | PARTIAL  | no connection with UDTIM                |
| $FFE4   | GETIN  | PARTIAL  | * work in progress                      |
| $FFE7   | CLALL  | PARTIAL  | * work in progress                      |
| $FFEA   | UDTIM  | NOT DONE |                                         |
| $FFED   | SCREEN | DONE     |                                         |
| $FFF0   | PLOT   | NOT DONE |                                         |
| $FFF3   | IOBASE | DONE     |                                         |


### Unofficial Kernal locations

TODO
