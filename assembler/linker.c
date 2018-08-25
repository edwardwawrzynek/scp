//Not so much a linker as just combining assembley files into one

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void usage(){
	printf("Usage: scplnk [option] [output file] [input files]\nOptions:\n-i [.incl file] :link files listed in the .incl file, placing them directly after the first passed input file\n");
}

FILE *open(char * name, char *md){
	FILE * fp;
	fp = fopen(name, md);
	if(!fp){
		printf("scplnk: No such file: %s\n", name);
		exit(1);
	}
	return fp;
}

int main(int argc, char **argv){
	FILE * out;
	FILE * cur;
	char c;
	unsigned int fnum;
	char *incl;
	FILE *inclf;
	//for reading incl
	char * line = NULL;
  size_t len = 0;
  ssize_t read;
	char incl_file[100];
	char *s;
	incl = NULL;
	if(argc < 3){
		usage();
		exit(1);
	}
	fnum = 2;
	if(!strcmp(argv[1], "-i")){
		incl = argv[2];
		fnum = 4;
	}												 
	out = open(argv[1 + (fnum-2)], "w");
	//Add first file
	cur = open(argv[fnum], "r");
	c = fgetc(cur);
	while(c != EOF){
		fputc(c, out);
		c = fgetc(cur);
	}
	fclose(cur);
	fputc('\n', out);
	fnum++;
	//Add files from .incl
	if(incl != NULL){
		inclf = open(incl, "r");
		 while ((read = getline(&line, &len, inclf)) != -1) {
			 	strcpy(incl_file, line);
			 	//Change .h to .s
				s = incl_file;
				while(*(++s)){}
				*(--s) = '\0';
				*(--s) = 's';
			 	//attempt to open
				cur = fopen(incl_file, "r");
			 	if(!cur){
					printf("scplnk: no .s file found for included file: %s", line); 
			 	}
				else{
					//copy to out
					c = fgetc(cur);
					while(c != EOF){
						fputc(c, out);
						c = fgetc(cur);
					}
					fclose(cur);
					fputc('\n', out);
				}
    }
	}
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
	fclose(out);
}
