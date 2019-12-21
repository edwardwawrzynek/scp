/**
 * Runtime Division and Mod Support for SCP
 * Uses a binary long division algorithm. Very inefficient, but should work.
 * Edward Wawrzynek */

/* memcpy */
void __crtmemcpy(__reg("rb") char * dest, __reg("ra") char * src, __reg("rc") unsigned int count) {
	while (count--)
		*dest++ = *src++;
}

/* unsigned divide */
unsigned int __crtudiv(__reg("ra") unsigned int num, __reg("rc") unsigned int den){
    /* quotient and remainder */
    int q = 0, r = 0;

    for(int i = 15; i != -1; i--){
        r = r << 1;
        r |= ((num >> i) & 1);
        if(r >= den){
            r -= den;
            q |= (1 << i);
        }
    }

    return q;
}

/* unsigned mod */
unsigned int __crtumod(__reg("ra") unsigned int num, __reg("rc") unsigned int den){
    /* quotient and remainder */
    int q = 0, r = 0;

    for(int i = 15; i != -1; i--){
        r = r << 1;
        r |= ((num >> i) & 1);
        if(r >= den){
            r -= den;
            q |= (1 << i);
        }
    }

    return r;
}

/* signed divide - calls __crtudiv */
signed int __crtsdiv(__reg("ra") unsigned int num, __reg("rc") unsigned int den){
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

/* signed mod - calls __crtumod */
signed int __crtsmod(__reg("ra") unsigned int num, __reg("rc") unsigned int den){
    char sign = 1;

    if(num < 0){
        sign = -sign;
        num = -num;
    }
    if(den < 0){
        sign = -sign;
        den = -den;
    }

    return sign * __crtumod(num, den);
}