/**
 * Runtime Division Support for SCP
 * Uses a binary long division algorithm. Very inefficient, but should work.
 * Edward Wawrzynek */

void hex(unsigned int i);
/* unsigned divide */
unsigned int __crtudiv(unsigned int num, unsigned int den){
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
/*
if D = 0 then error(DivisionByZeroException) end
Q := 0                  -- Initialize quotient and remainder to zero
R := 0
for i := n − 1 .. 0 do  -- Where n is number of bits in N
  R := R << 1           -- Left-shift R by 1 bit
  R(0) := N(i)          -- Set the least-significant bit of R equal to bit i of the numerator
  if R ≥ D then
    R := R − D
    Q(i) := 1
  end
end
*/

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