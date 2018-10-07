#include <stdio.h>
#include <stdlib.h>
#include <string.h>

//define to compile on scp
//#define MACHINE_SCP 1

//Number of commands
#define NUM_CMDS 74
//Length of array for cmds - NUM_CMDS * 5
#define CMD_ARRAY_LEN 370

//maximum line length - including null
#define LINE_SIZE 257

//maximum label length - including null
#define LABEL_SIZE 129

//increment to realloc labels array on - number of labels
#define LABEL_ALLOC_SIZE 64

//Return types
#ifndef MACHINE_SCP
#define CHARP char *
#define INT int
#define UINT unsigned int
#define VOID void
#define SLABELP struct label *
#endif

#ifdef MACHINE_SCP
#define CHARP
#define INT
#define UINT
#define VOID
#define SLABELP
#endif

unsigned int sflag;
unsigned int eflag;
unsigned int dflag;

char * dfile;
FILE * debug_file;

//a label
struct label {
	//name, including $ for module labels - malloc'd
	char name[LABEL_SIZE];
	//addr
	unsigned int addr;
	//module number, or -1 for globals
	int mod_num;
};

//list of labels - malloc'd
struct label * labels;
//number of labels malloc'd
unsigned int labels_allocd;
//number of used labels
unsigned int labels_used;

//Command names
char cmds[CMD_ARRAY_LEN] = "nop \0lbia\0lbib\0lwia\0lwib\0lbpa\0lbpb\0lwpa\0lwpb\0lbqa\0lbqb\0lwqa\0lwqb\0lbma\0lbmb\0lwma\0lwmb\0sbpb\0swpb\0sbqa\0swqa\0sbma\0sbmb\0swma\0swmb\0aadd\0asub\0amul\0abor\0abxr\0abnd\0assr\0ashr\0ashl\0aneg\0alng\0abng\0aclv\0aequ\0aneq\0aslt\0ault\0asle\0aule\0asex\0aaeb\0jmp \0jpnz\0jpz \0inca\0incb\0deca\0decb\0xswp\0mdsp\0masp\0mspa\0psha\0pshb\0popa\0popb\0call\0ret \0outa\0ina \0jmpa\0aptb\0prvu\0prvs\0mmus\0bspa\0bdsp\0bspl\0ktou\0";
//length not including opcode byte
char cmd_lens[NUM_CMDS] = {0, 1, 1, 2, 2, 0, 0, 0, 0, 0, 0, 0, 0, 2, 2, 2, 2, 0, 0, 0, 0, 2, 2, 2, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 2, 2, 0, 0, 0, 0, 0, 2, 0, 2, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0};

//file reading operations
char line [LINE_SIZE];
unsigned int lptr;
unsigned int line_num;

char arg [LINE_SIZE];

//File IO
FILE *inf;
FILE *outf;

//current addr in file
unsigned int addr;

unsigned int addr_start = 0;

//current module number
unsigned int module = 0;


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
	unsigned int argv_off;
	argv_off = 0;
	if(argc < 3){
		printf("Usage: scpasm [options] [out] [in.s]\nOptions:\n-e\t\t:pad the output to the end of the addr space\n-s\t\t:display the size of the binary\n-d debug.txt\t:output a debug file\n");
		exit(1);
	}
	while(*argv[1+argv_off] == '-'){
		if(argv[1+argv_off][1] == 'e'){
			eflag = 1;
			argv_off += 1;
		}
		else if(argv[1+argv_off][1] == 's'){
			sflag = 1;
			argv_off += 1;
		}
		else if(argv[1+argv_off][1] == 'd'){
			dflag = 1;
			dfile = argv[2+argv_off];
			argv_off += 2;
			debug_file = fopen(dfile, "w");
			if(debug_file == NULL){
				printf("Couldn't open dbug file: %s\n", dfile);
				exit(1);
			}
		}

	}
	open_files(argv[2+argv_off], argv[1+argv_off]);
}

//first alloc of labels
VOID labels_alloc(){
	labels = malloc(LABEL_ALLOC_SIZE * sizeof(struct label));
	labels_allocd = LABEL_ALLOC_SIZE;
}

//realloc labels to contain another group of LABEL_ALLOC_SIZE
VOID labels_realloc(){
	labels_allocd += LABEL_ALLOC_SIZE;
	labels = realloc(labels, labels_allocd * sizeof(struct label));
}

