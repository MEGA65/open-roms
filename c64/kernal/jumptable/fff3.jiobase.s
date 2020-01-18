// #LAYOUT# STD *        #TAKE
// #LAYOUT# *   KERNAL_0 #TAKE
// #LAYOUT# *   *        #IGNORE

//
// Official Kernal routine, described in:
//
// - [RG64] C64 Programmers Reference Guide   - page 284
// - [CM64] Computes Mapping the Commodore 64 - page 214
// - http://codebase64.org/doku.php?id=base:kernalreference (original source)
//
// CPU registers that has to be preserved (see [RG64]): .A
//


// As there is nothing between here and $FFFA, we can just hard code this in place.

// iobase: - commented out to prevent label naming conflict
    ldy #$DC
    ldx #$00
    rts
