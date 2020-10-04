
The C64 ROM is typically distributed in 2 files 8 KB each, one called *kernal*, one *basic*. This might be misleading, as the C64 Kernal takes about 6.5 KB, and the BASIC about 9.5 KB - some parts of BASIC is therefore placed in the *kernal* file. This is the main reason you can't easily use the Open ROMs Kernal file with original C64 BASIC.

But it is still possible to combine them:
* copy the *kernal* file to the *open-roms* main directory
* from the Linux command line type `make test_hybrid` - this will crate the hybrid Kernal file, *open-roms/bin/kernal_hybrid.rom*, and launch VICE emulator with it

Sorry, no Windows support (but it should work under *Windows Subsystem for Linux* if GCC and libpng devel packages are installed), and no macOS support (I don't have a machine to test).

Please note, that it is illegal to distribute such a hybrid ROM:

* it contains proprietary Commodore/Microsoft code
* it contains LGPL 3 licensed Open ROMs code combined with code not available under compatible license
