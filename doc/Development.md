
# OpenROMs development guide

NOTE: this document is a preliminary version, definitely incomplete!


## In-depth protocol description

- [JiffyDOS](./Protocol-JiffyDOS.md) 
- [DolphinDOS](./Protocol-DolphinDOS.md) 


## Guidelines for software developers for OpenROMs compatibility

Most important: always test your software on the original ROMs too. If your code works on the OpenROMs, but fails on the original firmware - than something is clearly wrong, and it might stop working once we make OpenROMs more compatible for one reason or another.

### Unofficial ROM APIs

Please, do not use any internal/unofficial OpenROMs API. They WILL change in an incompatible way, you may believe me. Using unofficial API of the original ROMs is OK if the routine is marked as supported in the [implementation status](../STATUS.md) document.

### Compatibility with OpenROMs for Mega65

The Mega65 OpenROMs build aims to provide a C64-compatible memory map in range `$00000-$0FFFF`. For `$10000` and above, everything is still subject to change.

Please note, that certain ROM routines are moved to additional Mega65 ROM area (2x8KB is not enough to implement full ROM functionality and additional features) - original locations contain just short compatibility code which remaps memory, calls the real routine, and restores default mapping (that means all blocks unmapped). This shouldn't be a problem for original C64 software, but can make a difference for Mega65-aware code; thus, please follow these simple rules:

- do not call ROM routines with .B set to anything other than 0 (and .B set to 0x40 or above is a receipe for disaster!)
- be aware that ROM routines may restore the default memory mapping by means of MAP/EOM

OpenROMs interrupt handlers do not touch the ROM mapping, range `0x4000-0xBFFF` can be freely mapped without disabling IRQ or NMI. The .Z register is mostly safe to use too - some routines might use it, but they will alwayys restore it's previous state. Please be aware, that for maximum compatibility our IRQ/NMI handlers DO NOT store/restore .Z register.

### API extensions

#### PETSCII

OpenROMs provides support for several additional PETSCII codes (all compatible with C128 and/or C65):

| PETSCII code | description                                         |
| :----------: | :-------------------------------------------------- |
| `$07`        | bell (C128 and C65 compatible), not implemented yet |
| `$1B`        | `ESC` key (C128 and C65 compatible)                 |
| `$84`        | `HELP` key (C128 and C65 compatible)                |
| `$10`        | `F9` key (C65 compatible)                           |
| `$15`        | `F10` key (C65 compatible)                          |
| `$16`        | `F11` key (C65 compatible)                          |
| `$17`        | `F12` key (C65 compatible)                          |
| `$19`        | `F13` key (C65 compatible)                          |
| `$1A`        | `F14` key (C65 compatible)                          |

There is no official PETSCII code for `TAB` - we can't utilize the ones from C128 or C65 because it conflicts with some C64 codes.

#### Bucky keys

`SHFLAG` (`$028D`) variable is extended to support additional bucky keys on C128 and C65 keyboards:

| bits 7-5 | bit 4       | bit 3    | bit 2    | bit 1    | bit 0    |
| :------: | :---------: | :------: | :------: | :------: | :------: |
| reserved | `CAPS LOCK` | `ALT`    | `CTRL`   | `VENDOR` | `SHIFT`  |

Bits 3 and 4 are extension to the original variable, compatible with the C128 ROMs API. There is no official way to retrieve `NO_SCRL` status as of yet. The `40/80` key status cannot be retrieved in C64 mode at all (C128 hardware limitation).

#### NMI vector modification

Before modifying NMI vector, set it's high byte to 0. The ROM routine considers such address invalid and won't try to call the custom code, thus preventing a crash if interrupt happens in the worst possible moment.

#### Mega65 native mode

Mega65 build starts in legacy mode, which is intended to be reasonably compatible with the C64 ROMs. However, a native Mega65 mode is planned too, to make it easier to utilise extra features of this machine. Soo far the following has been done:

- Slightly different chargen. On C64 machines pressing C= + G or C= + M key combinations produces the same visual result as C= + H or C= + N, respectively - despite keycap printing suggests they should produce tinner bars. This was intentional change in the C64 ROMs (compared to VIC-20), to prevent colour problems on 80s era TVs. Screen font used in the legacy mode duplicates this change, but the font intended for native mode has this change reverted back. Additionally, the π sign is available for lower/upper case set too.

## Tinkering with OpenROMs

Make sure to read the main [README](../README.md) first - although any help with the project is always welcome, you need to be aware of the possible legal problems we want to avoid.

### Make targets

List of the most important make targets:

| target              | description                                                                    |
| :------------------ | :----------------------------------------------------------------------------- |
| `all`               | builds all ROMs, places them in 'build' subdirectory                           |
| `clean`             | removes all the compilation results and intermediate files                     |
| `updatebin`         | upates ROMs in 'bin' subdirectory - with embedded version string, for release  |
| `testsimilarity`    | launches the similarity tool, see [README](../README.md)                       |
| `test`              | builds the 'custom' configuration, launches it using VICE emulator             |
| `test_generic`      | builds the default ROMs, for generic C64/C128, launches using VICE             | 
| `test_generic_x128` | as above, but launches C128 emulator instead                                   |
| `test_mega65`       | builds the Mega65 ROM, launches it using XEMU emulator                         |
| `test_ultimate64`   | builds the Ultimate 64 configuration, launches it using VICE emulator          |
| `test_hybrid`       | builds a hybrid ROM (OpenROMs Kernal + original BASIC), launches it using VICE |
| `test_testing`      | builds a rather odd testing configuration, launches it using VICE emulator     |


