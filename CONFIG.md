
# Configuring the build

It's not possible to provide ROM builds that suit everyone needs - therefore configuration files were introduced, few predefined configurations are provided with sane defaults:

* [`c64/,,config_custom.s`](c64/,,config_custom.s)
* [`c64/,,config_generic.s`](c64/,,config_generic.s)
* [`c64/,,config_mega65.s`](c64/,,config_mega65.s)
* [`c64/,,config_ultimate64.s`](c64/,,config_ultimate64.s)
* [`c64/,,config_testing.s`](c64/,,config_testing.s)

Just edit them and recompile the project. To enable particular option - uncomment it by removing leading `//` from before `#define` directive (as you probably guessed, commenting out disables it). Some options are followed by constants - you can change them too to further fine-tune the build.

Note however, that features do not came for free - enabling them needs some additional ROM space (in BASIC segment, in KERNAL segment, or in both), which is VERY limited on the target machines. Some options might be unavailable for speecific targets - read the comments in the configuration files. Some options might also carry compatibility and/or performance hit - so choose wisely.

## Hardware platform and brand

### `CONFIG_PLATFORM_COMMODORE_64`

Commodore 64 is the only hardware platform available now - and the main one, as the Open ROMs API is meant to be compatible with the Commodore 64.

Since Open ROMs is highly modular, it should be possible to add other platforms in the future (like 8-bit Atari computers or Commander X16), if they share the following common characteristics:

* MOS 6502 CPU or compatible
* 8KB ROM area `$A000`-`$BFFF`
* 8KB ROM area `$E000`-`$FFFF`

### `CONFIG_MB_MEGA_65`, `CONFIG_MB_ULTIMATE_64`

Select if the ROM is going to be used exclusively on the specific motherboard. It prevents from enabling options not having sense, skips initialization of C128-only registers, etc.

### `CONFIG_BRAND_CUSTOM`

Intended for custom builds, which are not to be redistributed. Allows to configure branding with `CONFIG_CUSTOM_BRAND` varaible

### `CONFIG_BRAND_GENERIC`

If you don't know which variant to choose - select this one.

### `CONFIG_BRAND_TESTING`

Use this one for any kind of testing/experimental build.

### `CONFIG_BRAND_MEGA_65`, `CONFIG_BRAND_ULTIMATE_64`

Select if you are using appropriate motherboard.

## Processor instruction set

### `CONFIG_CPU_MOS_6502`

Choose if your CPU only supports the original MOS Technology 6502 instruction set, like:

* MOS 6510 - used in the Commodore 64
* MOS 8500 - used in the Commodore 64C
* MOS 8502 - used in the Commodore 128

If unsure - select this one.

### `CONFIG_CPU_WDC_65C02`

Choose if your CPU supports the Western Design Center 65C02 instruction set, like:

* WDC 65C02 - used in the Turbo Master accelerator

It enables some speed/size code optimizations.

### `CONFIG_CPU_CSG_65CE02`

Choose if your CPU supports the Commodore Semiconductor Group 65CE02 instruction set, like:

* CSG 65CE02 
* CSG 4510 - microcontroller used in the Commodore 65 prototypes

It enables some speed/size code optimizations.

### `CONFIG_CPU_CSG_4510`

Choose if your CPU supports the Commodore Semiconductor Group 4510 instruction set, like:

* CSG 4510 - microcontroller used in the Commodore 65 prototypes

It enables some speed/size code optimizations and allows C65 memory mapping to work.

### `CONFIG_CPU_M65_45GS02`

Choose if you have a Mega65 FPGA board. It enables some speed/size code optimizations and allows Mega65 memory mapping to work.

### `CONFIG_CPU_WDC_65816`

Choose if your CPU supports the 16-bit Western Design Center 65816 instruction set, like:

* WDC 65C816 - used in the Flash 8 accelerator
* WDC 65C816S - used in the SuperCPU accelerator

It enables some speed/size code optimizations.

## Memory model

Different layouts of memory are possible - but they can be selected at compile time only.

### `CONFIG_MEMORY_MODEL_38K`

Memory model the original machine uses - memory available for BASIC ends at `$9FFF`, just before the first block of ROM. The fastest and the most compatible, but gives the least memory for BASIC. If unsure - select this one.

### `CONFIG_MEMORY_MODEL_46K` and `CONFIG_MEMORY_MODEL_50K`

Planned for the future - not available yet.

### `CONFIG_MEMORY_MODEL_60K`

Uses RAM under BASIC, I/O and KERNAL, takes over `$C000`-`$CFFF` area requires special helper routines installed in `$2A7`-`$2FF` area (normally unused and free for the user). Gives the most free memory for BASIC programs, but it's the slowest (for example, forces disabling optimized LOAD loop for JiffyDOS) and the least compatible model.

