
;; Registers according to Ultimate 64 Command Interface ddescription,
;; https://1541u-documentation.readthedocs.io/en/latest/command%20interface.html

	.alias U64_CONTROL           $DF1C ; write
	.alias U64_STATUS            $DF1C ; read
	.alias U64_COMMAND_DATA      $DF1D ; write
	.alias U64_IDENTIFICATION    $DF1D ; read
	.alias U64_RESPONSE_DATA     $DF1E ; read only
	.alias U64_STATUS_DATA       $DF1F ; read only
