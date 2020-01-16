
# OpenROMs development guide

Note: preliminary version, incomplete!

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

TODO - additional keys - bucky
TODO - additional keys - PETSCII

## Tinkering with OpenROMs

Make sure to read the main [README](../README.md) first - although any help with the project is always welcome, you need to be aware of the possible legal problems we want to avoid.

### Code segments and ROM layouts

Currently there are 2 ROM layouts defined:

- `STD` - with 2 code segments: `BASIC` (`$A000-$E4D2`, where `$C000-$DFFF` is a skip-gap for RAM and I/O) and `KERNAL` (`$E4D2 - $FFFF`)
- `M65` - where `BASIC` becames `BASIC_0` and `KERNAL` becames `KERNAL_0`, additional segments might be added to the build system in the future; at the moment of writing this document additional 8KB of ROM is defined as `KERNAL_1` segment

To check for current ROM layout or code segment use KickAssembler preprocessor defines, like `ROM_LAYOUT_STD`, `ROM_LAYOUT_M65`, `SEGMENT_BASIC`, `SEGMENT_KERNAL_1`.

### Fixed location vs floating routines

TODO - describe

### Handling different ROM layouts

For handling different ROM layouts, our build tool provides support for pragma-like comments, in the form:

```
// #LAYOUT# <rom-layout> <code-segment> <action>
```

where:

- separators are mandatory - at least one space or tabulation has to be placed
- `<rom-layout>` - currently `STD` or `M65`, asterisk symbol can be used to match any layout
- `<code-segment>` - `KERNAL`, `BASIC`, `KERNAL_0`, `KERNAL_1`, etc., asterisk symbol can be used to match any segment
- `<action>` - what to do when layout and segment match:

| action        | meaning                                       |
| :------------ | :-------------------------------------------- |
| `#IGNORE`     | ignore the file completely                    |
| `#TAKE`       | compile the file normally                     |
| `#TAKE-FLOAT` | compile the file, but force it to be floating |

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

This can be found in a private (internal) jumptable of `KERNAL_1` segmment of `M65` layout. For standard ROM part (`KERNAL_0` segment) take it as floating routine (for `KERNAL_0` segment the file provides only labels for the jumptable). For `KERNAL_1` segment of `M65` layout, take it as a fixed location-routine; in such case the file will provide a jumptable itself. For memory layout other than `M65`, just ignore the file. Yet another example:

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

This is for the routine, that on Mega65 goes to `KERNAL_1` segment, but can still be transparently called using fixed location in `KERNAL_0` segement. The code might, for example, look this way:

```
ROUTINE_NAME:

#if (ROM_LAYOUT_M65 && SEGMENT_KERNAL_0)

    jsr map_KERNAL_1
    jsr KERNAL_1__ROUTINE_NAME    // execute routine from KERNAL_1 segment
    jmp map_NORMAL

#else

    // real routine, ended with RTS

#endif
```

### CPU-specific optimizations

TODO

### Labels and VICE debugging

TODO
