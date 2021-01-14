
; Based on BSM (Bit Shifter's Monitor) - disabled code


!ifdef DISABLED_DISABLED {

!addr Disk_Track  = $XX        ; logical track  1 -> 255
!addr Disk_Sector = $XX        ; logical sector 0 -> 255
!addr Disk_Status = $XX        ; BCD value of status

!addr Disk_Msg    = $XX        ; 40 bytes, disk status as text message

; **************
Get_Disk_Status:
; **************

         LDA  FA
         JSR  TALK
         LDA  #$6f
         JSR  TKSA
         JSR  ACPTR             ; 1st. digit
         STA  Disk_Msg
         ASL
         ASL
         ASL
         ASL
         STA  Disk_Status       ; BCD
         JSR  ACPTR             ; 2nd. digit
         STA  Disk_Msg+1
         AND  #15
         ORA  Disk_Status
         STA  Disk_Status       ; complete BCD number

         LDY  #1
@loop    INY
         JSR  ACPTR
         STA  Disk_Msg,Y
         CMP  #' '
         BCS  @loop
         LDA  #0
         STA  Disk_Msg,Y
         JSR  UNTLK
         LDA  Disk_Status
         RTS

; ****************
Print_Disk_Status:
; ****************

         JSR  Get_Disk_Status

; *************
Print_Disk_Msg:
; *************

         JSR  Print_CR
         LDY  #0
@loop    LDA  Disk_Msg,Y
         BEQ  @exit
         JSR  CHROUT
         INY
         BRA  @loop
@exit    JMP  Print_CR

; ****
DOS_U: ; XXX connect it somehow to command list
; ****

; @[u],U1 mem track startsec [endsec] : read  disk sector(s)
; @[u],U2 mem track startsec [endsec] : write disk sector(s)

         JSR  Get_Char
         CMP  #'1'            ; U1: read
         LBCC Mon_Error
         CMP  #'3'            ; U2: write
         LBCS Mon_Error
         STA  Mon_Data+1      ; U type
         INC  Buf_Index
         JSR  Get_LAC
         LBCS Mon_Error
         JSR  LAC_To_LPC      ; Long_PC = memory address

         JSR  Get_LAC
         LBCS Mon_Error
         LDA  Long_AC
         STA  Disk_Track

         JSR  Get_LAC
         LBCS Mon_Error
         LDA  Long_AC
         STA  Disk_Sector

         JSR  Get_LAC
         JSR  LAC_To_LCT        ; Long_CT = sector count
         DEW  Long_CT           ; Long_CT = -1 for single

         JSR  Open_Disk_Buffer

@loop    LDA  Mon_Data+1
         LSR
         BEQ  @write
         JSR  Find_next_Sector
         BNE  @error
         JSR  Read_Sector
         BRA  @next

@write   JSR  Write_Sector
         JSR  Find_next_Sector
         BNE  @error

@next    JSR  Inc_LPC_Page
         INC  Disk_Sector
         DEW  Long_CT
         BPL  @loop

@error   JSR  Print_Disk_Msg
         JSR  Close_Disk_Buffer
         JMP  Main

; ***************
Find_next_Sector:
; ***************

         JSR  Build_U_String
         JSR  Send_Disk_Command
         JSR  Get_Disk_Status
         BEQ  @return           ; OK
         CMP  #$66              ; illegal track or sector
         BNE  @error            ; error
         LDA  #0
         STA  Disk_Sector
         INC  Disk_Track        ; try next track
         JSR  Build_U_String
         JSR  Send_Disk_Command
         JSR  Get_Disk_Status
         BEQ  @return
@error   JSR  Print_Disk_Msg
         LDA  Disk_Status
@return  RTS

; *******************
Open_Command_Channel:
; *******************

         LDA  FA
         JSR  LISTEN
         LDA  #$ff
         JSR  SECOND
         LDY  #0
         STY  IOSTATUS
         RTS

; *******
Reset_BP:
; *******

         JSR  Open_Command_Channel
@loop    LDA  BP_ZERO,Y
         BEQ  @end
         JSR  CIOUT
         INY
         BRA  @loop
@end     JMP  UNLSN

; ****************
Send_Disk_Command:
; ****************

         JSR  Open_Command_Channel
@loop    LDA  Mon_Data,Y
         BEQ  @end
         JSR  CIOUT
         INY
         BRA  @loop
@end     JMP  UNLSN

; **********
Read_Sector:
; **********

         LDA  FA
         JSR  TALK
         LDA  #$69              ; SA = 9
         JSR  TKSA
         LDZ  #0
         STZ  IOSTATUS
@loop    JSR  ACPTR
         STA  [Long_PC],Z
         INZ
         BNE  @loop
         JMP  UNTLK

; ***********
Write_Sector:
; ***********

         JSR  Reset_BP          ; reset disk buffer pointer
         LDA  FA
         JSR  LISTEN
         LDA  #$69              ; SA = 9
         JSR  TKSA
         LDZ  #0
         STZ  IOSTATUS
@loop    LDA  [Long_PC],Z
         JSR  CIOUT
         INZ
         BNE  @loop
         JSR  UNLSN
         RTS

; *****
Set_TS:
; *****

; Input  A = track or sector
;        X = string index

@100      CMP  #100
          BCC  @10
          INC  Mon_Data,X
          SBC  #100
          BRA  @100
@10       CMP  #10
          BCC  @1
          INC  Mon_Data+1,X
          SBC  #10
          BRA  @10
@1        ORA  #'0'
          STA  Mon_Data+2,X
          RTS

; @[u],U1 mem track startsec [endsec] : read  disk sector(s)

; U1:CHANNEL DRIVE TRACK SECTOR

; *************
Build_U_String:
; *************

         LDX  #14
@loop    LDA  U1,X
         STA  Mon_Data,X
         DEX
         CPX  #2
         BCS  @loop
         LDA  #'U'
         STA  Mon_Data
         LDA  Disk_Track
         LDX  #7
         JSR  Set_TS
         LDA  Disk_Sector
         LDX  #11
         JMP  Set_TS

; ***************
Open_Disk_Buffer:
; ***************

         LDA  #0
         STA  IOSTATUS
         LDA  FA
         JSR  LISTEN          ; open fa,9,"#"
         LDA  #$f9            ; sa = 9
         JSR  SECOND
         LDA  #'#'            ; open buffer
         JSR  CIOUT
         JSR  UNLSN
         LDA  IOSTATUS
         LBNE Print_Disk_Status
         RTS

; ****************
Close_Disk_Buffer:
; ****************

         LDA  #0
         STA  IOSTATUS
         LDA  FA
         JSR  LISTEN          ; open fa,9,"#"
         LDA  #$e9            ; sa = 9
         JSR  SECOND
         JSR  UNLSN
         LDA  IOSTATUS
         LBNE Print_Disk_Status
         RTS










}