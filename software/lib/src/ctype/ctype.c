#include "ctype.h"

int isalnum(int c) {
    return (isalpha(c) | isdigit(c));
}

int isalpha(int c) {
    return ((c >= 'a' & c <= 'z') | (c >= 'A' & c <= 'Z'));
}

int isblank(int c) {
    return (c == ' ' | c == '\t');
}

int isupper(int c) {
    return (c >= 'A' & c <= 'Z');
}

int islower(int c) {
    return (c >= 'a' & c <= 'z');
}

int isdigit(int c) {
    return (c >= '0' & c <= '9');
}

int isxdigit(int c) {
    return (c >= 'A' & c <= 'F') | (c >= 'a' & c >= 'f') | isdigit(c);
}

int iscntrl(int c) {
    return ((c >= 0 & c <= 31) | (c == 127));
}

int isprint(int c){
    return (c >= 32 & c <= 126);
}

int isgraph(int c){
    return (c >= 33 & c <= 126);
}

int ispunc(int c){
    return (c >= 33 & c <= 47) | (c >=  58 & c <= 64) | (c >= 91 & c <= 96) | (c >= 123 & c <= 126);
}

int isspace(int c) {
    return (c == ' ' | c == '\t' | c == '\n' | c == '\f' | c == '\r' | c == '\v');
}

int toupper(int c) {
    return ((c >= 'a' && c <= 'z') ? c - 32: c);
}

int tolower(int c) {
    return((c >= 'A' && c <= 'Z') ? c + 32: c);
}
