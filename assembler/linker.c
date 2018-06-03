//Not so much a linker as just combining assembley files into one
#include <stdio.h>
#include <stdlib.h>

usage(){
	printf("Usage: scplnk [output file] [input files]\n");
}

FILE *open(char * name, char *md){
	FILE * fp;
	fp = fopen(name, md);
	if(!fp){
		printf("No such file: %s\n", name);
		exit(1);
	}
	return fp;
}

main(int argc, char **argv){
	FILE * out;
	FILE * cur;
	char c;
	unsigned int fnum;
	if(argc < 3){
		usage();
		exit(1);
	}
	fnum = 2;
	out = open(argv[1], "w");
	while(fnum < argc){
		cur = open(argv[fnum], "r");
		c = fgetc(cur);
		while(c != EOF){
			fputc(c, out);
			c = fgetc(cur);
		}
		fclose(cur);
		fputc('\n', out);
		fnum++;
	}
}
