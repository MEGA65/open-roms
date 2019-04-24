# open-roms
A project to create unencumbered open-source ROMs for use on selected retro computers

# Problem Statement

The copyrights of various old computer system ROMs are still alive, and together with trademarks, can present significant
challenges for retro-computing projects to ensure their ability to freely distribute their systems in a functional state,
which typically requires the inclusion of firmware, i.e, "ROMs".

Therefore the goal of this project is to create a fully open-source and unencumbered set of ROMs for various systems.
The initial focus is the C64 and C65 computers, because of the desire to be able to include open ROMs with the MEGA65
retro computer.

# Method and estimated legal situation of reverse engineering

Reverse engineering is a well known science, and enjoys protection under copyright law in a number of jurisdictions,
including the EU and Australia.  Large companies such as Microsoft have also used it in the past in major products
such as Windows.

The generally accepted method is to create a specification from the existing software, and then have a separate team
implement the new software from that specification.  

Interesting challenges in our case include that the software is so widely distributed, that it is much more difficult
to find people who have not been exposed to the original software, which can complicate claims of "cleanness" of the
result.  Also, when talking about a compact 8KB ROM, for example, there may only be so many ways to implement a given
function.  This latter issue is both a disadvantage and advantage, because where there is no choice in implementation,
then it is questionable whether the result can be copyright, because it contains no creative expression.

What we will need to do to minimise the risks, is to describe the creation of each routine and piece of code with
extensive commentary in terms of the specifications, including to explore different potential implementations of
the specification, with justification of which particular implementation is being used.  Where the result is considerably
similar to the original, then further justification will be required to explain how this is inevitable.

In our favour, there is a long history of the publication of information that has been derived from disassembling the
C64 and related Computer's ROMs, e.g., https://www.cubic.org/~doj/c64/mapping128.pdf
We can refer to the contents of such publications, without having to actually look at the contents of the ROMs ourselves.
That is, we can treat the KERNAL and BASIC ROMs as black boxes with specifications and descriptions already captured in these
long standing publications.

# Justifying the interoperability requirement of every routine

For each routine, there should also exist a *.interop file that in comments explains the requirement, and is
followed by one or more test programs that can be demonstrated to not work if this region of the original ROM
does not perform the prescribed function, or if the function is moved to another location in the ROM.

To be as defensive as possible on this front, we need to ideally demonstrate clearly that said program jumps/
calls the prescribed routine at the specific location, so that it is unambiguous that the function must exist
at the location.  A good way to cover this for many situations would be to generate logs of many programs
running, and capturing exactly which entry points are called from where. That is, to generate a call-graph
that is the combination of many program runs, so that we can build up a map of what is required in terms of
correct function of the system.  This then defines the interface exactly from the perspective of interoperability.

We can capture this information using x64 -remotemonitor, and then making a program that connects to port 6510
and uses reset 0 to reset the CPU, and then types step and sends carriage returns repeatedly, and logs the
instruction stream.  If a program is loaded and run, then this will capture the instruction stream, and allow us
to generate this call graph.

# Specific Method

1. Begin with the immutable starting point of the 6502 reset entries, IRQ entry and NMI entries, and the rest of the ROM being empty.  This starting point can have no copyright problems.
2. Based on the public calling interface of the C64 KERNAL, make stub routines for the jump table.
3. All routines begin at the lowest address in the kernal, sorted by routine name.  Thus the order of the routines is deterministic, and not the result of any creative process.
3. Run a test program with the C64 KERNAL, and collect entry points.
4. Implement the routines in the order that the entry points are discovered.
5. Where an entry point does not correspond to a public API of the KERNAL, research the function by searching for it in Google. Implement it according to the first matching reference.
6. Where an entry point means that previously implemented routines have to be moved to make space at a specific address, move only those routines required to do so, to the next available address.
7. Where understanding of the inner workings of a routine are required to replicate it, secondary sources, such as the "Mapping the C128" or "C64 Programmer's Reference Guide" should be used. When those do not provide the answer, internet searches based on the name of the routine should be done, and failing that, based on the routine's address if it has no well known name or insufficient material is turned up.  Reference to actual disassemblies of the ROMs is not to be made, to ensure that we have strong defences against any claim of copyright infringement.

To organise this as we develop, we will assemble the ROM from many separate source files, each with a single routine in it, and with the name of the file matching the routine.  Where code must be placed at a specific address, the file should be called xxxx.routine.s, where xxxx is the address.  We will write a special preprocessor that will take the routines and put them in the correct deterministic order, and make
sure that no address placement violations occur.  To make this easier to do, we are using the Ophis assembler, as it makes it quite easy to check such things.

# Defending against potential copyright infringement claims

Our overall goal is to avoid any potential challenge against this software based on
claims of copyright infringement from whoever may own the copyright to Commodore 64,
65 or 128 computer ROMs.  Therefore, in addition to the above procedure, we have a
tool called similarity that can be run against one of the Commodore ROMs and our
open-source ROMs to look for any similarity exceeding 2 bytes, and provides an
explanation for every such similarity, or shows the sequence of bytes.

Matches of single bytes are excluded, because every byte value is statistically
likely to be present in any substantial program, and thuss cannot possible be copyright.
As similar argument applies to pairs of bytes.

For 3 byte sequences, we ignore all single CPU instructions, as it cannot be argued that
any specific instruction of the 6502 processor could be copyrighted in its binary form.

We also automatically exclude some very common 3 byte sequences, such as any branch
followed by its 1 byte argument and any following opcode.  There is simply no creative
value possible in a pairingg of two instructions, the first of which is a branch.

Similarly, any 3 byte sequence that ends in storing a value into a zero page location is
excluded on the basis that such sequences occur with extreme frequency, and are a natural
result of writing 6502 code.

Similarly loading or comparing the A register, followed by any single instruction cannot
possibly be copyrightable.  Similarly for many other 2-byte instructions.

All other matches of at least 3 bytes are searched for in the strings/ directory for
a file with matching name, and if present, the first line of that file is shown as 
an explanation.  These files contain our opinions on why such sequences cannot be 
copyrightable, or failing that, the subject of any claim of copyright infringement with
respect to the C64/C65/C128 ROMs by their owners.

That is, we are seeking to be totally transparent in the creation of our free ROMs
for these 8-bit computers, and providing reasoned arguments in advance for all to see.
This should appease potential users of them, while also providing clear justification
to anyone who might seek to bring any legal challenge against them.  Basically if you
can't provide a strong argument as to why our reasoning on a given byte sequence is
fatally flawed, then we have every intention to seek dismissal of any case with prejudice
and seeking costs, because we have provided you with access to information that disproves
such a case along with the software, and bringing or threatening to bring any case
against the authors or distributors of this software based on copyright infringement against
the C64/C65/C128 ROMs is therefore clearly vexatious, since it is bought without refuting
our publicly documented explanation as to why this software is not infringing.

# Note regarding trademarks

Commodore and other trademarks are trade-marks of their owners, whoever that may be at any particular point in time.  

