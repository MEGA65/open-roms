
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
* `PRINT USING`, ability to position cursor, ability to print result in the center of the screen
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
* it should be possbile to assign to `TI` special variable 
* function to insert a substring starting from given position
* function to generate string of n duplicated characters
* function to retrieve fractional part of a number
* command to fill text screen area with a character, inverse screen area, scroll, or change fg/bg color of screen area
