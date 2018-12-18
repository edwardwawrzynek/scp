/**
 * Runtime Division Support for SCP
 * Uses a binary long division algorithm. Very inefficient, but should work.
 * Edward Wawrzynek */

/* unsigned divide */
unsigned int __crtudiv(unsigned int num, unsigned int den){
    /* quotient and remainder */
    int q = 0, r = 0;

    for(int i = num - 1; i != -1; i--){
        r <<= 1;
        r |= ((num >> i) & 1);
        if(r >= den){
            r -= den;
            q |= (1 << i);
        }
    }

    return q;
}

/* signed divide - calls __crtudiv */
signed int __crtsdiv(int num, int den){
    char sign = 1;

    if(num < 0){
        sign = -sign;
        num = -num;
    }
    if(den < 0){
        sign = -sign;
        den = -den;
    }

    return sign * __crtudiv(num, den);
}