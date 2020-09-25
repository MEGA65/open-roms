;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# M65 BASIC_1 #TAKE
;; #LAYOUT# X16 BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE


!ifdef CONFIG_COMPRESSION_LVL_2 {

packed_dict_misc:

	+PUT_PACKED_DICT_misc

} else {

packed_freq_misc:

	+PUT_PACKED_FREQ_misc
}
