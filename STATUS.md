# New features


Here are the features of the Open ROMs not found in the original ROMs from the 80s (many of them are [configurable](CONFIG.md) during compilation):


* improved keyboard scanning, resistant to ghosting and joystick interference, supports additional C128 keys
* joystick can be used to move text cursor
* pre-defined function keys

* JiffyDOS and DolphinDOS protocols support
* DOS wedge (direct mode only) - `@<unit_number>`, `@<command>`, `@$[mask]`, `@<unit_number>$`, `@<unit_number>$[mask]` `@`
* BASIC extensions, see the [documentation](doc/Extended-BASIC.md) 
* extended / tweaked `LOAD` / `VERIFY` commands
    * start/end addresses are displayed, in the Final cartridge style
    * command with just the file name tries to use the last device if it's number seems sane; otherwise uses 8
    * command without parameters tries to load first file from drive chosen as above
* `LIST` command should never damage the screen if trying to list memory content which is not a BASIC program
* high performance garbage collector

* turbo tape load support (as device 7, or using `←L` / `←M`, optionally with a file name), quite sophisticated: up to 250 blocks (can store bytes under I/O), on MEGA65 motherboard automatically adjusts itself for tape speed differences
* normal tape load error log is limited by free stack space only (no artificial limitation like in original ROMs)
* tape format autodetection; normal vs turbo is mostly transparent to user
* improved support for tape adapters (for using regular casette players and other audio devices instead of Datasette) and emulators
* built-in tape head align tool (only feasible to use on machines with extended memory, like MEGA65)

* uses RAM under ROM and I/O: 51199 bytes free (up to `$CFFF`) by default, but 61438 is also possible
* cold/warm start silences multiple SID chips
* warm start due to BRK prints out the instruction address


NOTE: extra features and their syntax can change in the future!


# Features missing

The following ROM features are currently missing and are not planned due to space considerations:

* full tape support - VERIFY, SAVE, sequential files; tape is considered a legacy medium, so its support is going to be limited
* mock 6551 emulation - this only complicates the RS-232 support for original ROMs, probably noone needs it

The following ROM features are currently missing:

* most BASIC commands
* BASIC integer/float variables/arrays (strings work now, with the exception of undefined arrays)
* BASIC expression handling (again, strings should work now)
* RS-232 support
* NMI handling is incomplete


# Hardware support status

## Keyboard

<br />

| Driver             | Status   |  Remarks                                           |
| :----------------: | :------: | :------------------------------------------------: |
| C64                | DONE     |                                                    |
| C128               | DONE     |                                                    |
| MEGA65             | PARTIAL  | code mostly complete, but not tested yet           |

<br />

## Screen

<br />

| Driver             | Status   |  Remarks                                           |
| :----------------: | :------: | :------------------------------------------------: |
| VIC-II             | DONE     |                                                    |
| 80 columns, VDC    | NOT DONE |                                                    |
| 80 columns, MEGA65 | PARTIAL  | no windowing mode and C65/M65 extra keys support   |

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
| JiffyDOS           | PARTIAL  | LOAD needs improvement for better performance      |
| ELoad v1           | NOT DONE |                                                    |
| DolphinDOS         | DONE     |                                                    |
| CIA burst mod      | NOT DONE |                                                    |
| MEGA65 burst       | NOT DONE |                                                    |

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

## MEGA65 storage

<br />

| Driver             | Status   |  Remarks                                           |
| :----------------: | :------: | :------------------------------------------------: |
| SD card            | PARTIAL  | work-in-progress, can already load files           |
| floppy drive       | NOT DONE |                                                    |
| ram disk           | NOT DONE |                                                    |

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


For the current status of the low memory location implementation andd usage check [this file](src/aliases/,aliases_ram_lowmem.s). NOTE: available vector to certain routine does not mean that this routine is fully implemented!


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

Floating point mathematical routines - not official, but well known and broadly used. Note: there is an awful mess regarding naming (sometimes same name references different routines in different sources), so a custom naming scheme was applied.

<br />

