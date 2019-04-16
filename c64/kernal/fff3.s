; $FFF3 - Get page of IO devices
; Returns Y=$DC, X=$00
; (http://codebase64.org/doku.php?id=base:kernalreference)
;
; As there is nothing between here and $FFFA, we can just hard code this in place.
LDY #$DC
LDX #$00
RTS

