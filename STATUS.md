# New features


Here are the features of the Open ROMs not found in the original ROMs from the 80s (many of them are [configurable](CONFIG.md) during compilation):


* improved keyboard scanning, resistant to ghosting and joystick interference (one variant even supports multi-key rollover), supports additional C128 keys
* joystick can be used to move text cursor
* pre-defined function keys

* JiffyDOS and DolphinDOS protocols support
* DOS wedge (direct mode only) - `@<drive_number>`, `@<command>`, `@$`, `@$<params>`, `@`

* turbo tape load support (as device 7, or using `←L`), quite sophisticated: up to 250 blocks (can store bytes under I/O), automatically adjusts for tape speed differences
* normal tape load error log is limited by free stack space only (no artificial limitation like in original ROMs)
* tape format autodetection; normal vs turbo is mostly transparent to user
* improved support for tape adapters (for using regular casette players and other audio devices instead of Datasette) and emulators

* extended `LOAD` command
    * start/end addresses are displayed, in the Final cartridge style
    * command with just the file name tries to use the last device if it's number seems sane; otherwise uses 8
    * secondary address over 255 is considered a start address

* uses RAM under ROM and I/O: 61438 bytes free
* cold/warm start silences multiple SID chips - all $D4xx and $D5xx addresses, configured addresses
* warm start due to BRK prints out the instruction address


NOTE: extra features and their syntax can change in the future!


# Features missing

The following ROM features are currently missing and are not planned due to space considerations:

* full tape support - VERIFY, SAVE, sequential files; tape is considered a legacy medium, so it's support is going to be limited
* mock 6551 emulation - this only complicates the RS-232 support for original ROMs, probably noone needs it

The following ROM features are currently missing:

* most BASIC commands
* BASIC variables
* BASIC expression parsing
* floating point routines
* RS-232 support
* NMI handling is incomplete


# Hardware support status

## Keyboard

<br />

| Driver             | Status   |  Remarks                                           |
| :----------------: | :------: | :------------------------------------------------: |
| C64                | DONE     |                                                    |
| C128               | DONE     |                                                    |
| Mega65             | NOT DONE | code should be complete, but is not tested yet     |

<br />

## Screen

<br />

| Driver             | Status   |  Remarks                                           |
| :----------------: | :------: | :------------------------------------------------: |
| VIC-II             | DONE     |                                                    |
| 80 columns, VDC    | NOT DONE |                                                    |
| 80 columns, Mega65 | NOT DONE |                                                    |

<br />

## Tape port (LOAD only!)

* Tapuino
* Datasette

<br />

| Driver             | Status   |  Remarks                                           |
| :----------------: | :------: | :------------------------------------------------: |
| normal             | DONE     | up to 202 blocks, like original ROM                |
| turbo              | DONE     | up to 250 blocks, like the best implementations    |

<br />

## IEC bus

* SD2IEC, petSD+, µIEC
* Pi1541, Ultimate II
* most disk drives and printers
* some hard drives

<br />

| Driver             | Status   |  Remarks                                           |
| :----------------: | :------: | :------------------------------------------------: |
| standard           | DONE     |                                                    |
| JiffyDOS           | DONE     |                                                    |
| DolphinDOS         | DONE     |                                                    |
| CIA burst mod      | NOT DONE |                                                    |
| Mega65 burst       | NOT DONE |                                                    |

<br />

## IEEE-488 bus

* petSD+
* PET era disk drives and printers
* various scientific equipment

<br />

| Driver             | Status   |  Remarks                                           |
| :----------------: | :------: | :------------------------------------------------: |
| CBM cartridge      | NOT DONE |                                                    |

<br />

## RS-232

* modems (telephone, WiFi)
* parallel port printers

<br />

| Driver             | Status   |  Remarks                                           |
| :----------------: | :------: | :------------------------------------------------: |
| UP2400             | NOT DONE |                                                    |
| UP9600             | NOT DONE | work started, not functional yet                   |
| ACIA 6551          | NOT DONE |                                                    |

<br />

# API status


Status of the various APIs and variables from the original ROMs


