
	// Error codes for 'panic' pseudocommand

	.const P_ERR_NONE                  = $00
	.const P_ERR_ROM_MISMATCH          = $01 // this value has to be stable as long as possible


	// Kernal error codes - returned in the A register
	// Described in 'Commodore 64 Programmer's Reference Guide', page 306

	.const K_ERR_ROUTINE_TERMINATED     = $00
	.const K_ERR_TOO_MANY_OPEN_FILES    = $01
	.const K_ERR_FILE_ALREADY_OPEN      = $02
	.const K_ERR_FILE_NOT_OPEN          = $03
	.const K_ERR_FILE_NOT_FOUND         = $04
	.const K_ERR_DEVICE_NOT_FOUND       = $05
	.const K_ERR_FILE_NOT_INPUT         = $06
	.const K_ERR_FILE_NOT_OUTPUT        = $07
	.const K_ERR_FILE_NAME_MISSING      = $08
	.const K_ERR_ILLEGAL_DEVICE_NUMBER  = $09
	.const K_ERR_TOP_MEM_RS232          = $F0

	// Kernal status codes for READST routine (IOSTATUS)
	// Described in 'Commodore 64 Programmer's Reference Guide', page 292

	// For IEC devices
	.const K_STS_TIMEOUT_WRITE          = $01
	.const K_STS_TIMEOUT_READ           = $02
	.const K_STS_EOI                    = $40
	.const K_STS_DEVICE_NOT_FOUND       = $80
	// For tape deck
	.const K_STS_SHORT_BLOCK            = $04
	.const K_STS_LONG_BLOCK             = $08
	.const K_STS_READ_ERROR             = $10
	.const K_STS_CHECKSUM_ERROR         = $20
	.const K_STS_END_OF_FILE            = $40
	.const K_STS_END_OF_TAPE            = $80

	// BASIC error codes, taken from http://sta.c64.org/cbm64baserr.html
	.const B_ERR_TOO_MANY_FILES         = $01
	.const B_ERR_FILE_OPEN              = $02
	.const B_ERR_FILE_NOT_OPEN          = $03
	.const B_ERR_FILE_NOT_FOUND         = $04
	.const B_ERR_DEVICE_NOT_PRESENT     = $05
	.const B_ERR_NOT_INPUT_FILE         = $06
	.const B_ERR_NOT_OUTPUT_FILE        = $07
	.const B_ERR_MISSING_FILENAME       = $08
	.const B_ERR_ILLEGAL_DEVICE_NUMBER  = $09
	.const B_ERR_NEXT_WITHOUT_FOR       = $0A
	.const B_ERR_SYNTAX                 = $0B
	.const B_ERR_RETURN_WITHOUT_GOSUB   = $0C
	.const B_ERR_OUT_OF_DATA            = $0D
	.const B_ERR_ILLEGAL_QUANTITY       = $0E
	.const B_ERR_OVERFLOW               = $0F
	.const B_ERR_OUT_OF_MEMORY          = $10
	.const B_ERR_UNDEFD_STATEMENT       = $11
	.const B_ERR_BAD_SUBSCRIPT          = $12
	.const B_ERR_REDIMD_ARRAY           = $13
	.const B_ERR_DIVISION_BY_ZERO       = $14
	.const B_ERR_ILLEGAL_DIRECT         = $15
	.const B_ERR_TYPE_MISMATCH          = $16
	.const B_ERR_STRING_TOO_LONG        = $17
	.const B_ERR_FILE_DATA              = $18
	.const B_ERR_FORMULA_TOO_COMPLEX    = $19
	.const B_ERR_CANT_CONTINUE          = $1A
	.const B_ERR_UNDEFD_FUNCTION        = $1B
	.const B_ERR_VERIFY                 = $1C
	.const B_ERR_LOAD                   = $1D
	.const B_ERR_BREAK                  = $1E
