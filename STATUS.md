# New features


Here are the features of the Open ROMs not found in the original ROMs from the 80s (many of them are [configurable](CONFIG.md)):

* improved keyboard scanning, supports multi-key roll-over and rejection of spurious joystick input
* joystick (port 1) can be used to move text cursor
* uses RAM under ROM and I/O: 61438 bytes free
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

### Official BASIC routines

Note: vectors at `$0300` are not supported yet - for now only the locations below can be used!

<br />

| Entry     | Unofficial | Name       | Status   |  Remarks                                           |
| :-------: | :--------: | :--------- | :------: | :------------------------------------------------: |
| `($0003)` |            | `ADRAY1`   | NOT DONE |                                                    |
| `($0005)` |            | `ADRAY2`   | NOT DONE |                                                    |
| `(00300)` | `$E38B`    | `ERROR`    | NOT DONE |                                                    |
| `(00302)` | `$A483`    | `MAIN`     | NOT DONE | some implementation exists, but not connected here |
| `(00304)` | `$A57C`    | `CHRNCH`   | NOT DONE |                                                    |
| `(00306)` | `$A71A`    | `QPLOP`    | NOT DONE | some implementation exists, but not connected here |
| `(00308)` | `$A7E4`    | `GONE`     | NOT DONE | some implementation exists, but not connected here |
| `(0030A)` | `$AE86`    | `EVAL`     | NOT DONE | some implementation exists, but not connected here |
| `($A000)` |            | cold start | PARTIAL  |                                                    |
| `($A002)` |            | warm start | PARTIAL  |                                                    |

<br />

### Unofficial BASIC routines/locations

Not all of them - only these we want to have implemented.

<br />

| Address   | Name         | Status   |  Remarks                                           |
| :-------: | :----------- | :------: | :------------------------------------------------: |
| `$A004`   | revision str | DONE     |                                                    |
| `$A68E`   | RUNC         | NOT DONE |                                                    |
| `$A7AE`   | NEWSTT       | NOT DONE |                                                    |
| `$AB1E`   | STROUT       | DONE     |                                                    |
| `$BDCD`   | LINPRT       | DONE     | temporary implementation                           |
| `$E3BF`   | INIT         | NOT DONE |                                                    |
| `$E422`   | INITMSG      | DONE     |                                                    |
| `$E453`   | RVECT        | NOT DONE |                                                    |

<br />

## Kernal

### Official Kernal routines

NOTE: Even the 'DONE' routines won't support features described as missing in one of the previous chapters!

<br />

| Address   | Unofficial | Name        | Status   |  Remarks                                           |
| :-------: | :--------: | :---------- | :------: | :------------------------------------------------: |
| `($028F)` |            | `KEYLOG`    | NOT DONE |                                                    |
| `$FF81`   | `$FF5B`    | `CINT`      | DONE     |                                                    |
| `$FF84`   | `$FDA3`    | `IOINIT`    | PARTIAL  | CIA initialization incomplete                      |
| `$FF87`   | `$FD50`    | `RAMTAS`    | DONE     |                                                    |
| `$FF8A`   | `$FD15`    | `RESTOR`    | DONE     |                                                    |
| `$FF8D`   | `$FD1A`    | `VECTOR`    | DONE     |                                                    |
| `$FF90`   |            | `SETMSG`    | DONE     |                                                    |
| `$FF93`   |            | `SECOND`    | DONE     |                                                    |
| `$FF96`   |            | `TKSA`      | DONE     |                                                    |
| `$FF99`   |            | `MEMTOP`    | DONE     |                                                    |
| `$FF9C`   |            | `MEMBOT`    | DONE     |                                                    |
| `$FF9F`   |            | `SCNKEY`    | DONE     | could be better integrated with ROM (aliases)      |
| `$FFA2`   |            | `SETTMO`    | DONE     |                                                    |
| `$FFA5`   |            | `ACPTR`     | DONE     |                                                    |
| `$FFA8`   |            | `CIOUT`     | DONE     |                                                    |
| `$FFAB`   |            | `UNTLK`     | DONE     |                                                    |
| `$FFAE`   |            | `UNLSN`     | DONE     |                                                    |
| `$FFB1`   |            | `LISTEN`    | DONE     |                                                    |
| `$FFB4`   |            | `TALK`      | DONE     |                                                    |
| `$FFB7`   |            | `READST`    | DONE     |                                                    |
| `$FFBA`   |            | `SETFLS`    | DONE     |                                                    |
| `$FFBD`   |            | `SETNAM`    | DONE     |                                                    |
| `$FFC0`   | `$F34A`    | `OPEN`      | DONE     |                                                    |
| `$FFC3`   | `$F291`    | `CLOSE`     | DONE     |                                                    |
| `$FFC6`   | `$F20E`    | `CHKIN`     | DONE     |                                                    |
| `$FFC9`   | `$F250`    | `CKOUT`     | PARTIAL  |                                                    |
| `$FFCC`   | `$F333`    | `CLRCHN`    | DONE     |                                                    |
| `$FFCF`   | `$F157`    | `CHRIN`     | PARTIAL  |                                                    |
| `$FFD2`   | `$F1CA`    | `CHROUT`    | PARTIAL  |                                                    |
| `$FFD5`   | `$F49E`    | `LOAD`      | PARTIAL  | not yet clear what's this entry doing              |
| `($0330)` | `$F4A5`    | `LOAD`      | PARTIAL  | no VERIFY support, no STOP key, check $F49E addr   |
| `$FFD8`   | `$F5DD`    | `SAVE`      | NOT DONE |                                                    |
| `($0332)` | `$F5ED`    | `SAVE`      | NOT DONE |                                                    |
| `$FFDB`   |            | `SETTIM`    | DONE     |                                                    |
| `$FFDE`   |            | `RDTIM`     | DONE     |                                                    |
| `$FFE1`   | `$F6ED`    | `STOP`      | DONE     |                                                    |
| `$FFE4`   | `$F13E`    | `GETIN`     | PARTIAL  | only some devices supported                        |
| `$FFE7`   | `$F32F`    | `CLALL`     | DONE     |                                                    |
| `$FFEA`   |            | `UDTIM`     | DONE     |                                                    |
| `$FFED`   |            | `SCREEN`    | DONE     |                                                    |
| `$FFF0`   | `$E50A`    | `PLOT`      | PARTIAL  |                                                    |
| `$FFF3`   |            | `IOBASE`    | DONE     |                                                    |
| `($FFFA)` |            | NMI vec     | PARTIAL  |                                                    |
| `($FFFC)` |            | RESET vec   | PARTIAL  |                                                    |
| `($FFFE)` |            | IRQ/BRK vec | PARTIAL  |                                                    |

<br />

### Unofficial Kernal routines/locations

Not all of them - only these we want to have implemented.

<br />

| Address   | Name                | Status   |  Remarks                                           |
| :-------: | :------------------ | :------: | :------------------------------------------------: |
| `$E544`   | clear screen        | DONE     |                                                    |
| `$E50C`   | set cursor position | PARTIAL  |                                                    |
| `$E5A0`   | setup VIC II & IO   | PARTIAL  |                                                    |
| `$EA31`   | default IRQ         | PARTIAL  |                                                    |
| `$EA7E`   | ack CIA1 + below    | DONE     |                                                    |
| `$EA81`   | ret from IRQ/NMI    | DONE     |                                                    |
| `$FD30`   | default vectors     | DONE     |                                                    |
| `$FE47`   | default NMI         | PARTIAL  |                                                    |
| `$FE66`   | default BRK         | DONE     |                                                    |
| `$FF80`   | revision byte       | DONE     |                                                    |

<br />