Comparing to standard memory model, it needs about 180 bytes in BASIC segment and 80 bytes in KERNAL segment - at the moment of doing the test, these values are expected to change often.

## I/O devices

### `CONFIG_IEC`

Adds support for the IEEC bus - for serial printers, disk drives, etc.

Needs over 1000 bytes in KERNAL segment. If unsure - enable.

### `CONFIG_IEC_DOLPHINDOS`

Adds support for DolphinDOS fast protocol to the IEC bus, using UserPort cable.

Needs about 160 buytes in KERNAL segment. If unsure - enable.

### `CONFIG_IEC_DOLPHINDOS_FAST`

Faster `LOAD` loop implementation for DolphinDOS protocol.

Needs 20 more bytes in KERNAL segment.

### `CONFIG_IEC_JIFFYDOS`

Adds support for JiffyDOS fast protocol to the IEC bus.

Needs about 430 bytes in KERNAL segment. If unsure - enable.

### `CONFIG_IEC_JIFFYDOS_BLANK`

Causes screen blanking during JiffyDOS file loading to increase performance.

### `CONFIG_TAPE_NORMAL`

Adds a minimal normal (standard Commodore format) tape support - just LOAD command.

Needs about 700 bytes in KERNAL segment (if both normal and turbo are enabled, about 900 bytes are needed, as they share some code). If unsure - enable.

### `CONFIG_TAPE_TURBO`

Adds a minimal turbo tape support - just LOAD command (device 7, like on _Action Replay_ and _Final_ cartridges), up to 250 blocks

Needs about 650 bytes in KERNAL segment (if both normal and turbo are enabled, about 950 bytes are needed, as they share some code). If unsure - enable.

### `CONFIG_TAPE_TURBO_AUTOCALIBRATE`

Extends the tape turbo load functionality by ability to adjust to tape speed differences.

Needs about 100 bytes in KERNAL segment. If unsure - enable for Datasette or other tape recorder, disable for digital solutions like Tapuino.

### `CONFIG_TAPE_NO_KEY_SENSE`

Enable this option if you are using a tape interface adapter with some audio signal source connected. These adapters lack key sense functionality, so the computer is unable to tell whether Play got pressed or not - with this option ROM will assume Play got pressed after imppulses start arriving from the tape.

### `CONFIG_TAPE_NO_MOTOR_CONTROL`

Enable this option if you are using a tape interface adapter lacking tape motor control (most likely every adapter currently being sold) - this will eliminate the need to quickly press space when the program header information gets displayed. Note: if you are using a cassette player with REM port, and your adapter is connected to this port too, than you do not need this option.

## Multiple SID support

The SID is a sound chip - original machine had one installed. However, mods exists to add more of them for improved sound capabilitiee. Emulators and FPGA machines typically allow to simulate more than one too. Unfortunately, there is no standard regarding how these additional chips are visible in the processor address space, and there is no sane way to detect it - thus, it has to be configurable.

The SID support in the ROM is very limited - it only disables the sound during startup or warm restart (when STOP+RESTORE is pressed or BRK assembler instruction is executed).

### `CONFIG_SID_2ND` and `CONFIG_SID_3RD` 

Each of them add support for one additional SID - addresses should be given in `CONFIG_SID_2ND_ADDRESS` and `CONFIG_SID_3RD_ADDRESS`, respectively.

Each of these options needs 3 bytes in KERNAL segment.

### `CONFIG_SID_D4XX` and `CONFIG_SID_D5XX`

Cause the system to support SIDs in `$D4xx` and `$D5xx` ranges, respectively.

Each of them needs a couple of bytes in KERNAL segment - but they can share some code, and `$D4xx` range support replaces the standard `$D400` address handling, so exact amount depends on the exact configuration.

## Keyboard

Original keyboard support routine is just horrible. It does nothing to prevent ghosting - press A+S+D at the same time - it prints F. Try to use joystick connected to control port 1 - it outputs phantom characters. The Open ROMs provides much more sophisticated routines to prevent such problems.

### `CONFIG_LEGACY_SCNKEY`

Uses old Open ROMs keyboard scanning routine, which is basically example routine by TWW/CTR, hacked to work within Kernal. It's greatest advantage is multi-key rollover, it's disadvantages - it's much less compatible (uses several bytes of memory which are normally free for user software - thus, it is considered legacy for now), does not support all the system variables (`RPTFLG` and `KEYLOG` are unsupported), and ignores the configuration options - this can be changed, but it requires some effort.

Needs 30-250 more space in KERNAL segment (depending on the features enabled for current default routine). If unsure - disable.

### `CONFIG_KEYBOARD_C128`