## Low memory locations (pages 0 - 3)


For the current status of the low memory location implementation andd usage check [this file](c64/aliases/,aliases_ram_lowmem.s). NOTE: available vector to certain routine does not mean that this routine is fully implemented!


## BASIC

### Official BASIC routines

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
| `($A000)` | `$E394`    | cold start | PARTIAL  |                                                    |
| `($A002)` | `$E3B7`    | warm start | PARTIAL  |                                                    |

<br />


### Math package

Floating point mathematical routines - not official, but well known and broadly used.

<br />

| Address   | Name         | Status   |  Remarks                                           |
| :-------: | :----------- | :------: | :------------------------------------------------: |
| `$B1AA`   | `FACINX`     | NOT DONE | convert FAC1 to 16-bit signed integer              |
| `$B391`   | `GIVAYF`     | NOT DONE | XXX - no stub added yet                            |
| `$B7B5`   | `STRVAL`     | NOT DONE | XXX - no stub added yet                            |
| `$B850`   | `FSUB`       | PARTIAL  | needs `FSUBT`                                      |
| `$B853`   | `FSUBT`      | NOT DONE | subtract FAC1 from FAC2                            |
| `$B867`   | `FADD`       | PARTIAL  | needs `FADDT`                                      |
| `$B86A`   | `FADDT`      | NOT DONE | add FAC2 to FAC1                                   |
| `$B9EA`   | `LOG`        | NOT DONE | XXX - no stub added yet                            |
| `$BA28`   | `FMUL`       | PARTIAL  | needs `FMULT`                                      |
| `$BA2B`   | `FMULT`      | NOT DONE | multiplies FAC1 by FAC2                            |
| `$BA8C`   | `CONUPK`     | PARTIAL  | not fully tested yet                               |
| `$BAE2`   | `MUL10`      | NOT DONE | multiply FAC1 by 10                                |
| `$BAFE`   | `DIV10`      | NOT DONE | divide FAC1 by 10, result is always positive       |
| `$BB0F`   | `FDIV`       | PARTIAL  | needs `FDIVT`                                      |
| `$BB12`   | `FDIVT`      | NOT DONE | divide FAC2 by FAC1, ignores sign                  |
| `$BBA2`   | `MOVFM`      | PARTIAL  | not fully tested yet                               |
| `$BBD4`   | `MOVMF`      | NOT DONE | copy FAC1 to memory location, rounds if asked      |
| `$BBFC`   | `MOVEF`      | NOT DONE | copy FAC2 to FAC1                                  |
| `$BC0F`   | `MOVFA`      | NOT DONE | copy FAC1 to FAC2, skips rounding                  |
| `$BC2B`   | `SIGN`       | NOT DONE | evaluate FAC1 sign                                 |
| `$BC39`   | `SGN`        | NOT DONE | XXX - no stub added yet                            |
| `$BC58`   | `ABS`        | NOT DONE | XXX - no stub added yet                            |
| `$BC5B`   | `FCOMP`      | NOT DONE | compare FAC1 with RAM location                     |
| `$BC9B`   | `QINT`       | NOT DONE | XXX - no stub added yet                            |
| `$BCCC`   | `INT`        | NOT DONE | XXX - no stub added yet                            |
| `$BCF3`   | `FIN`        | NOT DONE | XXX - no stub added yet                            |
| `$BDDD`   | `FOUT`       | NOT DONE | XXX - no stub added yet                            |
| `$BF71`   | `SQR`        | NOT DONE | XXX - no stub added yet                            |
| `$BF78`   | `FPWR`       | NOT DONE | set FAC1 as RAM raised to the power of FAC1        |
| `$BF7B`   | `FPWRT`      | NOT DONE | set FAC1 as FAC2 raised to the power of FAC1       |
| `$BFB4`   | `NEGOP`      | DONE     |                                                    |
| `$BFED`   | `EXP`        | NOT DONE | XXX - no stub added yet                            |
| `$E043`   | `POLY1`      | NOT DONE | evaluate polynomial with odd powers only           |
| `$E059`   | `POLY2`      | NOT DONE | evaluate polynomial with odd and even powers       |
| `$E264`   | `COS`        | NOT DONE | cosine of FAC1 in radians                          |
| `$E26B`   | `SIN`        | NOT DONE | sine of FAC1 in radians                            |
| `$E2B4`   | `TAN`        | NOT DONE | tangent of FAC1 in radians                         |
| `$E30E`   | `ATN`        | NOT DONE | XXX - no stub added yet                            |

