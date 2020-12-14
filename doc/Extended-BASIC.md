
# Extended BASIC

NOTE: Command syntax, behaviour details, and tokens are still subject to change! Currently the availability of some depends on the build configuration, in the future most (if not all) extended commands will be available only on machines with extended ROM, like the *MEGA65*, *Ultimate 64*, or a build utilizing cartridge with external ROM (build marked as *cart*).

## DOS Wedge

The DOS Wedge commands are only available in direct mode, and they have to start from the first character of the line.

### `@` (all)

Displays the error/status read from the current unit. Current unit is either the last device used by any I/O command, the one set by DOS Wedge command, or a default one for the given build.

### `@$[mask]` (all)

Displays the directory of the current unit. Can be followed by mask, like in `LOAD "$mask"`. Does not destroy BASIC program in memory.

### `@<unit_number>` (all)

Changes the current unit number.

### `@<unit_number>$[mask]` (all)

Combines the two above - displays the directory of the selected driove, in one command.

### `@command` (all)

Sends the DOS command to the current unit.

## Tape Wedge

The Tape Wedge commands are only available in direct mode, and they have to start from the first character of the line. It is designed to ressemble wedge from *BlackBox* series of cartridges and several tape turbo implementations.

### `←L ["file_name"]` (all)

Loads the file from tape. Depending on the configuration, it tries to load the file:
* in any format (standard/turbo) - if format autodetection is compiled in
* in *TurboTape 64* format - if turbo support is compiled in
* in the normal CBM format - if only this one is compiled in

### `←M ["file_name"]` (all)

Like above, but merges a BASIC program to the one already stored in memory.

### `←H` or `←HF` (cart, MEGA65)

Launches a built-in tape head alignment tool. Destroys program in memory. Press `RUN/STOP` to terminate the tool. `←HF` is for compatibility with the *BlackBox v3/v4/v8* cartridges.

## Additional BASIC commands - I/O

### Device numbers

* if tape format autodetection is compiled-in, you can load file from tape using either device #1 (CBM compatible way) or from device #7 (in a way compatible with *Final* and *Action Replay* cartridges)
* if autodetection is not available, than device #1 means normal CBM format, and device #7 means *Turbo Tape 64* format

### `MERGE "file_name" [, device_number]` (cart, MEGA65)

Appends the BASIC program from a storage medium to the one currently present in memory.

### `BLOAD "file_name", device_number, start_address` (cart, MEGA65)

Loads a binary file starting from the given memory location. Does not clear variables, does not perform BASIC program relinking, etc. NOTE: for now syntax differs from the BASIC V3.5+ - this will be changed once the necessary BASIC infrastructure is implemented.

### `BVERIFY "file_name", device_number, start_address` (cart, MEGA65)

Verify operation for the binary data starting from a given addres. NOTE: for now syntax differs from the BASIC V3.5+ - this will be changed once the necessary BASIC infrastructure is implemented.

### `BSAVE "file_name", device_number, start_address, end_address` (cart, MEGA65)

Saves the binary data from the given memory area. NOTE: for now syntax differs from the BASIC V3.5+ - this will be changed once the necessary BASIC infrastructure is implemented.

## Additional BASIC commands - screen/keyboard

### `JOYCRSR joy_number` (MEGA65)

Sets the joystick (1 or 2) which moves the screen cursor. Native mode only.

## Additional BASIC commands - misc

### `COLD` (cart, MEGA65)

Resets the machine. In direct mode asks for confirmation first.

### `FAST`, `SLOW` (all)

Tries to switch the machine to turbo mode (or back to 1MHz operation mode) - details differ depending on the configured machine / motherboard. On MEGA65 motherboard this is not available in native mode, it is not designed to run in 1MHz due to using compound CPU instructions usage.

### `OLD` (all)

Tries to restore program destroyed by the `NEW` command or a reset.

### `MEM` (cart, MEGA65)

Displays BASIC memory usage information:
* `TEXT` - size of BASIC program text, always at least 2 bytes are used
* `VARS` - bytes occupied by float and integer variables, string variable descriptors, and function descriptors
* `ARRS` - bytes occupied by arrays (note: for string arrays only descriptors are stored here)
* `STRS` - bytes occupied by strings, also the ones belonging to arrays
* `FREE` - unused space

### `MONITOR` (MEGA65)

Invokes a machine language monitor

### `SYSINFO` (MEGA65)

Displays various system information.

### `CLEAR` (cart, MEGA65)

Clears the screen content.

### `DISPOSE` (cart, MEGA65)

Runs the garbage collector - disposes outdated strings.

### `GO SYS` (MEGA65)

Same as `SYS`, but does not switch to C64 compatibility mode.

### `GO 64`, `GO 65` (MEGA65)

Switches machine to C64 compatibility mode or to MEGA65 native mode. Performs `CLR`

### `IF MEGA65 THEN`, `IF MEGA65 GOTO` (MEGA65)

Special check for running on *MEGA65* motherboard. The `MEGA65` string is not tokenized, therefore it will be listed properly even under original BASIC V2. `MEGA65` is not a variable here - it is still possible to normally use the `ME` variable.
