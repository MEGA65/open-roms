
# Configuring the build

It's not possible to provide ROM builds that suit everyone needs - therefore configuration files were introduced, few predefined configurations are provided with sane defaults:

* [`src/,,config_custom.s`](src/,,config_custom.s)
* [`src/,,config_generic.s`](src/,,config_generic.s)
* [`src/,,config_mega65.s`](src/,,config_mega65.s)
* [`src/,,config_ultimate64.s`](src/,,config_ultimate64.s)
* [`src/,,config_testing.s`](src/,,config_testing.s)

Just edit them and recompile the project. To enable particular option:
* change YES to NO, decimal string, or hex string precedeed with `$`
* change YES to a string enclosed in `"`; within the string you can place `\"` to include quote character, or `\xx`, where `xx` is a hexadecimal code for the given PETSCII displayable character; always use uppercase letters

Note however, that features do not came for free - enabling them needs some additional ROM space (in BASIC segment, in KERNAL segment, or in both), which is VERY limited on the target machines. Some options might be unavailable for speecific targets - read the comments in the configuration files. Some options might also carry compatibility and/or performance hit - so choose wisely.

## Hardware platform

### `PLATFORM_COMMODORE_64`

Commodore 64 is the only hardware platform available now - and the main one, as the Open ROMs API is meant to be compatible with the Commodore 64.

Since Open ROMs is highly modular, it should be possible to add other platforms in the future (like 8-bit Atari computers or Commander X16), if they share the following common characteristics:

* MOS 6502 CPU or compatible
* 8KB ROM area `$A000`-`$BFFF`
* 8KB ROM area `$E000`-`$FFFF`

### `MB_M65`, `MB_U64`

Select if the ROM is going to be used exclusively on the specified motherboard. It prevents from enabling options not having sense, skips initialization of C128-only registers, and enables motherboard-specific features.

### `ROM_CRT`

Has to be set for builds utilizing cartridge image as a ROM extension.

## Brand

Branding is only allowed for C64 platform, if no motherboard is specified.

### `BRAND_CUSTOM_BUILD`

Intended for custom builds, for private purposes - expects a string.

### `BRAND_GENERIC`

If you don't know which variant to choose - select this one.

### `BRAND_TESTING`

Use this one for any kind of testing/experimental build.

## Processor instruction set

Processor type should be set only for C64 platform, if no motherboard is specified. Otherwise, it will be selected automatically. Setting proper CPU allows to enable various size/performance optimizations.

### `CPU_MOS_6502`

Choose if your CPU only supports the original MOS Technology 6502 instruction set, like:

* MOS 6510 - used in the Commodore 64
* MOS 8500 - used in the Commodore 64C
* MOS 8502 - used in the Commodore 128

If unsure - select this one.

### `CPU_DTV_6502`

Choose if your CPU only supports extended C64 DTV instruction set.

### `CPU_RCW_65C02`

Choose if your CPU supports the Rockwell 65C02 instruction set.

### `CPU_WDC_65C02`

Choose if your CPU supports the Western Design Center 65C02 instruction set, like:

* WDC 65C02 - used in the Turbo Master accelerator

### `CPU_WDC_65816`

Choose if your CPU supports the 16-bit Western Design Center 65816 instruction set, like:

* WDC 65C816 - used in the Flash 8 accelerator
* WDC 65C816S - used in the SuperCPU accelerator

### `CPU_CSG_65CE02`

Choose if your CPU supports the Commodore Semiconductor Group 65CE02 instruction set, like:

* CSG 65CE02 
* CSG 4510 - microcontroller used in the Commodore 65 prototypes

## Memory model

Different layouts of memory are possible - but they can be selected at compile time only.

### `MEMORY_MODEL_38K`

Memory model the original machine uses - memory available for BASIC ends at `$9FFF`, just before the first block of ROM. The fastest and the most compatible, but gives the least memory for BASIC. If unsure - select this one.

### `MEMORY_MODEL_46K` and `MEMORY_MODEL_50K`

These models additionaly use RAM under BASIC, and the 50K additionally takes over `$C000`-`$CFFF` range. They should still be highly compatible (no additional RAM for helper routines is needed), and the performance penalty should be much lower than 60K model.

### `MEMORY_MODEL_60K`

Uses RAM under BASIC, I/O and KERNAL, takes over `$C000`-`$CFFF` area requires special helper routines installed in `$2A7`-`$2FF` area (normally unused and free for the user). Gives the most free memory for BASIC programs, but it's the slowest (for example, forces disabling optimized LOAD loop for JiffyDOS) and the least compatible model.

