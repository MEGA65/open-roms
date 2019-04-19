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

