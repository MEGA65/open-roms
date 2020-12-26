;; #LAYOUT# M65 KERNAL_1 #TAKE
;; #LAYOUT# *   *        #IGNORE


; #1 - original C65 palette, data taken from C65 manual

;               RRGGBB
!set RGB_1_0 = $000000 ; black
!set RGB_1_1 = $FFFFFF ; white
!set RGB_1_2 = $FF0000 ; red
!set RGB_1_3 = $00FFFF ; cyan
!set RGB_1_4 = $FF00FF ; purple / magenta
!set RGB_1_5 = $00FF00 ; green
!set RGB_1_6 = $0000FF ; blue
!set RGB_1_7 = $FFFF00 ; yellow
!set RGB_1_8 = $FF6600 ; orange
!set RGB_1_9 = $AA4400 ; brown
!set RGB_1_A = $FF7777 ; light red / pink
!set RGB_1_B = $555555 ; dark grey
!set RGB_1_C = $888888 ; medium grey
!set RGB_1_D = $99FF99 ; light green
!set RGB_1_E = $9999FF ; light blue
!set RGB_1_F = $BBBBBB ; light gray

; #2 - a Frodo palette, values taken from VICE emulator

;               RRGGBB
!set RGB_2_0 = $000000 ; black
!set RGB_2_1 = $FFFFFF ; white
!set RGB_2_2 = $CC0000 ; red
!set RGB_2_3 = $00FFCC ; cyan
!set RGB_2_4 = $FF00FF ; purple / magenta
!set RGB_2_5 = $00CC00 ; green
!set RGB_2_6 = $0000CC ; blue
!set RGB_2_7 = $FFFF00 ; yellow
!set RGB_2_8 = $FF8800 ; orange
!set RGB_2_9 = $884400 ; brown
!set RGB_2_A = $FF8888 ; light red / pink
!set RGB_2_B = $444444 ; dark grey
!set RGB_2_C = $888888 ; medium grey
!set RGB_2_D = $88FF88 ; light green
!set RGB_2_E = $8888FF ; light blue
!set RGB_2_F = $CCCCCC ; light gray

; #3 - a VICE emulator palette

;               RRGGBB
!set RGB_3_0 = $000000 ; black
!set RGB_3_1 = $FDFEFC ; white
!set RGB_3_2 = $BE1A24 ; red
!set RGB_3_3 = $30E6C6 ; cyan
!set RGB_3_4 = $B41AE2 ; purple / magenta
!set RGB_3_5 = $1FD21E ; green
!set RGB_3_6 = $211BAE ; blue
!set RGB_3_7 = $DFF60A ; yellow
!set RGB_3_8 = $B84104 ; orange
!set RGB_3_9 = $6A3304 ; brown
!set RGB_3_A = $FE4A57 ; light red / pink
!set RGB_3_B = $424540 ; dark grey
!set RGB_3_C = $70746F ; medium grey
!set RGB_3_D = $59FE59 ; light green
!set RGB_3_E = $5F53FE ; light blue
!set RGB_3_F = $A4A7A2 ; light gray

; #4 - a Colodore palette, values taken from VICE emulator, based on http://www.colodore.com/

;               RRGGBB
!set RGB_4_0 = $000000 ; black
!set RGB_4_1 = $FFFFFF ; white
!set RGB_4_2 = $96282E ; red
!set RGB_4_3 = $5BD6CE ; cyan
!set RGB_4_4 = $9F2DAD ; purple / magenta
!set RGB_4_5 = $41B936 ; green
!set RGB_4_6 = $2724C4 ; blue
!set RGB_4_7 = $EFF347 ; yellow
!set RGB_4_8 = $9F4815 ; orange
!set RGB_4_9 = $5E3500 ; brown
!set RGB_4_A = $DA5F66 ; light red / pink
!set RGB_4_B = $474747 ; dark grey
!set RGB_4_C = $787878 ; medium grey
!set RGB_4_D = $91FF84 ; light green
!set RGB_4_E = $6864FF ; light blue
!set RGB_4_F = $AEAEAE ; light gray

; #5 - a community palette, values taken from VICE emulator, based on https://p1x3l.net/36/c64-community-colors-theor/

