	;; Insert the tokenised line stored at $0200.
	;; First work out where in the list to put it
	;; (basic_find_line with the line number can be used to work
	;; out the insertion point, as it should abort once it finds a
	;; line number too high).
	;; Then all we have to do is push the rest of the BASIC text up,
	;; and update the pointers in all following basic lines.
basic_insert_line:
	sec
	rts
	
