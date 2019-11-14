#include <string.h>
#include <stdlib.h>

/**
 * strdup - copy a string into a malloc copy
 */
char *strdup(char *src)
{
	char *tmp = malloc(strlen(src));
	strcpy(tmp, src);
	return tmp;
}
