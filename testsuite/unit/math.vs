# Unit tests for basic math functions

log on
logname "build/output"

print "TEST: float const 10.0"
fill $1001 $1005 84 20 00 00 00
print "COMPARE"
compare $BAF9 $BAFD $1001
print "END"

print "TEST: float const 1.0"
fill $1001 $1005 81 00 00 00 00
print "COMPARE"
compare $B9BC $B9C0 $1001
print "END"

print "TEST: float const 0.5"
fill $1001 $1005 80 00 00 00 00
print "COMPARE"
compare $BF11 $BF15 $1001
print "END"

print "TEST: float const -0.5"
fill $1001 $1005 80 80 00 00 00
print "COMPARE"
compare $B9E0 $B9E4 $1001
print "END"

print "TEST: float const 0.25"
fill $1001 $1005 7F 00 00 00 00
print "COMPARE"
compare $E2EA $E2EE $1001
print "END"

print "TEST: convert_A_to_FAC1 A=0"
r A=0
r PC=$BC3C
ret
fill $1001 $1001 00
print "COMPARE"
compare $61 $61 $1001
print "END"

print "TEST: convert_A_to_FAC1 A=1"
r A=1
r PC=$BC3C
ret
fill $1001 $1007 81 80 00 00 00 00 00
print "COMPARE"
compare $61 $67 $1001
print "END"

print "TEST: convert_A_to_FAC1 A=127"
r A=$7F
r PC=$BC3C
ret
fill $1001 $1007 87 FE 00 00 00 00 00
print "COMPARE"
compare $61 $67 $1001
print "END"

print "TEST: convert_A_to_FAC1 A=-128"
r A=$80
r PC=$BC3C
ret
fill $1001 $1007 88 80 00 00 00 FF 00
print "COMPARE"
compare $61 $67 $1001
print "END"

print "TEST: convert_Y_to_FAC1 Y=1"
r Y=1
r PC=$B3A2
ret
fill $1001 $1007 81 80 00 00 00 00 00
print "COMPARE"
compare $61 $67 $1001
print "END"

print "TEST: convert_Y_to_FAC1 Y=0"
r Y=0
r PC=$B3A2
ret
fill $1001 $1001 00
print "COMPARE"
compare $61 $61 $1001
print "END"

print "TEST: convert_Y_to_FAC1 Y=127"
r Y=$7F
r PC=$B3A2
ret
fill $1001 $1007 87 FE 00 00 00 00 00
print "COMPARE"
compare $61 $67 $1001
print "END"

print "TEST: convert_Y_to_FAC1 Y=255"
r Y=$FF
r PC=$B3A2
ret
fill $1001 $1007 88 FF 00 00 00 00 00
print "COMPARE"
compare $61 $67 $1001
print "END"

q
