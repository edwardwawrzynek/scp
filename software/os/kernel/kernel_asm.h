/* load buf into bootloader block, and jump to it */
void kernel_load_bootloader_block(__reg("ra") uint8_t * buf);