It is currently not compatible with MEGA65 extended ROMs.

Comparing to standard memory model, it needs about 180 bytes in BASIC segment and 80 bytes in KERNAL segment - at the moment of doing the test, these values are expected to change often.

## IEC bus

IEC bus, also known as Serial Port, is a standard interface to connect disk drives, printers, SD2IEC device, etc.

### `IEC`

Adds support for the IEEC bus - for serial printers, disk drives, etc.

Needs over 1000 bytes in KERNAL segment. If unsure - enable.

### `IEC_DOLPHINDOS`

Adds support for DolphinDOS fast protocol to the IEC bus, using UserPort cable.

Needs about 160 bytes in KERNAL segment. If unsure - enable.

### `IEC_DOLPHINDOS_FAST`

Faster `LOAD` loop implementation for DolphinDOS protocol.

Needs 20 more bytes in KERNAL segment.

### `IEC_JIFFYDOS`

Adds support for JiffyDOS fast protocol to the IEC bus.

Needs about 430 bytes in KERNAL segment. If unsure - enable.

### `IEC_JIFFYDOS_BLANK`

Causes screen blanking during JiffyDOS file loading to increase performance. On Ultimate 64 motherboard, if possible, screen blanking is substituted by disabling badlines.

## Tape deck

Note: for MEGA65 most of the tape support code is placed in it's extended ROM; very little of the (tiny) KERNAL segment is used.

### `TAPE_NORMAL`

Adds a minimal normal (standard Commodore format) tape support - just LOAD command.

Needs about 1050 bytes in KERNAL segment (if both normal and turbo are enabled, about 900 bytes are needed, as they share some code). If unsure - enable.

### `TAPE_TURBO`

Adds a minimal turbo tape support - just LOAD command (device 7, like on _Action Replay_ and _Final_ cartridges), up to 250 blocks

Needs about 700 bytes in KERNAL segment (if both normal and turbo are enabled, about 1300 bytes are needed, as they share some code). If unsure - enable.

### `TAPE_AUTODETECT`

Tape format (normal/turbo) is always autodetected.

Needs about 100 more bytes in KERNAL segment.

### `TAPE_NO_KEY_SENSE`

Enable this option if you are using a tape interface adapter with some audio signal source connected. These adapters lack key sense functionality, so the computer is unable to tell whether Play got pressed or not - this option changes the ROM behaviour, so that it can detect Play pressed when impulses start arriving from the tape.

### `TAPE_NO_MOTOR_CONTROL`

Enable this option if you are using a tape interface adapter lacking tape motor control (most likely every adapter currently being sold) - this will eliminate the need to quickly press space when the program header information gets displayed. Note: if you are using a cassette player with REM port, and your adapter is connected to this port too, than you do not need this option.

## Additional storage

### `UNIT_SDCARD`, `UNIT_FLOPPY`, `UNIT_RAMDISK`

MEGA65 specific pseudo-IEC devices, handled by internal DOS (work in progress). If set to 0, given unit is disabled. Otherwise - assigns IEC unit number to the given storage.

## Sound support

The original Commodore 64 had one SID sound chip installed. However, mods exists to add more of them for improved sound capabilities. Emulators and FPGA machines typically allow to simulate more than one too. Unfortunately, there is no standard regarding how these additional chips are visible in the processor address space, and there is no sane way to detect it - thus, it has to be configurable.

The SID support in the ROM is very limited - it only disables the sound during startup or warm restart (when STOP+RESTORE is pressed or BRK assembler instruction is executed).

### `SID_2ND_ADDRESS` and `SID_3RD_ADDRESS` 

Each of them adds support for one additional SID - addresses should be given as parameters. Do not use when `MB_M65` is selected - the motherboard support code already knows the SID locations. 

Each of these options needs 3 bytes in KERNAL segment.

### `SID_D4XX`, `SID_D5XX`, `SID_D6XX` and `SID_D7XX`

Enables support for SIDs in `$D4xx` / `$D5xx` / `$D6xx` / `$D7xx` ranges, respectively.

Each of them needs a couple of bytes in KERNAL segment - but they can share some code, and `$D4xx` range support replaces the standard `$D400` address handling, so exact amount depends on the exact configuration. Do not use when `MB_M65` is selected - the motherboard support code already knows the SID locations.

## Keyboard

Original keyboard support routine is just horrible. It does nothing to prevent ghosting - press A+S+D at the same time - it prints F. Try to use joystick connected to control port 1 - it outputs phantom characters. The Open ROMs provides much more sophisticated routines to prevent such problems.

