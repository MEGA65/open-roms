;; #LAYOUT# M65 * #TAKE
;; #LAYOUT# *   * #IGNORE


	; XXX target High RAM memory map concept - TODO: update current code

	; $10000-$17FFF (32KB) - reserved for DOS
	; $18000-$18FFF  (4KB) - chargen copied to RAM, to allow character redefinition

!set MEMCONF_CHRBASE = $8000

	; $19000-$1B7FF (10KB) - reserved for virtual text screen, 80x128

!set MEMCONF_SCRBASE = $9000
!set MEMCONF_SCRROWS = 128

	; $1B800-$1DFFF (10KB) - reserved for a color RAM backup when switchin between text/graphics modes
	; $1E000-$1EFFF  (4KB) - reserved for sprites

	; $1F000-$1F08D        - shadow location for BASIC zeropage
	; $1F08E-$1F7FF        - reserved for future use

!set MEMCONF_SHADOW_BZP_0 = $00
!set MEMCONF_SHADOW_BZP_1 = $F0
!set MEMCONF_SHADOW_BZP_2 = $01
!set MEMCONF_SHADOW_BZP_3 = $00

	; $1F800-$1FFFF  (2KB) - color RAM mirror, not useable
	; $20000-$3FFFF (64KB) - ROM, additions

	; $40000-$47FFF (32KB) - reserved for graphics screen  /  Z80 memory bank 0 ($40000-$4DFFF)
	; $48000-...           - native mode BASIC variables   /  Z80 memory bank 1 ($50000-$5FFFF)
