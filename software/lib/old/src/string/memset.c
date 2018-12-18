memset(char *s, int c, unsigned int n)
{
    unsigned char* p;
    p=s;
    while(n--){
        *p++ = c;
    }
    return s;
}