;               RRGGBB
!set RGB_5_0 = $000000 ; black
!set RGB_5_1 = $FFFFFF ; white
!set RGB_5_2 = $AF2A29 ; red
!set RGB_5_3 = $62D8CC ; cyan
!set RGB_5_4 = $B03FB6 ; purple / magenta
!set RGB_5_5 = $4AC64A ; green
!set RGB_5_6 = $3739C4 ; blue
!set RGB_5_7 = $E4ED4E ; yellow
!set RGB_5_8 = $B6591C ; orange
!set RGB_5_9 = $683808 ; brown
!set RGB_5_A = $EA746C ; light red / pink
!set RGB_5_B = $4D4D4D ; dark grey
!set RGB_5_C = $848484 ; medium grey
!set RGB_5_D = $A6FA9E ; light green
!set RGB_5_E = $707CE6 ; light blue
!set RGB_5_F = $B6B6B5 ; light gray

; #6 - a Deekay palette, values taken from VICE emulator

;               RRGGBB
!set RGB_6_0 = $000000 ; black
!set RGB_6_1 = $FFFFFF ; white
!set RGB_6_2 = $882000 ; red
!set RGB_6_3 = $68D0A8 ; cyan
!set RGB_6_4 = $A838A0 ; purple / magenta
!set RGB_6_5 = $50B818 ; green
!set RGB_6_6 = $181090 ; blue
!set RGB_6_7 = $F0E858 ; yellow
!set RGB_6_8 = $A04800 ; orange
!set RGB_6_9 = $472B1B ; brown
!set RGB_6_A = $C87870 ; light red / pink
!set RGB_6_B = $484848 ; dark grey
!set RGB_6_C = $808080 ; medium grey
!set RGB_6_D = $98FF98 ; light green
!set RGB_6_E = $5090D0 ; light blue
!set RGB_6_F = $B8B8B8 ; light gray

; Macros to convert colors to C65/M65 palette / greyscale palette (CCIR 601 conversion)

!macro RGB_R .x { !byte ((((^.x & $0F) * $10) + ((^.x & $F0) / $10)) & %11101111) }
!macro RGB_G .x { !byte  (((>.x & $0F) * $10) + ((>.x & $F0) / $10)) }
!macro RGB_B .x { !byte  (((<.x & $0F) * $10) + ((<.x & $F0) / $10)) }

!macro GSCAL .x {
	!set tmp = int(0.2989 * (^.x) + 0.5870 * (>.x) + 0.1140 * (<.x))
	!if (tmp > $FF) { !set tmp = $FF }
	!byte (((tmp & $0F) * $10) + ((tmp & $F0) / $10)) & %11101111
}

; Set 1

m65_colorset_1:

	+RGB_R RGB_1_0
	+RGB_R RGB_1_1
	+RGB_R RGB_1_2
	+RGB_R RGB_1_3
	+RGB_R RGB_1_4
	+RGB_R RGB_1_5
	+RGB_R RGB_1_6
	+RGB_R RGB_1_7
	+RGB_R RGB_1_8
	+RGB_R RGB_1_9
	+RGB_R RGB_1_A
	+RGB_R RGB_1_B
	+RGB_R RGB_1_C
	+RGB_R RGB_1_D
	+RGB_R RGB_1_E
	+RGB_R RGB_1_F

	+RGB_G RGB_1_0
	+RGB_G RGB_1_1
	+RGB_G RGB_1_2
	+RGB_G RGB_1_3
	+RGB_G RGB_1_4
	+RGB_G RGB_1_5
	+RGB_G RGB_1_6
	+RGB_G RGB_1_7
	+RGB_G RGB_1_8
	+RGB_G RGB_1_9
	+RGB_G RGB_1_A
	+RGB_G RGB_1_B
	+RGB_G RGB_1_C
	+RGB_G RGB_1_D
	+RGB_G RGB_1_E
	+RGB_G RGB_1_F

	+RGB_B RGB_1_0
	+RGB_B RGB_1_1
	+RGB_B RGB_1_2
	+RGB_B RGB_1_3
	+RGB_B RGB_1_4
	+RGB_B RGB_1_5
	+RGB_B RGB_1_6
	+RGB_B RGB_1_7
	+RGB_B RGB_1_8
	+RGB_B RGB_1_9
	+RGB_B RGB_1_A
	+RGB_B RGB_1_B
	+RGB_B RGB_1_C
	+RGB_B RGB_1_D
	+RGB_B RGB_1_E
	+RGB_B RGB_1_F

	+GSCAL RGB_1_0
	+GSCAL RGB_1_1
	+GSCAL RGB_1_2
	+GSCAL RGB_1_3
	+GSCAL RGB_1_4
	+GSCAL RGB_1_5
	+GSCAL RGB_1_6
	+GSCAL RGB_1_7
	+GSCAL RGB_1_8
	+GSCAL RGB_1_9
	+GSCAL RGB_1_A
	+GSCAL RGB_1_B
	+GSCAL RGB_1_C
	+GSCAL RGB_1_D
	+GSCAL RGB_1_E
	+GSCAL RGB_1_F