| Address   | Name                   | Status   |  Remarks                                           |
| :-------: | :--------------------- | :------: | :------------------------------------------------: |
| `$A9C4`   | `convert_FAC1_to_INT`  | NOT DONE |                                                    |
| `$AABC`   | `print_FAC1`           | NOT DONE |                                                    |
| `$AF7B`   | `compute_TI`           | NOT DONE |                                                    |
| `$AF7E`   | not named yet          | NOT DONE |                                                    |
| `$AF87`   | `set_FAC1_mantissa`    | DONE     |                                                    |
| `$AF9A`   | `compute_ST`           | DONE     |                                                    |
| `$B1AA`   | `FACINX`               | NOT DONE | convert FAC1 to 16-bit signed integer              |
| `$B1BF`   | `convert_FAC1_to_s16`  | NOT DONE |                                                    |
| `$B391`   | `GIVAYF`               | PARTIAL  | not fully tested yet                               |
| `$B3A2`   | `convert_Y_to_FAC1`    | DONE     |                                                    |
| `$B794`   | `convert_u8_A_to_FAC1` | DONE     |                                                    |
| `$B7B5`   | `STRVAL`               | PARTIAL  | Only for 38k memory model                          |
| `$B7F7`   | `convert_FAC1_to_ADDR` | NOT DONE |                                                    |
| `$B849`   | `add_HALF_FAC1`        | DONE     | From the Microsoft BASIC, original name: FADDH     |
| `$B850`   | `sub_MEM_FAC1`         | DONE     |                                                    |
| `$B853`   | `sub_FAC2_FAC1`        | DONE     |                                                    |
| `$B862`   | `add_align_exponents`  | DONE     |                                                    |
| `$B867`   | `add_MEM_FAC1`         | DONE     |                                                    |
| `$B86A`   | `add_FAC2_FAC1`        | DONE     |                                                    |
| `$B8D2`   | `abs_and_normal_FAC`   | DONE     | From the Microsoft BASIC, original name: FADFLT    |
| `$B8FE`   | `normal_FAC1`          | DONE     |                                                    |
| `$B947`   | `inv_FAC1_mantissa`    | DONE     | From the Microsoft BASIC, original name: NEGFAC    |
| `$B96F`   | `inc_FAC1`             | DONE     | From the Microsoft BASIC, original name: INCFAC    |
| `$B983`   | `shiftr_FAC1`          | DONE     | From the Microsoft BASIC, original name: SHIFTR    |
| `$B9EA`   | `log_FAC1`             | PARTIAL  | not fully tested yet                               |
| `$BA28`   | `mul_MEM_FAC1`         | DONE     |                                                    |
| `$BA2B`   | `mul_FAC2_FAC1`        | DONE     |                                                    |
| `$BA8C`   | `mov_MEM_FAC2`         | DONE     |                                                    |
| `$BA90`   | `get_FAC2_via_INDEX`   | DONE     |                                                    |
| `$BAE2`   | `mul10_FAC1`           | DONE     |                                                    |
| `$BAFE`   | `div10_FAC1_p`         | DONE     |                                                    |
| `$BB0F`   | `div_MEM_FAC1`         | DONE     |                                                    |
| `$BB12`   | `div_FAC2_FAC1`        | DONE     |                                                    |
| `$BBA2`   | `mov_MEM_FAC1`         | DONE     | From the Microsoft BASIC, original name: MOVFM     |
| `$BBA6`   | `get_FAC1_via_INDEX`   | DONE     | From the Microsoft BASIC, no label                 |
| `$BBC7`   | `mov_r_FAC1_TMP2`      | DONE     | From the Microsoft BASIC, original name: MOV2F     |
| `$BBCA`   | `mov_r_FAC1_TMP1`      | DONE     | From the Microsoft BASIC, original name: MOV1F     |
| `$BBD0`   | `mov_r_FAC1_VAR`       | DONE     | From the Microsoft BASIC, original name: MOVVF     |
| `$BBD4`   | `mov_r_FAC1_MEM`       | DONE     | From the Microsoft BASIC, original name: MOVMF     |
| `$BBFC`   | `mov_FAC2_FAC1`        | DONE     | From the Microsoft BASIC, original name: MOVFA     |
| `$BC0C`   | `mov_r_FAC1_FAC2`      | DONE     | From the Microsoft BASIC, original name: MOVAF     |
| `$BC0F`   | `mov_FAC1_FAC2`        | DONE     | From the Microsoft BASIC, original name: MOVEF     |
| `$BC1B`   | `round_FAC1`           | PARTIAL  | not fully tested yet                               |
| `$BC2B`   | `sgn_FAC1_A`           | DONE     | From the Microsoft BASIC, original name: SIGN      |
| `$BC39`   | `sgn_FAC1`             | DONE     | From the Microsoft BASIC, original name: SGN       |
| `$BC3C`   | `convert_A_to_FAC1`    | DONE     |                                                    |
| `$BC44`   | `convert_i16_to_FAC1`  | DONE     |                                                    |
| `$BC58`   | `abs_FAC1`             | DONE     | From the Microsoft BASIC, original name: ABS       |
| `$BC5B`   | `FCOMP`                | DONE     |                                                    |
| `$BC9B`   | `QINT`                 | DONE     | From the Microsoft BASIC, original name: QINT      |
| `$BCCC`   | `int_FAC1`             | DONE     | From the Microsoft BASIC, original name: INT       |
| `$BCE9`   | `clear_FAC1`           | DONE     | From the Microsoft BASIC, original name: CLRFAC    |
| `$BCF3`   | `FIN`                  | PARTIAL  | Only for 38k memory model + not fully tested yet   |
| `$BD7E`   | `FINLOG`               | DONE     |                                                    |
| `$BDDD`   | `FOUT`                 | NOT DONE | outputs FAC1 to string at $0100                    |
| `$BF71`   | `sqr_FAC1`             | PARTIAL  | needs `sqr_FAC2`                                   |
| `$BF74`   | `sqr_FAC2`             | NOT DONE |                                                    |
| `$BF78`   | `pwr_FAC2_MEM`         | PARTIAL  | needs `pwr_FAC2_FAC1`                              |
| `$BF7B`   | `pwr_FAC2_FAC1`        | NOT DONE |                                                    |
| `$BFB4`   | `toggle_sign_FAC1`     | DONE     |                                                    |
| `$BFED`   | `exp_FAC1`             | NOT DONE |                                                    |
| `$E043`   | `poly1_FAC1`           | PARTIAL  | not fully tested yet                               |
| `$E059`   | `poly2_FAC1`           | PARTIAL  | not fully tested yet                               |
| `$E097`   | `rnd_FAC1`             | DONE     |                                                    |
| `$E09A`   | `rnd_A`                | DONE     |                                                    |
| `$E0BE`   | `rnd_generate`         | DONE     |                                                    |
| `$E264`   | `cos_FAC1`             | PARTIAL  | not fully tested yet                               |
| `$E26B`   | `sin_FAC1`             | PARTIAL  | not fully tested yet                               |
| `$E2B4`   | `tan_FAC1`             | PARTIAL  | not fully tested yet                               |
| `$E30E`   | `atn_FAC1`             | PARTIAL  | not fully tested yet                               |

