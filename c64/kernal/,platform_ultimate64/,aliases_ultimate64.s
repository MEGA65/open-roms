
;; Registers according to Ultimate 64 Command Interface description,
;; https://1541u-documentation.readthedocs.io/en/latest/command%20interface.html
;; and ultimate_dos_v1.0.pdf and command_interface_v1.0.pdf by Gideon Zweijtzer

	;; Command interface registers
	.alias U64_CONTROL                 $DF1C ; write
	.alias U64_STATUS                  $DF1C ; read
	.alias U64_COMMAND_DATA            $DF1D ; write
	.alias U64_IDENTIFICATION          $DF1D ; read
	.alias U64_RESPONSE_DATA           $DF1E ; read only
	.alias U64_STATUS_DATA             $DF1F ; read only

	;; Constant for U64_IDENTIFICATION register
	.alias U64_MAGIC_ID                $C9

	;; Constants for U64_CONTROL register
	.alias U64_CTRL_BIT_PUSH_CMD       $01
	.alias U64_CTRL_BIT_DATA_ACC       $02
	.alias U64_CTRL_BIT_ABORT          $04
	.alias U64_CTRL_BIT_CLR_ERR        $08

	;; Constants for U64_STATUS register
	.alias U64_STAT_BIT_CMD_BUSY       $01
	.alias U64_STAT_BIT_DATA_ACC       $02
	.alias U64_STAT_BIT_ABORT_P        $04
	.alias U64_STAT_BIT_ERROR          $08
	.alias U64_STAT_MASK_STATE         $30 ; two bits!
	.alias U64_STAT_BIT_STAT_AV        $40
	.alias U64_STAT_BIT_DATA_AV        $80

	;; Interface targets
	.alias U64_TARGET_DOS1             $01
	.alias U64_TARGET_DOS2             $02

	;; DOS command codes
	.alias U64_DOS_CMD_IDENTIFY        $01
	.alias U64_DOS_CMD_OPEN_FILE       $02
	.alias U64_DOS_CMD_CLOSE_FILE      $03
	.alias U64_DOS_CMD_READ_DATA       $04
	.alias U64_DOS_CMD_WRITE_DATA      $05
	.alias U64_DOS_CMD_FILE_SEEK       $06
	.alias U64_DOS_CMD_FILE_INFO       $07
	.alias U64_DOS_CMD_CHANGE_DIR      $11
	.alias U64_DOS_CMD_GET_PATH        $12
	.alias U64_DOS_CMD_OPEN_DIR        $13
	.alias U64_DOS_CMD_READ_DIR        $14
	.alias U64_DOS_CMD_COPY_UI_PATH    $15
	.alias U64_DOS_CMD_LOAD_REU        $21
	.alias U64_DOS_CMD_SAVE_REU        $22
	.alias U64_DOS_CMD_ECHO            $F0

	;; DOS file opening constants 
	.alias U64_FA_READ                 $01
	.alias U64_FA_WRITE                $02
	.alias U64_FA_CREATE_NEW           $03
	.alias U64_FA_CREATE_ALWAYS        $04
