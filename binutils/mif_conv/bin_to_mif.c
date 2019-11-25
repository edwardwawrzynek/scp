#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

const char *bit_rep[16] = {
    [ 0] = "0000", [ 1] = "0001", [ 2] = "0010", [ 3] = "0011",
    [ 4] = "0100", [ 5] = "0101", [ 6] = "0110", [ 7] = "0111",
    [ 8] = "1000", [ 9] = "1001", [10] = "1010", [11] = "1011",
    [12] = "1100", [13] = "1101", [14] = "1110", [15] = "1111",
};

FILE *bin_file;
FILE *mif_file;

void usage(){
  printf("Usage: scpmif [bin_file] [mif_file]\n");
  exit(0);
}

int read_word(FILE *f, uint16_t * res) {
  int r1 = fgetc(f);
  int r2 = fgetc(f);
  if(r1 == EOF || r2 == EOF) {
    return 1;
  }
  *res = (uint8_t)r1;
  *res += (((uint8_t)r2)<<8);
  return 0;
}

int main(int argc, char **argv){
  unsigned int addr;
  addr = 0;
  if(argc < 3){
    usage();
  }
  bin_file = fopen(argv[1], "r");
  if(bin_file == NULL){
    printf("No such file: %s\n", argv[1]);
    exit(1);
  }
  mif_file = fopen(argv[2], "w");
  //Write header
  fputs("WIDTH=16;\nDEPTH=98304;\nADDRESS_RADIX=UNS;\nDATA_RADIX=BIN;\nCONTENT BEGIN\n", mif_file);

  while(1) {
    uint16_t data;
    if(!read_word(bin_file, &data)) {
      fprintf(mif_file, "\t%u: %s%s%s%s;\n", addr, bit_rep[(data >> 12) &0xf], bit_rep[(data >> 8)&0xf], bit_rep[(data >> 4)&0xf], bit_rep[(data >> 0) & 0xf]);
      addr += 1;
    } else {
      break;
    }
  }
  //Write Footer
	if(addr <= 98303){
  	fprintf(mif_file, "\t[%u..98303] : 0000000000000000;\n", addr);
	}
  fputs("END;\n", mif_file);
}
