;; #LAYOUT# M65 KERNAL_1 #TAKE
;; #LAYOUT# *   *        #IGNORE



!if (CONFIG_VIC_PALETTE = 0) { !set CONFIG_VIC_PALETTE = 4 }               ; override palette to default value

!if (CONFIG_VIC_PALETTE = 1) {

	; Original C65 palette, taken from C65 manual

	;             RRGGBB
	!set RGB_0 = $000000 ; black
	!set RGB_1 = $FFFFFF ; white
	!set RGB_2 = $FF0000 ; red
	!set RGB_3 = $00FFFF ; cyan
	!set RGB_4 = $FF00FF ; purple / magenta
	!set RGB_5 = $00FF00 ; green
	!set RGB_6 = $0000FF ; blue
	!set RGB_7 = $FFFF00 ; yellow
	!set RGB_8 = $FF6600 ; orange
	!set RGB_9 = $AA4400 ; brown
	!set RGB_A = $FF7777 ; light red / pink
	!set RGB_B = $555555 ; dark grey
	!set RGB_C = $888888 ; medium grey
	!set RGB_D = $99FF99 ; light green
	!set RGB_E = $9999FF ; light blue
	!set RGB_F = $BBBBBB ; light gray

} else if (CONFIG_VIC_PALETTE = 2) {

	; A Colodore palette, values taken from VICE emulator
	; Based on http://www.colodore.com/

	;             RRGGBB
	!set RGB_0 = $000000 ; black
	!set RGB_1 = $FFFFFF ; white
	!set RGB_2 = $96282E ; red
	!set RGB_3 = $5BD6CE ; cyan
	!set RGB_4 = $9F2DAD ; purple / magenta
	!set RGB_5 = $41B936 ; green
	!set RGB_6 = $2724C4 ; blue
	!set RGB_7 = $EFF347 ; yellow
	!set RGB_8 = $9F4815 ; orange
	!set RGB_9 = $5E3500 ; brown
	!set RGB_A = $DA5F66 ; light red / pink
	!set RGB_B = $474747 ; dark grey
	!set RGB_C = $787878 ; medium grey
	!set RGB_D = $91FF84 ; light green
	!set RGB_E = $6864FF ; light blue
	!set RGB_F = $AEAEAE ; light gray

} else if (CONFIG_VIC_PALETTE = 3) {

	; A VICE emulator palette

	;             RRGGBB
	!set RGB_0 = $000000 ; black
	!set RGB_1 = $FDFEFC ; white
	!set RGB_2 = $BE1A24 ; red
	!set RGB_3 = $30E6C6 ; cyan
	!set RGB_4 = $B41AE2 ; purple / magenta
	!set RGB_5 = $1FD21E ; green
	!set RGB_6 = $211BAE ; blue
	!set RGB_7 = $DFF60A ; yellow
	!set RGB_8 = $B84104 ; orange
	!set RGB_9 = $6A3304 ; brown
	!set RGB_A = $FE4A57 ; light red / pink
	!set RGB_B = $424540 ; dark grey
	!set RGB_C = $70746F ; medium grey
	!set RGB_D = $59FE59 ; light green
	!set RGB_E = $5F53FE ; light blue
	!set RGB_F = $A4A7A2 ; light gray

} else if (CONFIG_VIC_PALETTE = 4) {

	; A Frodo palette, values taken from VICE emulator

	;             RRGGBB
	!set RGB_0 = $000000 ; black
	!set RGB_1 = $FDFEFC ; white
	!set RGB_2 = $BE1A24 ; red
	!set RGB_3 = $30E6C6 ; cyan
	!set RGB_4 = $B41AE2 ; purple / magenta
	!set RGB_5 = $1FD21E ; green
	!set RGB_6 = $211BAE ; blue
	!set RGB_7 = $DFF60A ; yellow
	!set RGB_8 = $B84104 ; orange
	!set RGB_9 = $6A3304 ; brown
	!set RGB_A = $FE4A57 ; light red / pink
	!set RGB_B = $424540 ; dark grey
	!set RGB_C = $70746F ; medium grey
	!set RGB_D = $59FE59 ; light green
	!set RGB_E = $5F53FE ; light blue
	!set RGB_F = $A4A7A2 ; light gray


} else if (CONFIG_VIC_PALETTE = 5) {

	; A Deekay palette, values taken from VICE emulator


	;             RRGGBB
	!set RGB_0 = $000000 ; black
	!set RGB_1 = $FFFFFF ; white
	!set RGB_2 = $882000 ; red
	!set RGB_3 = $68D0A8 ; cyan
	!set RGB_4 = $A838A0 ; purple / magenta
	!set RGB_5 = $50B818 ; green
	!set RGB_6 = $181090 ; blue
	!set RGB_7 = $F0E858 ; yellow
	!set RGB_8 = $A04800 ; orange
	!set RGB_9 = $472B1B ; brown
	!set RGB_A = $C87870 ; light red / pink
	!set RGB_B = $484848 ; dark grey
	!set RGB_C = $808080 ; medium grey
	!set RGB_D = $98FF98 ; light green
	!set RGB_E = $5090D0 ; light blue
	!set RGB_F = $B8B8B8 ; light gray

} else { !error "Unknown palette ID" }



