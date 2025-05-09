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
fill $1001 $1006 80 80 00 00 00 80
print "COMPARE"
compare $61 $66 $1001
compare $70 $70 $1003  ; FACOV = 0
print "END"

print "TEST: get_FAC1_via_INDEX -0.5"
fill $61 $66 FF FF FF FF FF AA
fill $22 $23 E0 B9
r PC=$BBA6
ret
fill $1001 $1006 80 80 00 00 00 80
print "COMPARE"
compare $61 $66 $1001
print "END"

print "TEST: mov MEM FAC2 const 1.0"
fill $69 $6E FF FF FF FF FF AA
r A=$BC
r Y=$B9
r PC=$BA8C
ret
fill $1001 $1006 81 80 00 00 00 00
print "COMPARE"
compare $69 $6E $1001
print "END"

print "TEST: mov MEM FAC2 const -0.5"
fill $69 $6E FF FF FF FF FF AA
r A=$E0
r Y=$B9
r PC=$BA8C
ret
fill $1001 $1006 80 80 00 00 00 80
print "COMPARE"
compare $69 $6E $1001
print "END"

print "TEST: get_FAC2_via_INDEX -0.5"
fill $69 $6E FF FF FF FF FF AA
fill $22 $23 E0 B9
r PC=$BA90
ret
fill $1001 $1006 80 80 00 00 00 80
print "COMPARE"
compare $69 $6E $1001
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

print "TEST: int_FAC1 0.0"
fill $61 $61 00
r PC=$BCCC
ret
fill $1001 $1001 00
print "COMPARE"
compare $61 $61 $1001
print "END"

print "TEST: int_FAC1 1.0"
fill $61 $66 81 80 00 00 00 00
r PC=$BCCC
ret
fill $1001 $1006 81 80 00 00 00 00
print "COMPARE"
compare $61 $66 $1001
print "END"

print "TEST: int_FAC1 1.5"
fill $61 $66 81 C0 00 00 00 00
r PC=$BCCC
ret
fill $1001 $1006 81 80 00 00 00 00
print "COMPARE"
compare $61 $66 $1001
print "END"

print "TEST: int_FAC1 1.5"
fill $61 $66 81 C0 00 00 00 00
r PC=$BCCC
ret
fill $1001 $1006 81 80 00 00 00 00
print "COMPARE"
compare $61 $66 $1001
print "END"

print "TEST: int_FAC1 0.5"
fill $61 $66 80 80 00 00 00 00
r PC=$BCCC
ret
fill $1001 $1001 00
print "COMPARE"
compare $61 $61 $1001
print "END"

print "TEST: int_FAC1 4.00000006519258"
fill $61 $66 83 80 00 00 23 00
r PC=$BCCC
ret
fill $1001 $1006 83 80 00 00 00 00
print "COMPARE"
compare $61 $66 $1001
print "END"

print "TEST: int_FAC1 -4.00000006519258"
fill $61 $66 83 80 00 00 23 FF
r PC=$BCCC
ret
fill $1001 $1006 83 A0 00 00 00 FF
print "COMPARE"
compare $61 $66 $1001
print "END"

print "TEST: int_FAC1 4398016684.0"
fill $61 $66 A1 83 12 34 56 00
r PC=$BCCC
ret
fill $1001 $1006 A1 83 12 34 56 00
print "COMPARE"
compare $61 $66 $1001
print "END"

print "TEST: int_FAC1 134216.81774902344"
fill $61 $66 92 83 12 34 56 00
r PC=$BCCC
ret
fill $1001 $1006 92 83 12 00 00 00
print "COMPARE"
compare $61 $66 $1001
print "END"

print "TEST: inv_FAC1_mantissa 0"
fill $62 $65 00 00 00 00
r PC=$B947
ret
fill $1001 $1004 00 00 00 00
print "COMPARE"
compare $62 $65 $1001
print "END"

print "TEST: inv_FAC1_mantissa 1"
fill $62 $65 00 00 00 01
r PC=$B947
ret
fill $1001 $1004 FF FF FF FF
print "COMPARE"
compare $62 $65 $1001
print "END"

print "TEST: inv_FAC1_mantissa 2130706432"
fill $62 $65 7F 00 00 00
r PC=$B947
ret
fill $1001 $1004 81 00 00 00
print "COMPARE"
compare $62 $65 $1001
print "END"