<br />

### Other unofficial BASIC routines/locations

Not all of them - only these we want to have implemented.

<br />

| Address   | Name         | Status   |  Remarks                                           |
| :-------: | :----------- | :------: | :------------------------------------------------: |
| `$A004`   | revision str | DONE     |                                                    |
| `$A408`   | `REASON`     | NOT DONE |                                                    |
| `$A453`   | (unknown)    | NOT DONE |                                                    |
| `$A533`   | `LINKPRG`    | DONE     |                                                    |
| `$A644`   | new          | NOT DONE |                                                    |
| `$A659`   | set txt ptr  | NOT DONE |                                                    |
| `$A68E`   | `RUNC`       | DONE     |                                                    |
| `$A7AE`   | `NEWSTT`     | PARTIAL  | redirected to RUN command                          |
| `$AB1E`   | `STROUT`     | DONE     |                                                    |
| `$AD9E`   | `FRMEVL`     | NOT DONE |                                                    |
| `$BDCD`   | `LINPRT`     | DONE     | temporary implementation                           |
| `$E3BF`   | `INIT`       | NOT DONE |                                                    |
| `$E422`   | `INITMSG`    | DONE     |                                                    |
| `$E453`   | `RVECT`      | NOT DONE |                                                    |

<br />

## Kernal

### Official Kernal routines

NOTE: Even the 'DONE' routines won't support features described as missing in one of the previous chapters!

<br />

| Address   | Unofficial | Name        | Status   |  Remarks                                             |
| :-------: | :--------: | :---------- | :------: | :--------------------------------------------------: |
| `($028F)` |            | `KEYLOG`    | DONE     |                                                      |
| `$FF81`   | `$FF5B`    | `CINT`      | DONE     |                                                      |
| `$FF84`   | `$FDA3`    | `IOINIT`    | DONE     |                                                      |
| `$FF87`   | `$FD50`    | `RAMTAS`    | DONE     |                                                      |
| `$FF8A`   | `$FD15`    | `RESTOR`    | DONE     |                                                      |
| `$FF8D`   | `$FD1A`    | `VECTOR`    | DONE     |                                                      |
| `$FF90`   |            | `SETMSG`    | DONE     |                                                      |
| `$FF93`   |            | `SECOND`    | DONE     |                                                      |
| `$FF96`   |            | `TKSA`      | DONE     |                                                      |
| `$FF99`   | `$FE25`    | `MEMTOP`    | DONE     |                                                      |
| `$FF9C`   |            | `MEMBOT`    | DONE     |                                                      |
| `$FF9F`   |            | `SCNKEY`    | DONE     |                                                      |
| `$FFA2`   |            | `SETTMO`    | DONE     |                                                      |
| `$FFA5`   |            | `ACPTR`     | DONE     |                                                      |
| `$FFA8`   |            | `CIOUT`     | DONE     |                                                      |
| `$FFAB`   |            | `UNTLK`     | DONE     |                                                      |
| `$FFAE`   |            | `UNLSN`     | DONE     |                                                      |
| `$FFB1`   |            | `LISTEN`    | DONE     |                                                      |
| `$FFB4`   |            | `TALK`      | DONE     |                                                      |
| `$FFB7`   |            | `READST`    | DONE     |                                                      |
| `$FFBA`   |            | `SETFLS`    | DONE     |                                                      |
| `$FFBD`   |            | `SETNAM`    | DONE     |                                                      |
| `$FFC0`   | `$F34A`    | `OPEN`      | DONE     |                                                      |
| `$FFC3`   | `$F291`    | `CLOSE`     | DONE     |                                                      |
| `$FFC6`   | `$F20E`    | `CHKIN`     | DONE     |                                                      |
| `$FFC9`   | `$F250`    | `CKOUT`     | DONE     |                                                      |
| `$FFCC`   | `$F333`    | `CLRCHN`    | DONE     |                                                      |
| `$FFCF`   | `$F157`    | `CHRIN`     | PARTIAL  | no screen device support                             |
| `$FFD2`   | `$F1CA`    | `CHROUT`    | DONE     |                                                      |
| `$FFD5`   | `$F49E`    | `LOAD`      | DONE     |                                                      |
| `($0330)` | `$F4A5`    | `LOAD`      | DONE     |                                                      |
| `$FFD8`   | `$F5DD`    | `SAVE`      | DONE     |                                                      |
| `($0332)` | `$F5ED`    | `SAVE`      | DONE     |                                                      |
| `$FFDB`   |            | `SETTIM`    | DONE     |                                                      |
| `$FFDE`   |            | `RDTIM`     | DONE     |                                                      |
| `$FFE1`   | `$F6ED`    | `STOP`      | DONE     |                                                      |
| `$FFE4`   | `$F13E`    | `GETIN`     | PARTIAL  | no screen device support                             |
| `$FFE7`   | `$F32F`    | `CLALL`     | DONE     |                                                      |
| `$FFEA`   |            | `UDTIM`     | DONE     |                                                      |
| `$FFED`   |            | `SCREEN`    | DONE     |                                                      |
| `$FFF0`   | `$E50A`    | `PLOT`      | DONE     |                                                      |
| `$FFF3`   |            | `IOBASE`    | DONE     |                                                      |
| `($FFFA)` |            | NMI vec     | PARTIAL  |                                                      |
| `($FFFC)` | `$FCE2`    | RESET vec   | DONE     |                                                      |
| `($FFFE)` |            | IRQ/BRK vec | DONE     |                                                      |

