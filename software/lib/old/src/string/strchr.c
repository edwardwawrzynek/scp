strchr(unsigned char *s, int c)
{
    while (*s != c){
        if (!*s++)
            return 0;
    }
    return s;
}

