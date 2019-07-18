
;;
;; Official Kernal routine, described in:
;;
;; - [RG64] C64 Programmer's Reference Guide   - page 284
;; - [CM64] Compute's Mapping the Commodore 64 - page 214
;; - http://codebase64.org/doku.php?id=base:kernalreference (original source)
;;
;; CPU registers that has to be preserved (see [RG64]): .A
;;


;; As there is nothing between here and $FFFA, we can just hard code this in place.

iobase:
    ldy #$DC
    ldx #$00
    rts