m65_reset_palette:

	; Enable RAM palette

	lda VIC_CTRLA
	ora #$04
	sta VIC_CTRLA


	; XXX loop instead

	lda #%11000000
	sta VIC_PALSEL
	jsr m65_reset_palette_selected

	lda #%10000000
	sta VIC_PALSEL
	jsr m65_reset_palette_selected

	lda #%01000000
	sta VIC_PALSEL
	jsr m65_reset_palette_selected

	lda #%00000000
	sta VIC_PALSEL
	jsr m65_reset_palette_selected

	rts

m65_reset_palette_selected:

	; First clear the entire palette

	lda #$00
	ldx #$00
@1:
	sta PALETTE_R, x
	sta PALETTE_G, x
	sta PALETTE_B, x

	inx
	bne @1

	; Now set default colors

	ldx #$0F
@2:
	lda m65_COL_R,x
	sta $D100, x
	lda m65_COL_G,x
	sta $D200, x
	lda m65_COL_B,x
	sta $D300, x
	dex
	bpl @2

	rts

; Macros to convert colors to C65/M65 palette

!macro COL_R .x { !byte ((((^.x & $0F) * $10) + ((^.x & $F0) / $10)) & %11101111) }
!macro COL_G .x { !byte  (((>.x & $0F) * $10) + ((>.x & $F0) / $10)) }
!macro COL_B .x { !byte  (((<.x & $0F) * $10) + ((<.x & $F0) / $10)) }

m65_COL_R:

	+COL_R RGB_0
	+COL_R RGB_1
	+COL_R RGB_2
	+COL_R RGB_3
	+COL_R RGB_4
	+COL_R RGB_5
	+COL_R RGB_6
	+COL_R RGB_7
	+COL_R RGB_8
	+COL_R RGB_9
	+COL_R RGB_A
	+COL_R RGB_B
	+COL_R RGB_C
	+COL_R RGB_D
	+COL_R RGB_E
	+COL_R RGB_F

m65_COL_G:

	+COL_G RGB_0
	+COL_G RGB_1
	+COL_G RGB_2
	+COL_G RGB_3
	+COL_G RGB_4
	+COL_G RGB_5
	+COL_G RGB_6
	+COL_G RGB_7
	+COL_G RGB_8
	+COL_G RGB_9
	+COL_G RGB_A
	+COL_G RGB_B
	+COL_G RGB_C
	+COL_G RGB_D
	+COL_G RGB_E
	+COL_G RGB_F

m65_COL_B:

	+COL_B RGB_0
	+COL_B RGB_1
	+COL_B RGB_2
	+COL_B RGB_3
	+COL_B RGB_4
	+COL_B RGB_5
	+COL_B RGB_6
	+COL_B RGB_7
	+COL_B RGB_8
	+COL_B RGB_9
	+COL_B RGB_A
	+COL_B RGB_B
	+COL_B RGB_C
	+COL_B RGB_D
	+COL_B RGB_E
	+COL_B RGB_F
