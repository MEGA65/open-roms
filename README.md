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
