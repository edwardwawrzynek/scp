#include "machine_back.c"

//Buffer for operands being operated on - nothing should be more than 30 chars


main(int argc, char **argv){
  //For scp, set argc and argv
  if(argc < 2){
    usage();
  }
  open_asm(argv[1]);
  file_restart();
}

usage(){
  print("Usage: scpasm [one or more asm files]\n");
  err_exit();
}
