	;; Delete the current BASIC line, which is assumed to have already
	;; been found with basic_find_line.
	;; Really only consists of copying memory down.
	;; The only complication is that we have to do the copy with ROMs
	;; banked out. Oh, yes, and we have to update all the links in
	;; the following basic lines.
basic_delete_line:
	sec
	rts
