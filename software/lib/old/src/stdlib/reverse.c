#include <stdio.h>
/* Reverse a character string, reference CPL p 59 */
_reverse(s)
char *s;{
        int i, j;
        char c;
        i = 0;
        j = _strlen(s) - 1;
        while (i < j){
                c = s[i];
                s[i] = s[j];
                s[j] = c;
                i++;
                j--;
                }
        return(s);
        }
