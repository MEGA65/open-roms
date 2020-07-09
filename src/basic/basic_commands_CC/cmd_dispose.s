// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE


cmd_dispose:

	jsr varstr_garbage_collect

	jmp execute_statements
