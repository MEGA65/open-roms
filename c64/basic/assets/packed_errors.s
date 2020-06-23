// #LAYOUT# STD *       #TAKE
// #LAYOUT# M65 BASIC_1 #TAKE
// #LAYOUT# X16 BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE


#if CONFIG_COMPRESSION_LVL_2  

packed_dict_errors:

	put_packed_dict_errors()

#else

packed_freq_errors:

	put_packed_freq_errors()

#endif