### `KEYBOARD_C128`

Allows to use additional keys found on the C128 keyboard.

Needs about 130 bytes more space in KERNAL segment. If unsure - disable.

### `KEYBOARD_C128_CAPS_LOCK`

Allows to use CAPS LOCK key on the C128 keyboard, this is independent from `KEYBOARD_C128`. Support is C64-safe (there is a protection against false-positive reading on the C64).

Needs about 50 bytes more space in KERNAL segment. If unsure - disable.

### `KEY_REPEAT_DEFAULT`

Enables key repetition by default during the startup (sets `RPTFLG`).

Needs 5 bytes more space in KERNAL segment.

### `KEY_REPEAT_ALWAYS`

Enables the key repetition and ignores `RPTFLG`.

Saves 22 bytes from KERNAL segment.

### `KEY_FAST_SCAN`

Performs somee speed optimizations in the keyboard scanning routine, at the expense of some more ROM space.

Needs 13 bytes more space in KERNAL segment. Only disable if you are running out of ROM space.

### `JOY1_CURSOR` and `JOY2_CURSOR`

Use joystick to move the cursor. On MEGA65 applies to legacy mode only (on native mode there is BASIC command available to set this option in runtime).

Needs about 65 bytes of ROM space in KERNAL segment to handle both joysticks.

### `PROGRAMMABLE_KEYS`

Allows to assign commands to any function key, `RUN` key and `HELP` key (if selected keybaord has one) - just fill-in appropriate `KEYCMD_*` variable(s). Keys not present on the selected keyboard are ignored.

Needs 25 bytes more space in KERNAL segment for the code. In addition, each configured key takes 3 bytes + length of the command.

## Screen editor

### `EDIT_STOPQUOTE`

If enabled, STOP key terminates insert/quote mode (like on some _Black Box_ cartridges).

Feature needs 12 bytes in KERNAL segment. If unsure - enable.

### `VIC_PALETTE`

Selects the default system palette - MEGA65 only.

## Software features

### `PANIC_SCREEN`

If enabled, certain fatal errors will produce a nice bluescreen instead of just resetting the machine.

Feature needs over 100 bytes in KERNAL segment. If unsure - enable.

### `DOS_WEDGE`

If enabled, a simple DOS wedge is available from the direct mode - supports `@<drive_number>`, `@<command>`, `@$`, `@$<params>` and `@` commands.

Feature needs about 330 bytes in BASIC segment. If unsure - enable.

### `TAPE_WEDGE`

If enabled, a simple DOS wedge is available from the direct mode for tape loading - supports `←L` (for `LOAD`) and `←M` (for `MERGE`), optionally with a file name.

Feature needs several bytes in BASIC segment. If unsure - enable.

### `TAPE_HEAD_ALIGN`

If enabled, embeds a tape head align tool into the ROM, it can be started with `←H`. Requires `TAPE_WEDGE`.

Feature needs about 800 bytes in KERNAL segment. Only recomended for machines with extended ROM, like MEGA65.

### `BCD_SAFE_INTERRUPTS`

On the most widespread CPUs the D flag is not cleared upon entering interrupts. Since the original Kernal does not clear it either, it's not safe to use BCD processor mode without disabling the interrupts first. This option makes sure the D flag is disabled at the start of the interrupt - this allows some optimizations in the code.

Feature needs 2 bytes in KERNAL segmment (for CPUs needing the patch), but at the same time allows optimizations allowing to gain some more bytes. If unsure - enable.

## Eye candy

### `COLORS_BRAND`

Tries to adjust the color scheme to the selected brand. Some brands might not support this.

### `BANNER_SIMPLE`, `BANNER_FANCY`

Select startup banner - either a simple one, or with some colorful elements.

Richer banners need more BASIC segment, varies between brands.

### `SHOW_FEATURES`

If enabled, shows the most important compiled-in features on the startup screen. Also shows the video system (PAL/NTSC).

It is recommended to keep it enabled for informational purposes.

## Debug options

Options in this section are for debug purposes only. If unsure - disable.

### `DBG_STUBS_BRK`

Replaces `RTS` stubbed routines implementation with one causing a break.

### `DBG_PRINTF`

Makes `printf` routine available.

## Other options

### `COMPRESSION_LVL_2`

Adds additional step in compressing BASIC interpreter strings - a dictionary compression. Not tested extensively - and for now it won't bring any improvement (it will even increase the code/data size) as we do not have enough strings yet to make this method useful. Do not use!
