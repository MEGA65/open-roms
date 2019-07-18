
	;; Kernal error codes - returned in the A register
	;; Described in 'Commodore 64 Programmer's Reference Guide', page 306

	.alias K_ERR_ROUTINE_TERMINATED       $00
	.alias K_ERR_TOO_MANY_OPEN_FILES      $01
	.alias K_ERR_FILE_ALREADY_OPEN        $02
	.alias K_ERR_FILE_NOT_OPEN            $03
	.alias K_ERR_FILE_NOT_FOUND           $04
	.alias K_ERR_DEVICE_NOT_FOUND         $05
	.alias K_ERR_FILE_NOT_INPUT           $06
	.alias K_ERR_FILE_NOT_OUTPUT          $07
	.alias K_ERR_FILE_NAME_MISSING        $08
	.alias K_ERR_ILLEGAL_DEVICE_NUMBER    $09
	.alias K_ERR_TOP_MEM_RS232            $F0

	;; Kernal status codes for READST routine (IOSTATUS)
	;; Described in 'Commodore 64 Programmer's Reference Guide', page 292

	;; For IEC devices
	.alias K_STS_TIMEOUT_WRITE            $01
	.alias K_STS_TIMEOUT_READ             $02
	.alias K_STS_EOI                      $40
	.alias K_STS_DEVICE_NOT_FOUND         $80
	;; For tape deck
	.alias K_STS_SHORT_BLOCK              $04
	.alias K_STS_LONG_BLOCK               $08
	.alias K_STS_READ_ERROR               $10
	.alias K_STS_CHECKSUM_ERROR           $20
	.alias K_STS_END_OF_FILE              $40
	.alias K_STS_END_OF_TAPE              $80

	;; BASIC error codes, taken from http://sta.c64.org/cbm64baserr.html
	.alias B_ERR_TOO_MANY_FILES           $01
	.alias B_ERR_FILE_OPEN                $02
	.alias B_ERR_FILE_NOT_OPEN            $03
	.alias B_ERR_FILE_NOT_FOUND           $04
	.alias B_ERR_DEVICE_NOT_PRESENT       $05
	.alias B_ERR_NOT_INPUT_FILE           $06
	.alias B_ERR_NOT_OUTPUT_FILE          $07
	.alias B_ERR_MISSING_FILENAME         $08
	.alias B_ERR_ILLEGAL_DEVICE_NUMBER    $09
	.alias B_ERR_NEXT_WITHOUT_FOR         $0A
	.alias B_ERR_SYNTAX                   $0B
	.alias B_ERR_RETURN_WITHOUT_GOSUB     $0C
	.alias B_ERR_OUT_OF_DATA              $0D
	.alias B_ERR_ILLEGAL_QUANTITY         $0E
	.alias B_ERR_OVERFLOW                 $0F
	.alias B_ERR_OUT_OF_MEMORY            $10
	.alias B_ERR_UNDEFD_STATEMENT         $11
	.alias B_ERR_BAD_SUBSCRIPT            $12
	.alias B_ERR_REDIMD_ARRAY             $13
	.alias B_ERR_DIVISION_BY_ZERO         $14
	.alias B_ERR_ILLEGAL_DIRECT           $15
	.alias B_ERR_TYPE_MISMATCH            $16
	.alias B_ERR_STRING_TOO_LONG          $17
	.alias B_ERR_FILE_DATA                $18
	.alias B_ERR_FORMULA_TOO_COMPLEX      $19
	.alias B_ERR_CANT_CONTINUE            $1A
	.alias B_ERR_UNDEFD_FUNCTION          $1B
	.alias B_ERR_VERIFY                   $1C
	.alias B_ERR_LOAD                     $1D
	.alias B_ERR_BREAK                    $1E