print "TEST: inv_FAC1_mantissa -100"
fill $62 $65 FF FF FF 9C
r PC=$B947
ret
fill $1001 $1004 00 00 00 64
print "COMPARE"
compare $62 $65 $1001
print "END"

print "TEST: FIN 1"
fill $61 $66 FF FF FF FF FF CC
fill $7A $7B $00 $05
fill $500 $501 31 00
r A=$31
r FL=$20
r PC=$BCF3
ret
fill $1001 $1006 81 80 00 00 00 00
print "COMPARE"
compare $61 $66 $1001
print "END"


print "TEST: FIN 17"
fill $61 $66 FF FF FF FF FF CC
fill $7A $7B $00 $05
fill $500 $502 31 37 00
r A=$31
r FL=$20
r PC=$BCF3
ret
fill $1001 $1006 85 88 00 00 00 00
print "COMPARE"
compare $61 $66 $1001
print "END"

print "TEST: FIN +17"
fill $61 $66 FF FF FF FF FF CC
fill $7A $7B $00 $05
fill $500 $503 2B 31 37 00
r A=$2B
r FL=$21
r PC=$BCF3
ret
fill $1001 $1006 85 88 00 00 00 00
print "COMPARE"
compare $61 $66 $1001
print "END"

print "TEST: FIN -17"
fill $61 $66 FF FF FF FF FF CC
fill $7A $7B $00 $05
fill $500 $503 2D 31 37 00
r A=$2D
r FL=$21
r PC=$BCF3
ret
fill $1001 $1006 85 88 00 00 00 FF
print "COMPARE"
compare $61 $66 $1001
print "END"

print "TEST: FIN 20E1"
fill $61 $66 FF FF FF FF FF CC
fill $7A $7B $00 $05
fill $500 $504 32 30 45 31 00
r A=$32
r FL=$20
r PC=$BCF3
ret
fill $1001 $1006 88 C8 00 00 00 00
print "COMPARE"
compare $61 $66 $1001
print "END"

print "TEST: FIN 20.0E1"
fill $61 $66 FF FF FF FF FF CC
fill $7A $7B $00 $05
fill $500 $506 32 30 2E 30 45 31 00
r A=$32
r FL=$20
r PC=$BCF3
ret
fill $1001 $1006 88 C8 00 00 00 00
print "COMPARE"
compare $61 $66 $1001
print "END"

print "TEST: FIN 20.0E+1"
fill $61 $66 FF FF FF FF FF CC
fill $7A $7B $00 $05
fill $500 $507 32 30 2E 30 45 2B 31 00
r A=$32
r FL=$20
r PC=$BCF3
ret
fill $1001 $1006 88 C8 00 00 00 00
print "COMPARE"
compare $61 $66 $1001
print "END"

print "TEST: FIN 200E-1"
fill $61 $66 FF FF FF FF FF CC
fill $7A $7B $00 $05
fill $500 $507 32 30 30 45 2D 31 00
r A=$32
r FL=$20
r PC=$BCF3
ret
fill $1001 $1006 88 C8 00 00 00 00
print "COMPARE"
compare $61 $66 $1001
print "END"

print "TEST: FIN 123E-100"
fill $61 $66 FF FF FF FF FF CC
fill $7A $7B $00 $05
fill $500 $509 31 32 33 45 2D 31 30 30 00
r A=$32
r FL=$20
r PC=$BCF3
ret
fill $1001 $1001 00
print "COMPARE"
compare $61 $61 $1001
print "END"

print "TEST: FINLOG 1.0 + 1"
fill $61 $66 81 80 00 00 00 00
r A=1
r PC=$BD7E
ret
fill $1001 $1006 82 80 00 00 00 00
print "COMPARE"
compare $61 $66 $1001
print "END"

print "TEST: FINLOG 1.0 + 0"
fill $61 $66 81 80 00 00 00 00
r A=0
r PC=$BD7E
ret
fill $1001 $1006 81 80 00 00 00 00
print "COMPARE"
compare $61 $66 $1001
print "END"

print "TEST: FINLOG 2.0 + 9"
fill $61 $66 82 80 00 00 00 00
r A=9
r PC=$BD7E
ret
fill $1001 $1006 84 B0 00 00 00 00
print "COMPARE"
compare $61 $66 $1001
print "END"

