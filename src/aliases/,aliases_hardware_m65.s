
;
; Names of hardware registers
;
; See https://github.com/MEGA65/mega65-core/blob/master/iomap.txt
;


!ifdef CONFIG_MB_M65 {

	; VIC-IV registers

	!addr VIC_KEY         = $D02F
	!addr VIC_CTRLA       = $D030
	!addr VIC_CTRLB       = $D031

	!addr VIC_XPOS        = $D050

	!addr VIC_CTRLC       = $D054

	!addr VIC_CHARSTEP    = $D058 ; 2 bytes  - logical characters per line

	!addr VIC_SRH         = $D05D ;          - various flags, bit 7 = hot registers

	!addr VIC_SCRNPTR     = $D060 ; 4 bytes  - pointer to start of screen memory
	!addr VIC_COLPTR      = $D064 ; 2 bytes  - pointer to start of color memory

	!addr VIC_CHARPTR     = $D068 ; 3 bytes  - pointer to start of character generator

	; Keyboard

	!addr C65_EXTKEYS_PR  = $D607
	!addr C65_EXTKEYS_DDR = $D608

	!addr KBSCN_KEYCODE   = $D610	
	!addr KBSCN_BUCKY     = $D611	
	!addr KBSCN_PEEK      = $D613
	!addr KBSCN_SELECT    = $D614

	; SD card

	!addr SD_CTL          = $D680
	!addr SD_ADDR         = $D681 ; 4 bytes
	!addr SD_ERRCODE      = $D6DA

	; SD card sector buffer, $FFFD6E00

	!set  SD_SECBUF_0     = $00
	!set  SD_SECBUF_1     = $6E
	!set  SD_SECBUF_2     = $FD
	!set  SD_SECBUF_3     = $0F

	; DMAgic

	!addr DMA_ADDRLSBTRIG = $D700
	!addr DMA_ADDRMSB     = $D701
	!addr DMA_ADDRBANK    = $D702
	!addr DMA_EN018B      = $D703
	!addr DMA_ADDRMB      = $D704
	!addr DMA_ETRIG       = $D705
	!addr DMA_ADDRLSB     = $D70E

	; MISC registers

	!addr MISC_BOARDID    = $D629 ; board identification byte
	!addr MISC_EMU        = $D710 ; to enable badlines and slow interrupts

	; SID offsets

	!set __SID_R1_OFFSET = $00 ; right SID 1, $D400
	!set __SID_R2_OFFSET = $20 ; right SID 2, $D420
	!set __SID_L1_OFFSET = $40 ; left  SID 1, $D440
	!set __SID_L2_OFFSET = $60 ; left  SID 2, $D460



	; SD card commands
	;
	; XXX command codes taken from XEMU emulator, to be updated when official documentation exists

	!set CARD_CMD_RESET        = $00 ; reset SD card
	!set CARD_CMD_RESET_FL     = $10 ; reset with flags, XXX what's this?
	!set CARD_CMD_END_RESET    = $01 ; end reset
	!set CARD_CMD_END_RESET_FL = $11 ; end reset with flags
	!set CARD_CMD_READ         = $02 ; read sector
	!set CARD_CMD_WRITE        = $03 ; write sector
	!set CARD_CMD_WRITE_1      = $04 ; multi-sector write, 1st sector
	!set CARD_CMD_WRITE_2      = $05 ; multi-sector write
	!set CARD_CMD_WRITE_3      = $06 ; multi-sector write, last sector
	!set CARD_CMD_FLUSH        = $0C
	!set CARD_CMD_SDHC_OFF     = $40 ; for older cores only?
	!set CARD_CMD_SDHC_ON      = $41 ; for older cores only?
	                                 ; XXX $44, $45 - completely unclear to me
	!set CARD_CMD_MAP_BUF      = $81
	!set CARD_CMD_UNMAP_BUF    = $82
	!set CARD_CMD_FILL_ON      = $83
	!set CARD_CMD_FILL_OFF     = $84
	!set CARD_CMD_SELECT_INT   = $C0 ; select internal slot
	!set CARD_CMD_SELECT_EXT   = $C1 ; select external slot
}