Allows to use additional keys found on the C128 keyboard.

Needs about 130 bytes more space in KERNAL segment. If unsure - disable.

### `CONFIG_KEYBOARD_C128_CAPS_LOCK`

Allows to use CAPS LOCK key on the C128 keyboard, this is independent from `CONFIG_KEYBOARD_C128`. Support is C64-safe (there is a protection against false-positive reading on the C64).

Needs about 50 bytes more space in KERNAL segment. If unsure - disable.

### `CONFIG_KEYBOARD_C65`, `CONFIG_KEYBOARD_C65_CAPS_LOCK`

Similar, but for C65 keyboard. Please note - the C65 keyboard support is (as of yet) completely untested!

### `CONFIG_KEY_REPEAT_DEFAULT`

Enables key repetition by default during the startup (sets `RPTFLG`).

Needs 5 bytes more space in KERNAL segment.

### `CONFIG_KEY_REPEAT_ALWAYS`

Enables the key repetition and ignores `RPTFLG`.

Saves 22 bytes from KERNAL segment.

### `CONFIG_KEY_FAST_SCAN`

Performs somee speed optimizations in the keyboard scanning routine, at the eexpense of some more ROM space.

Needs 13 bytes more space in KERNAL segment. Only disable if you are running out of ROM space.

### `CONFIG_JOY1_CURSOR` and `CONFIG_JOY2_CURSOR`

Joystick movement also moves the cursor.

Needs about 65 bytes of ROM space in KERNAL segment to handle both joysticks.

### `CONFIG_PROGRAMMABLE_KEYS`

Allows to assign command to any function key, `RUN` key and `HELP` key (if selected keybaord has one) - just fill-in appropriate `CONFIG_KEYCMD_*` variable(s). Keys not present on the selected keyboard are ignored.

Needs 25 bytes more space in KERNAL segment for the code. In addition, each configured key takes 3 bytes + length of the command.

## Screen editor

### `CONFIG_EDIT_STOPQUOTE`

If enabled, STOP key terminates insert/quote mode (like on some _Black Box_ cartridges).

Feature needs 12 bytes in KERNAL segment. If unsure - enable.

### `CONFIG_EDIT_TABULATORS`

If enabled, allows use of TAB (or CTRL+>) and SHIFT+TAB (or CTRL+<) to switch between predefined tabulator positions.

Feature needs 35-45 bytes in KERNAL segment. If unsure - enable.

## Software features

### `CONFIG_PANIC_SCREEN`

If enabled, certain fatal errors will produce a nice bluescreen instead of just resetting the machine.

Feature needs over 100 bytes in KERNAL segment. If unsure - enable.

### `CONFIG_DOS_WEDGE`

If enabled, a simple DOS wedge is available from the direct mode - supports `@<drive_number>`, `@<command>`, `@$`, `@$<params>` and `@` commands.

Feature needs about 330 bytes in BASIC segment. If unsure - enable.

### `CONFIG_TAPE_WEDGE`

If enabled, a simple DOS wedge is available from the direct mode for turbo tape loading - supports `←L` only

Feature needs about 5 bytes in BASIC segment. If unsure - enable.

### `CONFIG_BCD_SAFE_INTERRUPTS`

On the most widespread CPUs the D flag is not cleared upon entering interrupts. Since the original Kernal does not clear it either, it's not safe to use BCD processor mode without disabling the interrupts first. This option makes sure the D flag is disabled at the start of the interrupt - this allows some optimizations in the code.

Feature needs 2 bytes in KERNAL segmment (for CPUs needing the patch), but at the same time allows optimizations allowing to gain some more bytes. If unsure - enable.

## Eye candy

### `CONFIG_COLORS_BRAND`

Tries to adjust the color scheme to the selected brand. Some brands might not support this.

### `CONFIG_BANNER_SIMPLE`, `CONFIG_BANNER_FANCY`, `CONFIG_BANNER_BRAND`

Select startup banner - either a simple one, or with some colorful elements. `CONFIG_BANNER_BRAND` heavily depends on the selected brand, not all the brands support it.

Richer banners need more BASIC segment, varies between brands.

### `CONFIG_SHOW_FEATURES`

If enabled, shows the most important compiled-in features on the startup screen.

It is recommended to keep it enabled for informational purposes.

### `CONFIG_BANNER_PAL_NTSC`

If enabled, prints video system on startup banner. Eye candy only.

Feature needs few bytes in BASIC and about 25 bytes in KERNAL segment.

## Debug options

Options in this section are for debug purposes only. If unsure - disable.

### `CONFIG_DBG_STUBS_BRK`

Replaces `RTS` stubbed routines implementation with one causing a break.

### `CONFIG_DBG_PRINTF`

Makes `printf` routine available.