; Set 2

m65_colorset_2:

	+RGB_R RGB_2_0
	+RGB_R RGB_2_1
	+RGB_R RGB_2_2
	+RGB_R RGB_2_3
	+RGB_R RGB_2_4
	+RGB_R RGB_2_5
	+RGB_R RGB_2_6
	+RGB_R RGB_2_7
	+RGB_R RGB_2_8
	+RGB_R RGB_2_9
	+RGB_R RGB_2_A
	+RGB_R RGB_2_B
	+RGB_R RGB_2_C
	+RGB_R RGB_2_D
	+RGB_R RGB_2_E
	+RGB_R RGB_2_F

	+RGB_G RGB_2_0
	+RGB_G RGB_2_1
	+RGB_G RGB_2_2
	+RGB_G RGB_2_3
	+RGB_G RGB_2_4
	+RGB_G RGB_2_5
	+RGB_G RGB_2_6
	+RGB_G RGB_2_7
	+RGB_G RGB_2_8
	+RGB_G RGB_2_9
	+RGB_G RGB_2_A
	+RGB_G RGB_2_B
	+RGB_G RGB_2_C
	+RGB_G RGB_2_D
	+RGB_G RGB_2_E
	+RGB_G RGB_2_F

	+RGB_B RGB_2_0
	+RGB_B RGB_2_1
	+RGB_B RGB_2_2
	+RGB_B RGB_2_3
	+RGB_B RGB_2_4
	+RGB_B RGB_2_5
	+RGB_B RGB_2_6
	+RGB_B RGB_2_7
	+RGB_B RGB_2_8
	+RGB_B RGB_2_9
	+RGB_B RGB_2_A
	+RGB_B RGB_2_B
	+RGB_B RGB_2_C
	+RGB_B RGB_2_D
	+RGB_B RGB_2_E
	+RGB_B RGB_2_F

	+GSCAL RGB_2_0
	+GSCAL RGB_2_1
	+GSCAL RGB_2_2
	+GSCAL RGB_2_3
	+GSCAL RGB_2_4
	+GSCAL RGB_2_5
	+GSCAL RGB_2_6
	+GSCAL RGB_2_7
	+GSCAL RGB_2_8
	+GSCAL RGB_2_9
	+GSCAL RGB_2_A
	+GSCAL RGB_2_B
	+GSCAL RGB_2_C
	+GSCAL RGB_2_D
	+GSCAL RGB_2_E
	+GSCAL RGB_2_F

; Set 3

