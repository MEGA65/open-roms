;
; Memory locations for the DOS
;

; NOTES:
; - starting from $8000, 16KB RAM is available (starting from $10000 in C65 address space)
; - additional 16KB RAM is reserved for DOS too ($14000-$17FFF), and can be banked-in if needed


	;
	; Temporary storage locations
	;

	!addr FS_HVSR_DIRENT = $1000


	;
	; Page start+0
	;

	!addr MAGICSTR         = $8000 ; magic string; if not matching, DOS considered non-functional

	; Register storage

	!addr REG_A            = $8005
	!addr REG_X            = $8006
	!addr REG_Y            = $8007
	!addr REG_Z            = $8008

	; Reserved: $8009 - $800C

	; General DOS configuration

	!addr UNIT_SDCARD      = $800D ; unit number for device, 0 = none
	!addr UNIT_FLOPPY      = $800E ; as above
	!addr UNIT_RAMDISK     = $800F ; as above

	; General DOS status

	!addr IDX1_LISTENER    = $8010 ; listener idx, >=$80 = none
	!addr IDX2_LISTENER    = $8011 ; listener idx * 2, >=$80 = none - for calling routines via vector table
	!addr IDX1_TALKER      = $8012 ; talker idx, >=$80 = none
	!addr IDX2_TALKER      = $8013 ; talker idx * 2, >=$80 = none - for calling routines via vector table

	; Helper subroutines to fetch data

	!addr code_LDA_nnnn_Y  = $8014 ; - LDA nnnn, Y instruction
	!addr par_LDA_nnnn_Y   = $8015 ; - 2 bytes; address in buffer, ram disk
	!addr code_RTS_04      = $8017 ; - RTS instruction

	; Parameters for utilities/helpers

	!addr PAR_TRACK        = $8018 ; track number, also for status/error
	!addr PAR_SECTOR       = $8019 ; sector number, also for status/error	

	!addr PAR_FSIZE_BYTES  = $801A ; 4 bytes - file size in bytes
	!addr PAR_FSIZE_BLOCKS = $801E ; 2 bytes - file size in blocks

	!addr PAR_FTYPE        = $8020 ; bits 0-5 - type, bits 6-7 - protected, closed        
	!addr PAR_FNAME        = $8021 ; 16 bytes - filename, filled with $A0
	!addr PAR_FPATTERN     = $8031 ; 16 bytes - pattern to match, filled with $A0

	; Various temporary data

	!addr XX_DIR_PHASE     = $8041 ; directory output phase, values deponds on device driver, but 0 = not reading
	!addr SD_DIR_PHASE     = $8041 ; - SD card
	!addr FD_DIR_PHASE     = $8042 ; - floppy
	!addr RD_DIR_PHASE     = $8043 ; - ram disk

	; Free space: $8044-$8063

	!addr SD_ACPTR_helper  = $8052 ; subroutine in RAM to read a byte
	!addr code_LDA_01      = $8052 ; - LDA instruction
	!addr SD_ACPTR_PTR     = $8053 ; - 2 bytes; address in buffer, SD card
	!addr code_RTS_01      = $8055 ; - RTS instruction
	
	!addr FD_ACPTR_helper  = $8056 ; subroutine in RAM to read a byte
	!addr code_LDA_02      = $8056 ; - LDA instruction
	!addr FD_ACPTR_PTR     = $8057 ; - 2 bytes; address in buffer, floppy
	!addr code_RTS_02      = $8059 ; - RTS instruction
	
	!addr RD_ACPTR_helper  = $805A ; subroutine in RAM to read a byte
	!addr code_LDA_03      = $805A ; - LDA instruction
	!addr RD_ACPTR_PTR     = $805B ; - 2 bytes; address in buffer, ram disk
	!addr code_RTS_03      = $805D ; - RTS instruction

	!addr XX_ACPTR_LEN     = $805E ; 2 bytes - length of data left for ACPTR
	!addr SD_ACPTR_LEN     = $805E ; - SD card
	!addr FD_ACPTR_LEN     = $8060 ; - floppy
	!addr RD_ACPTR_LEN     = $8062 ; - ram disk

	!addr XX_MODE          = $8064 ; current mode (0 = none, 1 = receiving command/file name)
	!addr SD_MODE          = $8064 ; - SD card
	!addr FD_MODE          = $8065 ; - floppy
	!addr RD_MODE          = $8066 ; - ram disk

	!addr XX_CHANNEL       = $8067 ; current channel
	!addr SD_CHANNEL       = $8067 ; - SD card
	!addr FD_CHANNEL       = $8068 ; - floppy
	!addr RD_CHANNEL       = $8069 ; - ram disk

	!addr XX_CMDFN_IDX     = $806A ; index byte for storing file name/command
	!addr SD_CMDFN_IDX     = $806A ; - SD card
	!addr FD_CMDFN_IDX     = $806B ; - floppy
	!addr RD_CMDFN_IDX     = $806C ; - ram disk

	!addr XX_STATUS_IDX    = $806D ; index byte for reading status 
	!addr SD_STATUS_IDX    = $806D ; - SD card
	!addr FD_STATUS_IDX    = $806E ; - floppy
	!addr RD_STATUS_IDX    = $806F ; - ram disk

	!addr DMAJOB_LIST      = $8070 ; 15 bytes, a general purpose DMA list
	!addr DMAJOB_SRC_MB    = DMAJOB_LIST+2
	!addr DMAJOB_DST_MB    = DMAJOB_LIST+4
	!addr DMAJOB_SIZE      = DMAJOB_LIST+7    ; keep $0200 here
	!addr DMAJOB_SRC_ADDR  = DMAJOB_LIST+9
	!addr DMAJOB_DST_ADDR  = DMAJOB_LIST+12

	!addr SD_DESC          = $807F ; current file descriptor



	; XXX Free space


	;
	; Various buffers, caches, and other large memory chunks
	;

	; BAM cache for floppy drives; 2 KB (4 blocks) each, to cover up to ED floppies - XXX implementation to be written

	!addr FD_BAM_CACHE_0   = $8A00 ; - floppy drive 0
	!addr FD_BAM_CACHE_1   = $8E00 ; - floppy drive 1

	; General purpose buffers, 512 bytes each, each starts at page start - XXX dynamic alllocation to be written

	!addr SHARED_BUF_0     = $9200  ; XXX temporarily hardcoded for usage by SD card
	!addr SHARED_BUF_1     = $9400
	!addr SHARED_BUF_2     = $9600
	!addr SHARED_BUF_3     = $9800
	!addr SHARED_BUF_4     = $9A00
	!addr SHARED_BUF_5     = $9C00
	!addr SHARED_BUF_6     = $9E00
	!addr SHARED_BUF_7     = $A000
	!addr SHARED_BUF_8     = $A200
	!addr SHARED_BUF_9     = $A400
	!addr SHARED_BUF_A     = $A600
	!addr SHARED_BUF_B     = $A800
	!addr SHARED_BUF_C     = $AA00
	!addr SHARED_BUF_D     = $AC00
	!addr SHARED_BUF_E     = $AE00
	!addr SHARED_BUF_F     = $B000

	; Memory shadow, needed for SD card support

	!addr SD_MEMSHADOW_BUF = $8200 ; 256 byte buffer for preserving original memory content

	; Command/filename buffers, 128 bytes each - XXX extend to 256 bytes (change implementation)

	!addr SD_CMDFN_BUF     = $B300 ; - SD card
	!addr FD_CMDFN_BUF     = $B400 ; - floppy
	!addr RD_CMDFN_BUF     = $B500 ; - ram disk

	; Directory entry buffers, in BASIC format, $30 bytes each

	!addr XX_DIRENT_BUF    = $B600
	!addr SD_DIRENT_BUF    = $B600 ; - SD card
	!addr FD_DIRENT_BUF    = $B630 ; - floppy
	!addr RD_DIRENT_BUF    = $B660 ; - ram disk

	; Status buffers, content terminated by 0, $30 bytes each

	!addr XX_STATUS_BUF    = $B690
	!addr SD_STATUS_BUF    = $B690 ; - SD card
	!addr FD_STATUS_BUF    = $B6C0 ; - floppy
	!addr RD_STATUS_BUF    = $B6F0 ; - ram disk

	;
	; Reserved 18 KB for floppy track buffers + some area for track metadata
	;

	!addr XX_REMAINING     = $B720
