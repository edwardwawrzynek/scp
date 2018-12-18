/* string library for scp os */

/* str* ops */

strchr(unsigned char *s, int c)
{
    while (*s != c){
        if (!*s++){
            return 0;
        }
    }
    return s;
}

/*
 * Compare strings:  s1>s2: >0  s1==s2: 0  s1<s2: <0
 */

strcmp(unsigned char *s1, unsigned char *s2)
{
    while (*s1 == *s2++){
        if (*s1++=='\0'){
            return 0;
        }
    }
    return(*s1 - *--s2);
}

strcpy(unsigned char *s1, unsigned char *s2)
{
        unsigned char *os1;
        os1 = s1;
        while (*s1++ = *s2++);
        return os1;
}

/* mem* operations */

memcmp(unsigned char* s1, unsigned char* s2, unsigned int n)
{
    while(n--){
        if( *s1 != *s2 ){
            return *s1 - *s2;
        }
        ++s1,++s2;
    }
    return 0;
}
memcpy(unsigned char *dest, unsigned char *src, unsigned int n)
{
    unsigned char *dp;
    dp = dest;
    while (n--){
        *dp++ = *src++;
    }
    return dest;
}
memset(char *s, unsigned char c, unsigned int n)
{
    unsigned char* p;
    p=s;
    while(n--){
        *(p++) = c;
    }
    return s;
}

