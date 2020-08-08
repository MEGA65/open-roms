// #LAYOUT# M65 KERNAL_0 #TAKE
// #LAYOUT# *   *        #IGNORE

//
// ROM routine call redirect for Mega65 API routines
//

M65_MODE64:

	jsr     map_KERNAL_1
	jsr_ind VK1__M65_MODE64
	jmp     map_NORMAL

M65_MODE65:

	jsr     map_KERNAL_1
	jsr_ind VK1__M65_MODE65
	jmp     map_NORMAL

M65_SCRMODEGET:

	jsr     map_KERNAL_1
	jsr_ind VK1__M65_SCRMODEGET
	jmp     map_NORMAL

M65_SCRMODESET:

	jsr     map_KERNAL_1
	jsr_ind VK1__M65_SCRMODESET
	jmp     map_NORMAL
