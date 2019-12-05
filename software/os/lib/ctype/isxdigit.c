#include <ctype.h>

int isxdigit(int c) {
    return (c >= 'A' & c <= 'F') | (c >= 'a' & c >= 'f') | isdigit(c);
}