m65_colorset_3:

	+RGB_R RGB_3_0
	+RGB_R RGB_3_1
	+RGB_R RGB_3_2
	+RGB_R RGB_3_3
	+RGB_R RGB_3_4
	+RGB_R RGB_3_5
	+RGB_R RGB_3_6
	+RGB_R RGB_3_7
	+RGB_R RGB_3_8
	+RGB_R RGB_3_9
	+RGB_R RGB_3_A
	+RGB_R RGB_3_B
	+RGB_R RGB_3_C
	+RGB_R RGB_3_D
	+RGB_R RGB_3_E
	+RGB_R RGB_3_F

	+RGB_G RGB_3_0
	+RGB_G RGB_3_1
	+RGB_G RGB_3_2
	+RGB_G RGB_3_3
	+RGB_G RGB_3_4
	+RGB_G RGB_3_5
	+RGB_G RGB_3_6
	+RGB_G RGB_3_7
	+RGB_G RGB_3_8
	+RGB_G RGB_3_9
	+RGB_G RGB_3_A
	+RGB_G RGB_3_B
	+RGB_G RGB_3_C
	+RGB_G RGB_3_D
	+RGB_G RGB_3_E
	+RGB_G RGB_3_F

	+RGB_B RGB_3_0
	+RGB_B RGB_3_1
	+RGB_B RGB_3_2
	+RGB_B RGB_3_3
	+RGB_B RGB_3_4
	+RGB_B RGB_3_5
	+RGB_B RGB_3_6
	+RGB_B RGB_3_7
	+RGB_B RGB_3_8
	+RGB_B RGB_3_9
	+RGB_B RGB_3_A
	+RGB_B RGB_3_B
	+RGB_B RGB_3_C
	+RGB_B RGB_3_D
	+RGB_B RGB_3_E
	+RGB_B RGB_3_F

	+GSCAL RGB_3_0
	+GSCAL RGB_3_1
	+GSCAL RGB_3_2
	+GSCAL RGB_3_3
	+GSCAL RGB_3_4
	+GSCAL RGB_3_5
	+GSCAL RGB_3_6
	+GSCAL RGB_3_7
	+GSCAL RGB_3_8
	+GSCAL RGB_3_9
	+GSCAL RGB_3_A
	+GSCAL RGB_3_B
	+GSCAL RGB_3_C
	+GSCAL RGB_3_D
	+GSCAL RGB_3_E
	+GSCAL RGB_3_F

; Set 4

m65_colorset_4:

	+RGB_R RGB_4_0
	+RGB_R RGB_4_1
	+RGB_R RGB_4_2
	+RGB_R RGB_4_3
	+RGB_R RGB_4_4
	+RGB_R RGB_4_5
	+RGB_R RGB_4_6
	+RGB_R RGB_4_7
	+RGB_R RGB_4_8
	+RGB_R RGB_4_9
	+RGB_R RGB_4_A
	+RGB_R RGB_4_B
	+RGB_R RGB_4_C
	+RGB_R RGB_4_D
	+RGB_R RGB_4_E
	+RGB_R RGB_4_F

	+RGB_G RGB_4_0
	+RGB_G RGB_4_1
	+RGB_G RGB_4_2
	+RGB_G RGB_4_3
	+RGB_G RGB_4_4
	+RGB_G RGB_4_5
	+RGB_G RGB_4_6
	+RGB_G RGB_4_7
	+RGB_G RGB_4_8
	+RGB_G RGB_4_9
	+RGB_G RGB_4_A
	+RGB_G RGB_4_B
	+RGB_G RGB_4_C
	+RGB_G RGB_4_D
	+RGB_G RGB_4_E
	+RGB_G RGB_4_F

	+RGB_B RGB_4_0
	+RGB_B RGB_4_1
	+RGB_B RGB_4_2
	+RGB_B RGB_4_3
	+RGB_B RGB_4_4
	+RGB_B RGB_4_5
	+RGB_B RGB_4_6
	+RGB_B RGB_4_7
	+RGB_B RGB_4_8
	+RGB_B RGB_4_9
	+RGB_B RGB_4_A
	+RGB_B RGB_4_B
	+RGB_B RGB_4_C
	+RGB_B RGB_4_D
	+RGB_B RGB_4_E
	+RGB_B RGB_4_F

	+GSCAL RGB_4_0
	+GSCAL RGB_4_1
	+GSCAL RGB_4_2
	+GSCAL RGB_4_3
	+GSCAL RGB_4_4
	+GSCAL RGB_4_5
	+GSCAL RGB_4_6
	+GSCAL RGB_4_7
	+GSCAL RGB_4_8
	+GSCAL RGB_4_9
	+GSCAL RGB_4_A
	+GSCAL RGB_4_B
	+GSCAL RGB_4_C
	+GSCAL RGB_4_D
	+GSCAL RGB_4_E
	+GSCAL RGB_4_F

; Set 5

