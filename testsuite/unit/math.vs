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

print "TEST: mov FAC2 FAC1 0.9970194103661925"
fill $61 $66 FF FF FF FF FF AA
fill $70 $70 CD
fill $69 $6E 80 7F 3C AA 01 00
r A=$BC
r Y=$B9
r PC=$BBFC
ret
fill $1001 $1006 81 80 00 00 00 00
print "COMPARE"
compare $61 $66 $69
compare $70 $70 $6E  ; FACOV = 0
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

print "TEST: mov MEM FAC1 const 1.0"
fill $61 $67 FF FF FF FF FF AA
fill $70 $70 CD
r A=$BC
r Y=$B9
r PC=$BBA2
ret
fill $1001 $1006 81 80 00 00 00 00
print "COMPARE"
compare $61 $66 $1001
compare $70 $70 $1003  ; FACOV = 0
print "END"

print "TEST: mov MEM FAC1 const -0.5"
fill $61 $67 FF FF FF FF FF AA
fill $70 $70 CD
r A=$E0
r Y=$B9
r PC=$BBA2
ret
fill $1001 $1006 80 80 00 00 00 FF
print "COMPARE"
compare $61 $66 $1001
compare $70 $70 $1003  ; FACOV = 0
print "END"

print "TEST: FCOMP 1.0 == 1.0"
r A=$BC
r Y=$B9
r PC=$BBA2
ret
r A=$BC
r Y=$B9
r PC=$BC5B
ret
print "CHECK A==0"
r

print "TEST: FCOMP 1.0 > 0.5"
r A=$BC
r Y=$B9
r PC=$BBA2
ret
r A=$11
r Y=$BF
r PC=$BC5B
ret
print "CHECK A==1"
r

print "TEST: FCOMP 0.5 < 1.0"
r A=$11
r Y=$BF
r PC=$BBA2
ret
r A=$BC
r Y=$B9
r PC=$BC5B
ret
print "CHECK A==255"
r

print "TEST: FCOMP -0.5 < 1.0"
r A=$E0
r Y=$B9
r PC=$BBA2
ret
r A=$BC
r Y=$B9
r PC=$BC5B
ret
print "CHECK A==255"
r

print "TEST: FCOMP 10.0 > -0.5"
r A=$F9
r Y=$BA
r PC=$BBA2
ret
r A=$E0
r Y=$B9
r PC=$BC5B
ret
print "CHECK A==1"
r

print "TEST: FCOMP 0.9970194103661925 < 0.9970194105990231"
fill $1001 $1005 80 7F 3C AA 01
r A=$01
r Y=$10
r PC=$BBA2
ret
fill $1006 $100A 80 7F 3C AA 02
r A=$06
r Y=$10
r PC=$BC5B
ret
print "CHECK A==255"
r

print "TEST: FCOMP 0.0 = 0.0"
fill $1001 $1005 00 7F 3C AA 01
r A=$01
r Y=$10
r PC=$BBA2
ret
fill $1006 $100A 00 7F 3C AA 02
r A=$06
r Y=$10
r PC=$BC5B
ret
print "CHECK A==0"
r

q
