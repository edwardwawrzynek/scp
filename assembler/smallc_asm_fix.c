#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

//Fixes smallc file to do proper #asm directives
//This is done by replacing spaces between #asm adn #endasm with tabs, and making sure the end of each line is properly tabbed

FILE * open(char * file, char * mode){
    FILE * res = fopen(file, mode);
    if(res == NULL){
        printf("scpcasmfix: No such file: %s\n", file);
        exit(1);
    }
}

int isspace(char *line){
    while(*(line)){
        if(*line != '\t' && *line != ' ' && *line != '\n'){
            return 0;
        }
        ++line;
    }
    return 1;
}

FILE *in;
FILE *out;
char *line;
size_t bufsize = 16;
size_t chars;
unsigned char in_asm;

//position in line
char *pos;

int main(int argc, char **argv){
    if(argc != 3){
        printf("Usage: scpcasmfix [input.c] [output.c]\n");
        exit(0);
    }
    in = open(argv[1], "r");
    out = open(argv[2], "w");
    
    while(1){
        line = (char *)malloc(bufsize * sizeof(char));
        chars = getline(&line,&bufsize,in);
        if(chars == -1){
            break;
        }
        //check for asm or endasm tags - they will be on their own line
        if(strstr(line, "#asm")){
            in_asm = 1;
            fputs("#asm\n", out);
            continue;
        }
        else if(strstr(line, "#endasm")){
            in_asm = 0;
            fputs("#endasm\n", out);
            continue;
        }
        else if(!in_asm){
            //Not asm, so write the line out as it is
            fputs(line, out);
            continue;
        }
        //This line is in an #asm area
        //Don't handle comment lines
        if(strchr(line, ';')){
            continue;
        }
        //Don't handle empty lines
        if(isspace(line)){
            continue;
        }
        pos = line;
        unsigned char is_indented = 0;
        unsigned char arg_chars = 0;
        while(*pos == ' ' || *pos == '\t'){
            is_indented = 1;
            ++pos;
        }
        //Write a tab if the line was indented
        if(is_indented){
            fputc('\t', out);
        }
        //Write out the non space chars
        while(*pos != ' ' && *pos != '\t' && *pos != '\n'){
            fputc(*pos, out);
            ++arg_chars;
            ++pos;
        }
        //Buffer less than four letter commands with spaces
        while(is_indented && arg_chars < 4){
            fputc(' ', out);
            ++arg_chars;
        }
        //output seperating tab
        if(is_indented){
            fputc('\t', out);
        }
        //skip through spaces
        while(*pos == ' ' || *pos == '\t' || *pos == '\n'){
            if(*pos == '\n'){
                break;
            }
            ++pos;
        }
        //output remainder of line (including newline)
        fputs(pos, out);
        
    }
}
