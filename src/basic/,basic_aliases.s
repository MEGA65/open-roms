
;
; Aliases for memory locations for memory block copy routines
;

!addr memmove__src    = INDEX+2
!addr memmove__dst    = RESHO+0
!addr memmove__size   = RESHO+2
!addr memmove__tmp    = RESHO+4



;
; Helper aliases to make the code more readable
; Always use double underscore in label names
; to allow automatic VICE label conflict prevention
;

!addr __tokenise_work1 = $07 ; CHARAC
!addr __tokenise_work2 = $08 ; ENDCHR
!addr __tokenise_work3 = $0B ; COUNT
!addr __tokenise_work4 = $0F ; GARBFL
!addr __tokenise_work5 = $0C ; DIMFLG

;
; Helper aliases for DOS Wedge under MONITOR
;

!addr __wedge_mon      = $0A ; VERCKB
!addr __wedge_spstore  = $09 ; TRMPOS

;
; Aliases for the tokeniser - reuse the CPU stack
;

!addr tk__offset       = $100               ; offset into string
!addr tk__length       = __tokenise_work1   ; length of the raw string

!addr tk__len_unpacked = $101 ; length of unpacked data; it could replace 'tk__nibble_flag', but at the cost of code size/performance
!addr tk__shorten_bits = $102 ; 2 bytes for quick shortening of packed candidate
!addr tk__nibble_flag  = $104 ; $00 = start from new byte, $FF = start from high nibble
!addr tk__byte_offset  = $105 ; offset of the current byte (to place new data) in tk__packed

!addr tk__packed       = $106 ; packed candidate, 25 bytes is enough for worst case - a 16 byte keyword
