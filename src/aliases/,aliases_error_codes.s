
; Error codes for 'panic' pseudocommand

!set P_ERR_NONE                  = $00
!set P_ERR_ROM_MISMATCH          = $01 ; this value has to be stable as long as possible


; Kernal error codes - returned in the A register
; Described in 'Commodore 64 Programmer's Reference Guide', page 306

!set K_ERR_ROUTINE_TERMINATED     = $00
!set K_ERR_TOO_MANY_OPEN_FILES    = $01
!set K_ERR_FILE_ALREADY_OPEN      = $02
!set K_ERR_FILE_NOT_OPEN          = $03
!set K_ERR_FILE_NOT_FOUND         = $04
!set K_ERR_DEVICE_NOT_FOUND       = $05
!set K_ERR_FILE_NOT_INPUT         = $06
!set K_ERR_FILE_NOT_OUTPUT        = $07
!set K_ERR_FILE_NAME_MISSING      = $08
!set K_ERR_ILLEGAL_DEVICE_NUMBER  = $09
!set K_ERR_TOP_MEM_RS232          = $F0

; Kernal status codes for READST routine (IOSTATUS)
; Described in 'Commodore 64 Programmer's Reference Guide', page 292

; For IEC devices
!set K_STS_TIMEOUT_WRITE          = $01
!set K_STS_TIMEOUT_READ           = $02
!set K_STS_EOI                    = $40
!set K_STS_DEVICE_NOT_FOUND       = $80
; For tape deck
!set K_STS_SHORT_BLOCK            = $04
!set K_STS_LONG_BLOCK             = $08
!set K_STS_READ_ERROR             = $10
!set K_STS_CHECKSUM_ERROR         = $20
!set K_STS_END_OF_FILE            = $40
!set K_STS_END_OF_TAPE            = $80

; BASIC error codes, taken from http://sta.c64.org/cbm64baserr.html
!set B_ERR_TOO_MANY_FILES         = $01
!set B_ERR_FILE_OPEN              = $02
!set B_ERR_FILE_NOT_OPEN          = $03
!set B_ERR_FILE_NOT_FOUND         = $04
!set B_ERR_DEVICE_NOT_PRESENT     = $05
!set B_ERR_NOT_INPUT_FILE         = $06
!set B_ERR_NOT_OUTPUT_FILE        = $07
!set B_ERR_MISSING_FILENAME       = $08
!set B_ERR_ILLEGAL_DEVICE_NUMBER  = $09
!set B_ERR_NEXT_WITHOUT_FOR       = $0A
!set B_ERR_SYNTAX                 = $0B
!set B_ERR_RETURN_WITHOUT_GOSUB   = $0C
!set B_ERR_OUT_OF_DATA            = $0D
!set B_ERR_ILLEGAL_QUANTITY       = $0E
!set B_ERR_OVERFLOW               = $0F
!set B_ERR_OUT_OF_MEMORY          = $10
!set B_ERR_UNDEFD_STATEMENT       = $11
!set B_ERR_BAD_SUBSCRIPT          = $12
!set B_ERR_REDIMD_ARRAY           = $13
!set B_ERR_DIVISION_BY_ZERO       = $14
!set B_ERR_ILLEGAL_DIRECT         = $15
!set B_ERR_TYPE_MISMATCH          = $16
!set B_ERR_STRING_TOO_LONG        = $17
!set B_ERR_FILE_DATA              = $18
!set B_ERR_FORMULA_TOO_COMPLEX    = $19
!set B_ERR_CANT_CONTINUE          = $1A
!set B_ERR_UNDEFD_FUNCTION        = $1B
!set B_ERR_VERIFY                 = $1C
!set B_ERR_LOAD                   = $1D
!set B_ERR_BREAK                  = $1E
