# Focus must be on interoperability

In terms of the goal of ensuring interoperability, it is vital that the public interfaces match.
We believe that this activity very closely matches that described in section 12 of
http://classic.austlii.edu.au/au/journals/JlLawInfoSci/2003/2.html
and thus is allowable.

From an interoperability perspective, we should ideally justify why each function, memory location
etc is required, by providing an example existing C64 program that will fail if it is not correct,
thus establishing that every single thing is required for interoperability.

Also, where there are similarities to the original in any routine, these should also ideally be
justified by again finding software that does not work if the content is changed.

# C64 KERNAL Memory Range

While the KERNAL is often referred to as the ROM from $E000-$FFFF, analysis of publicly
available disassemblies, such as https://github.com/mist64/c64rom/blob/master/c64rom_en.txt,
reveal that the KERNAL actually is only the part $E4D3-$FFFF -- the earlier part actually
being parts of the BASIC ROM that did not fit in the 8KB BASIC ROM.

Notably, the boot message of a C64 is thus part of the BASIC, and not the KERNAL.
Thus switching the KERNAL part will not change the boot message.  That will occur only
when the BASIC ROM is also replaced.

# Public jump table

# ZP and other well-known RAM usage

The KERNAL uses $90-$FF for various things,
$100-$13D as temporary storage of tape data,
$259-$2A6 for various housekeeping things.
$0314-$0333 for vectors
$033C-$03FB for casette data buffer

Reference: http://sta.c64.org/cbm64mem.html
