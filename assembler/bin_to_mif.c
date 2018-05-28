#include <stdio.h>
#include <stdlib.h>

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

int main(int argc, char **argv){
  unsigned int addr;
  int c;
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
  fputs("WIDTH=8;\nDEPTH=65536;\nADDRESS_RADIX=UNS;\nDATA_RADIX=BIN;\nCONTENT BEGIN\n", mif_file);

  c = fgetc(bin_file);
  //Read from file
  while(c != EOF){
    fprintf(mif_file, "\t%u : %s%s;\n", addr, bit_rep[c >> 4], bit_rep[c & 0x0F]);
    c = fgetc(bin_file);
    addr++;
  }
  //Write Footer
  fprintf(mif_file, "\t[%u..65535] : 00000000;\n", addr);
  fputs("END;", mif_file);
}
