
dos_dmalist_template:

	!byte $0A                         ; use F018A list format (it is shorter by 1 byte)
	!byte $80, $00                    ; src. address is $00xxxxx
	!byte $81, $00                    ; dst. address is $00xxxxx
	!byte $00                         ; end of options
	!byte $00                         ; operation: COPY
	!word $0200                       ; data size if 512 bytes

	; 3 bytes of src address + 3 bytes of dst address - not included in template
