
//
// XXX Note: something unusual was done with LOAD routine - although the vector at $330 points to $F4A5,
//           the Kernal jump table points to $F49E (see also Mapping the C64, page 76). By experimenting
//           I have already discovered that $F4A5 performs indirect jump via ($0330) vector, but it must
//           be doing a little bit more - not sure yet, what. Something similar is done with SAVE.
//
//           This has to be clarified.
//

LOAD_INT:
    jmp (ILOAD)