<br />

In addition to the routines, the following floating-number constants are available at their original locations:

| Address   | Name                        | Status   |  Remarks                                      |
| :-------: | :-------------------------- | :------: | :-------------------------------------------: |
| `$AEA8`   | `const_PI`                  | DONE     | π                                             |
| `$B1A5`   | `const_NEG_32768`           | DONE     | -32768                                        |
| `$B9BC`   | `const_ONE`                 | DONE     | 1.0                                           |
| `$B9D6`   | `const_INV_SQR_2`           | DONE     | 1.0 / sqr(2.0)                                |
| `$B9DB`   | `const_SQR_2`               | DONE     | sqr(2.0)                                      |
| `$B9E0`   | `const_NEG_HALF`            | DONE     | -0.5                                          |
| `$B9E5`   | `const_LOG_2`               | DONE     | log_e(2.0)                                    |
| `$BAF9`   | `const_TEN`                 | DONE     | 10.0                                          |      
| `$BF11`   | `const_HALF`                | DONE     | 0.5                                           |
| `$BFBF`   | `const_INV_LOG_2`           | DONE     | 1.0 / log_e(2.0)                              |
| `$BFE8`   | `const_ONE` duplicate       | DONE     | 1.0                                           |
| `$E2E0`   | `const_HALF_PI`             | DONE     | PI / 2.0                                      |
| `$E2E5`   | `const_DOUBLE_PI`           | DONE     | PI * 2.0                                      |
| `$E2EA`   | `const_QUARTER`             | DONE     | 0.25                                          |
| `$E309`   | `const_DOUBLE_PI` duplicate | DONE     | PI * 2.0                                      |

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
| `$AD9E`   | `FRMEVL`     | PARTIAL  |                                                    |
| `$BDCD`   | `LINPRT`     | DONE     | temporary implementation                           |
| `$E3A2`   | `MOVCHG`     | DONE     | memory model 38K only                              |
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
| `$E536`   | init screen ?                | PARTIAL  |                                                    |
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
| `$EB48`   | set keyboard mapping table   | DONE     |                                                    |
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

### API extensions - MEGA65 build

Note: this is likely to change in the future, possibly in an incompatible way!

<br />

| Address   | Name     | Status   |  Remarks                                                               |
| :-------: | :------- | :------: | :--------------------------------------------------------------------: |
| ?         | MONITOR  | WIP      | launches a machine language monitor                                    |
| ?         | BOOTCPM  | WIP      | launches the CP/M operating system                                     |
| ?         | PRHEX    | DONE     | print hex value from .A                                                |
| `$FF7D`   | PRIMM    | DONE     | print immediate, address compatible with C128 and C65 ROMs             |
| `$FFF8`   |          | DONE     | reset vector for usage within hypervisor, starts in legacy mode        |

<br />
