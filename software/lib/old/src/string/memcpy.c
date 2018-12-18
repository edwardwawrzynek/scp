memcpy(unsigned char *dest, unsigned char *src, unsigned int n)
{
    unsigned char *dp;
    dp = dest;
    while (n--){
        *dp++ = *src++;
    }
    return dest;
}

