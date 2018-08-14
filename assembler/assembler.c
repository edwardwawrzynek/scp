#include <stdio.h>
#include <stdlib.h>

#define IS_SCP 1
//comment out to compile on scp
#undef IS_SCP

//Number of commands
#define NUM_CMDS 71
//Length of array for cmds - NUM_CMDS * 5
#define CMD_ARRAY_LEN 355

//Command names
char cmds[CMD_ARRAY_LEN] = "nop \0lbia\0lbib\0lwia\0lwib\0lbpa\0lbpb\0lwpa\0lwpb\0lbqa\0lbqb\0lwqa\0lwqb\0lbma\0lbmb\0lwma\0lwmb\0sbpb\0swpb\0sbqa\0swqa\0sbma\0sbmb\0swma\0swmb\0aadd\0asub\0amul\0abor\0abxr\0abnd\0assr\0ashr\0ashl\0aneg\0alng\0abng\0aclv\0aequ\0aneq\0aslt\0ault\0asle\0aule\0asex\0aaeb\0jmp \0jpnz\0jpz \0inca\0incb\0deca\0decb\0xswp\0mdsp\0masp\0mspa\0psha\0pshb\0popa\0popb\0call\0ret \0outa\0ina \0jmpa\0aptb\0prvu\0prvs\0mmus\0bspa\0";
//length not including opcode byte
char cmd_lens[NUM_CMDS] = {0, 1, 1, 2, 2, 0, 0, 0, 0, 0, 0, 0, 0, 2, 2, 2, 2, 0, 0, 0, 0, 2, 2, 2, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 2, 2, 0, 0, 0, 0, 0, 2, 0, 2, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 1};

//maximum line length - including null
#define LINE_SIZE 81

//file reading operations
char line [LINE_SIZE];
unsigned int lptr;
unsigned int line_num;

//File IO
FILE *inf;
FILE *outf;

//Return types
#ifndef IS_SCP
#define CHARP char *
#define INT int
#define VOID void
#endif

#ifdef IS_SCP
#define CHARP
#define INT
#define VOID
#endif

VOID error(char * err){
	int i;
	printf("scpasm: Error: %s\nLine: %u\n--------\n%s\n", err, line_num, line);
	for(i = 0; i < lptr; ++i){
		putchar(' ');
	}
	printf("^\n");
	exit(1);
}

//open files
VOID open_files(char * in, char * out){
	inf = fopen(in, "r");
	outf = fopen(out, "w");
	if(!inf){
		printf("scpasm: Error: no such file: %s\n", in);
		exit(1);
	}
	if(!outf){
		printf("scpasm: Error: can't open output file: %s\n", out);
		exit(1);
	}
}

//handle args
VOID handle_args(int argc, char **argv){
	if(argc != 3){
		printf("Usage: scpasm [out] [in.s]\n");
		exit(1);
	}
	open_files(argv[2], argv[1]);
}

//checks if a string is just whitespace
INT is_whitespace(char * s){
	while(*s == ' ' || *s == '\t' || *s == '\n' || *s == '\0'){
		if(*s == '\0'){
			return 1;
		}
		++s;
	}
	return 0;
}


//read a valid line into line, resetting lptr
//returns 1 on success, 0 on EOF
INT read_line_raw(){
	char c;
	++line_num;
	lptr = 0;
	do {
		c = fgetc(inf);
		if(c == EOF){
			return 0;
		}
		if(c == '\n'){
			line[lptr++] = 0;
		} else {
			line[lptr++] = c;
		}
	} while(c != '\n');
	lptr = 0;
	return 1;
}

//same as read_line_raw, but skips comments and skips empty lines
INT read_line(){
	do {
		if(!read_line_raw()){
			return 0;
		}
	} while(*line == ';' || is_whitespace(line));
	return 1;
}

//set name to just be a label
//returns pointer to name if label, NULL if otherwise
CHARP read_label(){
	if(*line == '\t'){
		return NULL;
	}
	while(line[lptr] != ':'){
		if(!line[lptr]){
			error("expected : after label");
		}
		++lptr;
	}
	line[lptr] = '\0';
	return line;
}

INT main(int argc, char **argv){
	char * label;

	handle_args(argc, argv);

	while(read_line()){
		label = read_label();
		if(label){
			printf("%s\n", label);
		}
	}
}
