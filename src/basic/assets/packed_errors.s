;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# M65 BASIC_1 #TAKE
;; #LAYOUT# X16 BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE


!ifdef CONFIG_COMPRESSION_LVL_2 {

packed_dict_errors:

	+PUT_PACKED_DICT_errors

} else {

packed_freq_errors:

	+PUT_PACKED_FREQ_errors

}