### Code segments and ROM layouts

Currently there are 3 ROM layouts defined:

- `STD` - with 2 code segments: `BASIC` (`$A000-$E4D2`, where `$C000-$DFFF` is a skip-gap for RAM and I/O area) and `KERNAL` (`$E4D3 - $FFFF`)
- `M65` - where `BASIC` becames `BASIC_0` and `KERNAL` becames `KERNAL_0`, additional segments might be added to the build system in the future; at the moment of writing this document additional 8KB of ROM is defined as `BASIC_1` segment and additional 8KB of ROM is defined as `KERNAL_1` segment
- `X16` - memory layout for the Commander X16 machine

To check for current ROM layout or code segment use KickAssembler preprocessor defines, like `ROM_LAYOUT_STD`, `ROM_LAYOUT_M65`, `SEGMENT_BASIC`, `SEGMENT_KERNAL_1`.

### Fixed location vs floating routines

There are two types of routines (in this chapter routine = single source file):

- fixed location - they are always placed in the location specified by developer; if it's not possible, an error is produced during the compilation
- floating - their location in the ROM segment is determined during the compilation by our build segment tool; from the developer point of view it is random

File name of the fixed location routine adheres to the scheme: `addr.name.s`, where `addr` is a 4-digit hexadecimal number. They should be accompanied with `*.interop` file, describing why the location got fixed - see [README](../README.md) for more information.


### Handling different ROM layouts

For handling different ROM layouts, our build tool provides support for pragma-like comments, in the form:

```
// #LAYOUT# <rom-layout> <code-segment> <action> <parameters>
```

where:

- separators are mandatory - at least one space or tabulation has to be placed
- `<rom-layout>` - currently `STD` or `M65`, asterisk symbol can be used to match any layout
- `<code-segment>` - `KERNAL`, `BASIC`, `KERNAL_0`, `KERNAL_1`, etc., asterisk symbol can be used to match any segment
- `<action>` - what to do when layout and segment match:

| action         | description                                                        |
| :------------- | :----------------------------------------------------------------- |
| `#IGNORE`      | ignore the file completely                                         |
| `#TAKE`        | compile the file normally                                          |
| `#TAKE-FLOAT`  | compile the file, but force it to be floating                      |
| `#TAKE-OFFSET` | shifts the fixed-location address by hex offset given as parameter |

The first match counts, all the remaining ones are dropped. Examples:

```
// #LAYOUT# STD *        #TAKE
// #LAYOUT# *   KERNAL_0 #TAKE
// #LAYOUT# *   *        #IGNORE
```

This is a very common one. For standard ROM layout just take the file. For non-standard ones take it only for compiling `KERNAL_0` segment, ignore it for anything other (like `KERNAL_1`). Another example:

```
// #LAYOUT# M65 KERNAL_0 #TAKE-FLOAT
// #LAYOUT# M65 KERNAL_1 #TAKE
// #LAYOUT# *   *        #IGNORE
```

This can be found in a private (internal) vector table of `KERNAL_1` segment of `M65` layout. For standard ROM part (`KERNAL_0` segment) take it as floating routine (for `KERNAL_0` segment the file provides only labels for the vector table). For `KERNAL_1` segment of `M65` layout, take it as a fixed location-routine; in such case the file will provide a vector table itself. For memory layout other than `M65`, just ignore the file. Yet another example:

```
// #LAYOUT# M65 KERNAL_0 #TAKE
// #LAYOUT# *   *        #IGNORE
```

This is used for memory mapping helper routines, which are only needed for Mega65 build. They will be placed in `KERNAL_0` segment in such case. And the last example:

```
// #LAYOUT# STD *        #TAKE
// #LAYOUT# M65 KERNAL_0 #TAKE
// #LAYOUT# M65 KERNAL_1 #TAKE-FLOAT
// #LAYOUT# *   *        #IGNORE
```

This is for the routine, that on Mega65 goes to `KERNAL_1` segment, but can still be transparently called using fixed location in `KERNAL_0` segment. The code might, for example, look this way:

```
ROUTINE_NAME:

#if (ROM_LAYOUT_M65 && SEGMENT_KERNAL_0)

    jsr     map_KERNAL_1
    jsr_ind VK1__ROUTINE_NAME    // execute routine from KERNAL_1 segment
    jmp     map_NORMAL

#else

    // real routine, ended with RTS

#endif
```

### CPU-specific optimizations

TODO

### Labels and VICE debugging

Make targets which launch the VICE emulator pass al the label to the built-in monitor. Problem can arise if we have multiple labels pointing the same address - in such case VICE monitor displays a warning, and just one of the labels is being recognized. To avoid this problem please select a single main label for the given memory location, and make sure all the others contain `__` - such labels will be filtered out from the symbol file for VICE.