<br />

### Unofficial Kernal routines/locations

Not all of them - only these we want to have implemented.

<br />

| Address   | Name                         | Status   |  Remarks                                           |
| :-------: | :--------------------------- | :------: | :------------------------------------------------: |
| `$E518`   | legacy part of CINT          | DONE     |                                                    |
| `$E51B`   | init screen keyboard, no VIC | DONE     |                                                    |
| `$E544`   | clear screen                 | DONE     |                                                    |
| `$E50C`   | set cursor position          | DONE     |                                                    |
| `$E566`   | home cursor                  | DONE     |                                                    |
| `$E56C`   | set PNT and USER values      | DONE     |                                                    |
| `$E5A0`   | setup VIC II & I/O           | DONE     |                                                    |
| `$E6B6`   | advance cursor               | NOT DONE |                                                    |
| `$E701`   | previous line                | NOT DONE |                                                    |
| `$E716`   | screen CHROUT                | NOT DONE |                                                    |
| `$E8DA`   | color code table             | DONE     |                                                    |
| `$E8EA`   | scroll logical line up       | DONE     |                                                    |
| `$E96C`   | insert line on top           | NOT DONE |                                                    |
| `$E9FF`   | clear line                   | DONE     |                                                    |
| `$EA31`   | default IRQ                  | PARTIAL  |                                                    |
| `$EA7E`   | ack CIA1 + below             | DONE     |                                                    |
| `$EA81`   | ret from IRQ/NMI             | DONE     |                                                    |
| `$F142`   | get key from buffer          | DONE     |                                                    |
| `$F3F6`   | (unknown)                    | NOT DONE |                                                    |
| `$F646`   | IEC close                    | NOT DONE |                                                    |
| `$FD30`   | default vectors              | DONE     |                                                    |
| `$FD90`   | (unknown)                    | NOT DONE |                                                    |
| `$FE2D`   | memtop set part              | DONE     |                                                    |
| `$FE47`   | default NMI                  | PARTIAL  |                                                    |
| `$FE66`   | default BRK                  | DONE     |                                                    |
| `$FF80`   | revision byte                | DONE     |                                                    |

<br />
