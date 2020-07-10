
# Extended BASIC

NOTE: Command syntax, behaviour details, and tokens are still subject to change! Currently the availability of some depends on the build configuration, in the future most (if not all) extended commands will be available only on machines with extended ROM, like the Mega65 or Ultimate 64.

## DOS Wedge

The DOS Wedge commands are only available in direct mode, and they have to start from the first character of the line.

### `@`

Displays the error/status read from the current drive. Current drive is either the last device used by any I/O command, the one set by DOS Wedge command, or 8 as a fallback.

### `@$`

Displays the directory of the current drive. Does not destroy BASIC program in memory.

### `@device_number`

Changes the current drive number.

### `@command`

Sends the DOS command to the current drive.

## Tape Wedge

The Tape Wedge commands are only available in direct mode, and they have to start from the first character of the line.

### `←L ["file_name"]`

Loads the file from tape. Depending on the configuration, it tries to load the file in TurboTape 64 format, in the standard CBM format, or autodetects the file format.

### `←M ["file_name"]`

Like above, but merges a BASIC program to the one already stored in memory.

### `←H`

Launches a built-in tape head alignment tool. Destroys program in memory. Press `RUN/STOP` to terminate the tool.

## Additional BASIC commands

### `COLD`

Resets the machine. In direct mode asks for confirmation first.

### `FAST`

Tries to switch the machine to turbo mode - details differ depending on the configured machine / motherboard.

### `SLOW`

Tries to switch the machine back to 1 MHz operation mode.

### `OLD`

Tries to restore program destroyed by `NEW` or a reset.

### `CLEAR`

Clears the screen content.

### `DISPOSE`

Runs the garbage collector - disposes outdated strings.

### `MERGE "file_name" [, device_number]`

Appends the BASIC program from a storage medium to the one currently present in memory.

### `BLOAD "file_name", device_number, start_address`

Loads a binary file starting from the given memory location. Does not clear variables, does not perform BASIC program relinking, etc. NOTE: for now syntax differs from the BASIC V3.5+ - this will be changed once the necessary BASIC infrastructure is implemented.

### `BVERIFY "file_name", device_number, start_address`

Verify operation for the binary data starting from a given addres. NOTE: for now syntax differs from the BASIC V3.5+ - this will be changed once the necessary BASIC infrastructure is implemented.

### `BSAVE "file_name", device_number, start_address, end_address`

Saves the binary data from the given memory area. NOTE: for now syntax differs from the BASIC V3.5+ - this will be changed once the necessary BASIC infrastructure is implemented.

# Planned BASIC features, when V2 compatibility is reached

Ideas for the future, most of them suitable for Mega65 or other power machines only

* sound support
* 2D graphics support
* turtle graphics
* sprite support, including collision callback
* custom character set support
* sprite/character design within program, in a way similar to Simons BASIC
* joystick/mouse/lightpen/paddle commands/functions
* matrix operations
* `DISPOSE` with variable/array as parameter should remove the variable/array from memory
* `BLOAD`, `BVERIFY` and `BSAVE` should have syntax compatible with BASIC V7/V10
* it should be possible to intercept Kernal errors from BASIC (prevent `?FILE NOT FOUND ERROR IN ...`, etc.); `ON ERROR GOTO` ?
* support for numbers in hexadecimal and binary formats
* `CGOTO` and `CGOSUB` - computatiuonal versions, should accept expressions
* `LABEL`, `LGOTO` and `LGOSUB` - jump to label
* some kind of subroutines with local variable namespace, possibly loaded from disc (like in Warsaw Basic 3.2)
* for Mega65 mode, move variables to a separate memory area, consider extending variable name length
* DOS Wedge should ask (`ARE YOU SURE?`) before removing a file or formating the disc
* `←V` (verify from tape) - if Kernal is extended to offer this feature
* modulo function or opeerator
* `DPEEK`, `DPOKE`, `QPEEK`, `QPOKE` - 2/4 byte `PEEK` and `POKE` variants
* all the functions/commands accepting memory addresses should be able to access the whole Mega65 memory
* ability to limit memory used by basic to standard 38K or to 46K (memory model switch)
* `XOR` operator
* `AUTO` - line auto numbering
* `RENUMBER` for chanign the line numbers
* `IF ... THEN ... ELSE`, `BEGIN ... BEND`
* consider `BOOT` command
* possibly some commands for creating menus and dialog boxes
* more configurable `INPUT`
* `PRINT USING`, `PRINT AT(x, y)`, `PRINT CENTRE`
* `CURSOR` command from BASIC V10
* `RESTORE` should accept lline number as argument
* hex/dec conversion functions
* `DELETE` command to delete several BASIC lines, as in BASIC V10
* `FOR` loop should accept integer variable as index
* `FETCH`, `STASH`, `SWAP` - REU support
* `DMA` command for Mega65
* geoRAM support
* `GO 64` / `GO 65` should enable/disable C64 compatibility mode on Mega65
* `NSYS` for Mega65 - native `SYS` for Mega65, should not switch to C64 compatibilty mode
* `DO ... LOOP`, `DO ... UNTIL`, `DO ... WHILE`, `EXIT`
* `SEEK#` to read-and-forget n bytes
* `RECORD#` command from BASIC V10
* `GETKEY` from BASIC V10
* `HELP` command from BASIC V7/V10
* function to find substring position
* `WINDOW` command from BASIC V7
* functions to return cursor position
* `TRAP` and `RESUME`
* `SET DEF` and `SET DISK` from BASIC V10
* `SLEEP` from BASIC V10
* `TRON` / `TROFF` - program tracing
* `TYPE` command from BASIC V10
* `RUN` should be able to run program from device, as in BASIC V10
* `PAGE` and `DELAY` commands from Simons BASIC, or something similar
* `DUMP` command from Simons BASIC, or something similar
* function to insert a substring starting from given position
* function to generate string of n duplicated characters
* function to retrieve fractional part of a number
* command to fill text screen area with a character, inverse screen area, scroll, or change fg/bg color of screen area
