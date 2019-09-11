
# Configuring the build

It's not possible to provide ROM builds that suit everyone needs - therefore configuration files were introduced, separately for each of the hardware targets:

* [`c64/,,config_generic.s`](c64/,,config_generic.s)
* [`c64/,,config_mega65.s`](c64/,,config_mega65.s)
* [`c64/,,config_ultimate64.s`](c64/,,config_ultimate64.s)

Just edit them and recompile the project. To enable particular option - uncomment it by removing leading `//` from before `#define` directive (as you probably guessed, commenting out disables it). Some options are followed by constants - you can change them too to further fine-tune the build.

Note however, that features do not came for free - enabling them needs some additional ROM space (in BASIC segment, in KERNAL segment, or in both), which is VERY limited on the target machines. Some options might be unavailable for speecific targets - read the comments in the configuration files. Some options might also carry compatibility and/or performance hit - so choose wisely.

Sane defaults are already present - different for each target.

## Memory models

Different layouts of memory are possible - but they can be selected at compile time only.

### `CONFIG_MEMORY_MODEL_38K`

Memory model the original machine uses - memory available for BASIC ends at `$9FFF`, just before the first block of ROM. The fastest and the most compatible, but gives the least memory for BASIC. If unsure - select this one.

### `CONFIG_MEMORY_MODEL_46K` and `CONFIG_MEMORY_MODEL_50K`

Planned for the future - not available yet.

### `CONFIG_MEMORY_MODEL_60K`

Uses RAM under BASIC, I/O and KERNAL, takes over `$C000`-`$CFFF` area requires special helper routines installed in `$2A7`-`$2FF` area (normally unused and free for the user). Gives the most free memory for BASIC programs, but it's the slowest and the least compatible model.

Comparing to standard memoryy model, it needs about 180 bytes in BASIC segment and 80 bytes in KERNAL segment - at the moment of doing the test, these values are expected to change often.

## Multiple SID support

The SID is a sound chip - original machine had one installed. However, mods exists to add more of them for improved sound capabilitiee. Emulators and FPGA machines typically allow to simulate more than one too. Unfortunately, there is no standard regarding how these additional chips are visible in the processor address space, and there is no sane way to detect it - thus, it has to be configurable.

The SID support in the ROM is very limited - it only disables the sound during startup or warm restart (when STOP+RESTORE is pressed or BRK assembler instruction is executed).

### `CONFIG_SID_2ND` and `CONFIG_SID_3RD` 

Each of them add support for one additional SID - addresses should be given in `CONFIG_SID_2ND_ADDRESS` and `CONFIG_SID_3RD_ADDRESS`, respectively.

Each of these options needs 8 bytes in KERNAL segment.

### `CONFIG_SID_D4XX` and `CONFIG_SID_D5XX`

Cause the system to support SIDs in `$D4xx` and `$D5xx` ranges, respectively.

Each of them needs a couple of bytes in KERNAL segment - but they can share some code, and `$D4xx` range support replaces the standard `$D400` address handling, so exact amount depends on the exact configuration.

## Miscelaneous features

### `CONFIG_DOS_WEDGE`

If enabled, a simple DOS wedge is available from the direct mode - supports `@<drive_number>`, `@<command>`, `@$`, `@$<params>` and `@` commands.

Feature needs about 330 bytes in BASIC segment.