m65_colorset_5:

	+RGB_R RGB_5_0
	+RGB_R RGB_5_1
	+RGB_R RGB_5_2
	+RGB_R RGB_5_3
	+RGB_R RGB_5_4
	+RGB_R RGB_5_5
	+RGB_R RGB_5_6
	+RGB_R RGB_5_7
	+RGB_R RGB_5_8
	+RGB_R RGB_5_9
	+RGB_R RGB_5_A
	+RGB_R RGB_5_B
	+RGB_R RGB_5_C
	+RGB_R RGB_5_D
	+RGB_R RGB_5_E
	+RGB_R RGB_5_F

	+RGB_G RGB_5_0
	+RGB_G RGB_5_1
	+RGB_G RGB_5_2
	+RGB_G RGB_5_3
	+RGB_G RGB_5_4
	+RGB_G RGB_5_5
	+RGB_G RGB_5_6
	+RGB_G RGB_5_7
	+RGB_G RGB_5_8
	+RGB_G RGB_5_9
	+RGB_G RGB_5_A
	+RGB_G RGB_5_B
	+RGB_G RGB_5_C
	+RGB_G RGB_5_D
	+RGB_G RGB_5_E
	+RGB_G RGB_5_F

	+RGB_B RGB_5_0
	+RGB_B RGB_5_1
	+RGB_B RGB_5_2
	+RGB_B RGB_5_3
	+RGB_B RGB_5_4
	+RGB_B RGB_5_5
	+RGB_B RGB_5_6
	+RGB_B RGB_5_7
	+RGB_B RGB_5_8
	+RGB_B RGB_5_9
	+RGB_B RGB_5_A
	+RGB_B RGB_5_B
	+RGB_B RGB_5_C
	+RGB_B RGB_5_D
	+RGB_B RGB_5_E
	+RGB_B RGB_5_F

	+GSCAL RGB_5_0
	+GSCAL RGB_5_1
	+GSCAL RGB_5_2
	+GSCAL RGB_5_3
	+GSCAL RGB_5_4
	+GSCAL RGB_5_5
	+GSCAL RGB_5_6
	+GSCAL RGB_5_7
	+GSCAL RGB_5_8
	+GSCAL RGB_5_9
	+GSCAL RGB_5_A
	+GSCAL RGB_5_B
	+GSCAL RGB_5_C
	+GSCAL RGB_5_D
	+GSCAL RGB_5_E
	+GSCAL RGB_5_F

; Set 6

m65_colorset_6:

	+RGB_R RGB_6_0
	+RGB_R RGB_6_1
	+RGB_R RGB_6_2
	+RGB_R RGB_6_3
	+RGB_R RGB_6_4
	+RGB_R RGB_6_5
	+RGB_R RGB_6_6
	+RGB_R RGB_6_7
	+RGB_R RGB_6_8
	+RGB_R RGB_6_9
	+RGB_R RGB_6_A
	+RGB_R RGB_6_B
	+RGB_R RGB_6_C
	+RGB_R RGB_6_D
	+RGB_R RGB_6_E
	+RGB_R RGB_6_F

	+RGB_G RGB_6_0
	+RGB_G RGB_6_1
	+RGB_G RGB_6_2
	+RGB_G RGB_6_3
	+RGB_G RGB_6_4
	+RGB_G RGB_6_5
	+RGB_G RGB_6_6
	+RGB_G RGB_6_7
	+RGB_G RGB_6_8
	+RGB_G RGB_6_9
	+RGB_G RGB_6_A
	+RGB_G RGB_6_B
	+RGB_G RGB_6_C
	+RGB_G RGB_6_D
	+RGB_G RGB_6_E
	+RGB_G RGB_6_F

	+RGB_B RGB_6_0
	+RGB_B RGB_6_1
	+RGB_B RGB_6_2
	+RGB_B RGB_6_3
	+RGB_B RGB_6_4
	+RGB_B RGB_6_5
	+RGB_B RGB_6_6
	+RGB_B RGB_6_7
	+RGB_B RGB_6_8
	+RGB_B RGB_6_9
	+RGB_B RGB_6_A
	+RGB_B RGB_6_B
	+RGB_B RGB_6_C
	+RGB_B RGB_6_D
	+RGB_B RGB_6_E
	+RGB_B RGB_6_F

	+GSCAL RGB_6_0
	+GSCAL RGB_6_1
	+GSCAL RGB_6_2
	+GSCAL RGB_6_3
	+GSCAL RGB_6_4
	+GSCAL RGB_6_5
	+GSCAL RGB_6_6
	+GSCAL RGB_6_7
	+GSCAL RGB_6_8
	+GSCAL RGB_6_9
	+GSCAL RGB_6_A
	+GSCAL RGB_6_B
	+GSCAL RGB_6_C
	+GSCAL RGB_6_D
	+GSCAL RGB_6_E
	+GSCAL RGB_6_F
