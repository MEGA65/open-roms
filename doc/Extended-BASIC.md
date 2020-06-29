
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

Launches a built-in tape head alignment tool. Destorys program in memory. Press `RUN/STOP` to terminate the tool.

## Additional BASIC commands

### `FAST`

Tries to switch the machine to turbo mode - details differ depending on the configured machine / motherboard.

### `SLOW`

Tries to switch the machine back to 1 MHz operation mode.

### `OLD`

Tries to restore program destroyed by `NEW` or a reset.

### `MERGE "file_name" [, device_number]`

Appends the BASIC program from a storage medium to the one currently present in memory.

### `BLOAD "file_name", device_number, start_address`

Loads a binary file starting from the given memory location. Does not clear variables, does not perform BASIC program relinking, etc. NOTE: for now syntax differs from the BASIC V3.5+ - this will be changed once the necessary BASIC infrastructure is implemented.

### `BVERIFY "file_name", device_number, start_address`

Verify operation for the binary data starting from a given addres. NOTE: for now syntax differs from the BASIC V3.5+ - this will be changed once the necessary BASIC infrastructure is implemented.

### `BSAVE "file_name", device_number, start_address, end_address`

Saves the binary data from the given memory area. NOTE: for now syntax differs from the BASIC V3.5+ - this will be changed once the necessary BASIC infrastructure is implemented.