print "TEST: STRVAL 200E-1"
fill $61 $66 FF FF FF FF FF CC
fill $22 $23 $00 $05
fill $500 $507 32 30 30 45 2D 31 31
r A=6
r PC=$B7B5
ret
fill $1001 $1006 88 C8 00 00 00 00
print "COMPARE"
compare $61 $61 $1001
print "END"

print "TEST: div FAC2 FAC1 0.0 / 1.0 = 0.0"
fill $61 $66 81 80 00 00 00 00
fill $70 $70 00
fill $69 $6E 00 FF FF FF FF 00
r PC=$BB12
ret
print "COMPARE"
compare $61 $61 $69
compare $70 $70 $6E  ; FACOV = 0
print "END"

print "TEST: div FAC2 FAC1 1.0 / 1.0 = 1.0"
fill $61 $66 81 80 00 00 00 00
fill $70 $70 00
fill $69 $6E 81 80 00 00 00 00
r PC=$BB12
ret
fill $1001 $1006 81 80 00 00 00 00
print "COMPARE"
compare $61 $66 $1001
compare $70 $70 $6E  ; FACOV = 0
print "END"

print "TEST: div FAC2 FAC1 -1.0 / 1.0 = -1.0"
fill $61 $66 81 80 00 00 00 80
fill $70 $70 00
fill $69 $6E 81 80 00 00 00 00
r PC=$BB12
ret
fill $1001 $1006 81 80 00 00 00 80
print "COMPARE"
compare $61 $66 $1001
compare $70 $70 $1003  ; FACOV = 0
print "END"

print "TEST: div FAC2 FAC1 1.0 / -1.0 = -1.0"
fill $61 $66 81 80 00 00 00 00
fill $70 $70 00
fill $69 $6E 81 80 00 00 00 80
r PC=$BB12
ret
fill $1001 $1006 81 80 00 00 00 80
print "COMPARE"
compare $61 $66 $1001
compare $70 $70 $1003  ; FACOV = 0
print "END"

print "TEST: div FAC2 FAC1 1.0 / 2.0 = 0.5"
fill $61 $66 82 80 00 00 00 00
fill $70 $70 00
fill $69 $6E 81 80 00 00 00 00
r PC=$BB12
ret
fill $1001 $1006 80 80 00 00 00 00
print "COMPARE"
compare $61 $66 $1001
compare $70 $70 $1003  ; FACOV = 0
print "END"

print "TEST: div FAC2 FAC1 2.0 / 0.5 = 4.0"
fill $61 $66 80 80 00 00 00 00
fill $70 $70 00
fill $69 $6E 82 80 00 00 00 00
r PC=$BB12
ret
fill $1001 $1006 83 80 00 00 00 00
print "COMPARE"
compare $61 $66 $1001
compare $70 $70 $1003  ; FACOV = 0
print "END"

print "TEST: div FAC2 FAC1 3.0 / 0.5 = 6.0"
fill $61 $66 80 80 00 00 00 00
fill $70 $70 00
fill $69 $6E 82 C0 00 00 00 00
r PC=$BB12
ret
fill $1001 $1006 83 C0 00 00 00 00
print "COMPARE"
compare $61 $66 $1001
compare $70 $70 $1003  ; FACOV = 0
print "END"

print "TEST: div FAC2 FAC1 1.0 / 10.0 = 0.1"
fill $61 $66 84 A0 00 00 00 00
fill $70 $70 00
fill $69 $6E 81 80 00 00 00 00
r PC=$BB12
ret
# Slight rounding error here. Should be CC at the end
fill $1001 $1006 7D CC CC CC C8 00
print "COMPARE"
compare $61 $66 $1001
compare $70 $70 $1006  ; FACOV = 0
print "END"

print "TEST: div10_FAC1 1.0 = 0.1"
fill $61 $66 81 80 00 00 00 00
fill $70 $70 00
r PC=$BAFE
ret
# Slight rounding error here. Should be CC at the end
fill $1001 $1007 7D CC CC CC C8 20 00
print "COMPARE"
compare $61 $66 $1001
compare $70 $70 $1007  ; FACOV = 0
print "END"

q
