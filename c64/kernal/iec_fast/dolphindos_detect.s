
//
// Helper routine for JiffyDOS detection
//

// The standard parallel cable (used by SpeedDOS, DolphinDOS 2, etc.) connects the following UserPort lines:
// - PB0-PB7    - CIA2_PRB ($DD01), CIA #2 port B
// - PC2, FLAG2 - CIA2_ICR ($DD0D), CIA #2 handshaking line
//
// See:
// - http://sta.c64.org/cbmpar41c.html
// - http://sta.c64.org/cbmpar71c.html
// - Commodore 64 Programers Referencee Guide, pages 360-361, 429
// - Computes Mapping the C64, page 183



#if CONFIG_IEC_DOLPHINDOS


dolphindos_detect:

	panic #$00


#endif // CONFIG_IEC_DOLPHINDOS