//get a label pointer for a new label
SLABELP label_new(){
	if(labels_used >= labels_allocd){
		labels_realloc();
	}
	return labels + (labels_used++);
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
	int c;
	++line_num;
	lptr = 0;
	do {
		c = fgetc(inf);
		if(c == EOF){
			return 0;
		}
		if(c == '\n'){
			line[lptr++] = 0;
		} else if (c == ':' && *line != ';'){
			line[lptr++] = ':';
			line[lptr] = 0;
			lptr = 0;
			--line_num;
			return 1;
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
	// If the line starts with a tab or at least two spaces, it is a cmd, so return
	if(line[0] == '\t' || (line[0] == ' ' && line[1] == ' ')){
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

//clear blanks in the line
VOID blanks(){
	while(line[lptr] == ' ' || line[lptr] == '\t' || line[lptr] == '\n'){
		++lptr;
	}
}

//read until next whitespace
VOID read_to_white(){
	while(line[lptr] != ' ' && line[lptr] != '\t'){
		++lptr;
	}
}

//match a cmd name, and return its instr addr, -1 if directive, or error if neither
INT match_cmd(){
	unsigned int i;
	blanks();
	//check for directive
	if(line[lptr] == '.'){
		return -1;
	}
	//check name
	for(i = 0; i < NUM_CMDS; ++i){
		if(!memcmp(line+lptr, (cmds + i*5), 4)){
			return i;
		}
	}
	error("no such command");
	return 0;
}

//get an arg from the current location, copying it to arg
//returns 1 if an arg was found, or 0 if not found
INT get_arg(){
	unsigned int i;
	blanks();
	if(!line[lptr]){
		return 0;
	}
	i = 0;
	if(line[lptr] == ','){
		++lptr;
	}
	while(line[lptr] && line[lptr] != ','){
		arg[i++] = line[lptr++];
	}
	arg[i] = '\0';
	return 1;
}

//get the size in bytes of a directive located at line+lptr
INT get_dir_size(){
	unsigned int i;
	i = 0;
	if(!memcmp(line+lptr, ".db", 3)){
		read_to_white();
		while(get_arg()){++i;}
		return i;
	}
	if(!memcmp(line+lptr, ".dw", 3)){
		read_to_white();
		while(get_arg()){++i;}
		return i<<1;
	}
	if(!memcmp(line+lptr, ".ds", 3)){
		read_to_white();
		if(!get_arg()){
			error(".ds requires an argument");
		}
		i = atoi(arg+1);
		return i;
	}
	if(!memcmp(line+lptr, ".module", 7)){
		++module;
		return 0;
	}
	error("no such directive");
	return 0;
}

UINT exists_label(char * name, int module){
	unsigned int i;
	for(i = 0; i < labels_used+1;++i){
		if(!strcmp(name, labels[i].name) && (labels[i].mod_num == module || labels[i].mod_num == -1)){
			return 1;
		}
	}
	return 0;
}

//run the addr resolution pass on the file
VOID addr_pass(){
	char * label;
	unsigned int cmd;
	struct label * new_label;

	addr = addr_start;
	module = 0;
	while(read_line()){
		if(dflag){
			fprintf(debug_file, "0x%04x: %s\n", addr, line);
		}
		label = read_label();
		if(label){
			if(exists_label(label, module)){
				printf("Warning: label %s is defined multipule times\n", label);
			}
			//add label
			new_label = label_new();
			strcpy(new_label->name, label);
			new_label->addr = addr;
			new_label->mod_num = (*label=='$') ? module: -1;
		} else {
			cmd = match_cmd();
			if(cmd == -1){
				addr += get_dir_size();
			} else{
				addr += cmd_lens[cmd] + 1;
			}
		}
	}
}

//return the addr of a symbol, given the module number
UINT label_addr(char * name, int module){
	unsigned int i;
	for(i = 0; i < labels_used+1;++i){
		if(!strcmp(name, labels[i].name) && (labels[i].mod_num == module || labels[i].mod_num == -1)){
			return labels[i].addr+addr_start;
		}
	}
	printf("scpasm: label not defined: %s\n", name);
	error("no such label");
	return 0;
}

//evaluate an argument to a value - handles labels and literals
UINT arg_val(char *arg, unsigned int module){
	char * plusi;
	unsigned int add;
	add = 0;
	//apply +#'s
	plusi = strchr(arg, '+');
	if(plusi){
		*plusi = 0;
		add = atoi(plusi+2);
	}
	if(*arg == '#'){
		return atoi(arg+1)+add;
	} else {
		return label_addr(arg, module)+add;
	}
}

//output a value to the output file
VOID out_v(unsigned int val, unsigned char num_b){
	while(num_b--){
		fputc(val&0xff, outf);
		val>>=8;
	}
}

//output a directive
VOID output_dir(){
	unsigned int i;
	i = 0;
	blanks();
	if(!memcmp(line+lptr, ".db", 3)){
		read_to_white();
		while(get_arg()){out_v(arg_val(arg, module), 1);}
		return;
	}
	if(!memcmp(line+lptr, ".dw", 3)){
		read_to_white();
		while(get_arg()){out_v(arg_val(arg, module), 2);}
		return;
	}
	if(!memcmp(line+lptr, ".ds", 3)){
		read_to_white();
		if(!get_arg()){
			error(".ds requires an argument");
		}
		i = atoi(arg+1);
		while(i--){
			out_v(0, 1);
		}
		return;
	}
	if(!memcmp(line+lptr, ".module", 7)){
		++module;
		return;
	}
	error("no such directive");
}

//pad output with addr_start zeros
VOID pad_out(){
	unsigned int i;
	for(i = 0; i < addr_start; ++i){
		out_v(0,1);
	}
}

//run the output pass
VOID out_pass(){
	int cmd;
	char * label;
	fseek(inf, 0, SEEK_SET);
	line_num=0;
	pad_out();
	module = 0;
	while(read_line()){
		label = read_label();
		if(label){
			//don't do anything with labels
			continue;
		} else {
			cmd = match_cmd();
			if(cmd == -1){
				output_dir();
			} else{
				//write out cmd opcode
				out_v(cmd, 1);
				//if nessesary, read in arg
				if(cmd_lens[cmd]){
					read_to_white();
					if(!get_arg()){
						error("cmd requires and argument");
					}
					out_v(arg_val(arg, module), cmd_lens[cmd]);
				}
			}
		}
	}
}

INT main(int argc, char **argv){

	handle_args(argc, argv);
	labels_alloc();
	addr_pass();
	if(sflag){
		printf("Size: %u\n", addr);
	}
	if(eflag){
		addr_start = 65536-addr;
	}
	out_pass();
	free(labels);
}
