memcmp(unsigned char* s1, unsigned char* s2, unsigned int n)
{
    while(n--){
        if( *s1 != *s2 ){
            return *s1 - *s2;
        }
        s1++,s2++;
    }
    return 0;
}
