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
