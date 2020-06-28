
# Extended BASIC

NOTE: Command syntax, behaviour details, and tokens are still subject to change! In the future most (if not all) extended commands will be available only on machines with extended ROM, like the Mega65.

## Additional commands

### `FAST`

Tries to switch the machine to turbo mode - details differ depending on the configured machine / motherboard.

### `SLOW`

Tries to switch the machine back to 1 MHz operation mode.

### `MERGE "file_name" [, device_number]`

Appends the BASIC program from a storage medium to the one currently present in memory.

### `BLOAD "file_name", device_number, start_address`

Loads a binary file starting from the given memory location. Does not clear variables, does not perform BASIC program relinking, etc. NOTE: for now syntax differs from the BASIC V3.5+ - this will be changed once the necessary BASIC infrastructure is implemented.

### `BVERIFY "file_name", device_number, start_address`

Verify operation for the binary data starting from a given addres. NOTE: for now syntax differs from the BASIC V3.5+ - this will be changed once the necessary BASIC infrastructure is implemented.

### `BSAVE "file_name", device_number, start_address, end_address`

Saves the binary data from the given memory area. NOTE: for now syntax differs from the BASIC V3.5+ - this will be changed once the necessary BASIC infrastructure is implemented.
