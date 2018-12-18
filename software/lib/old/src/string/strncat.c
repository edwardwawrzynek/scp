/*
 * Concatenate s2 on the end of s1.  S1's space must be large enough.
 * At most n characters are moved.
 * Return s1.
 */

strncat(s1, s2, n)
unsigned char *s1, *s2;
int n;
{
        unsigned char *os1;

        os1 = s1;
        while (*s1++)
                ;
        --s1;
        while (*s1++ = *s2++){
                if (--n < 0) {
                        *--s1 = '\0';
                        break;
                }}
        return(os1);

}

