#include <half.h>

//"Un-pack" a half into sign, exponent, and significand - return significand, and set pointers to sign and exponent
_half_unpack(half val, unsigned int *sign, int *exponent){
	*sign = (val & 0b1000000000000000) >> 15;
	*exponent = ((val & 0b0111110000000000) >> 10) - 15;
	//clear top 6 bits
	val = val & 0b0000001111111111;
	//don't add implicit 1 if both the exponent and significand are zero 
	if((*exponent)+15 || val){
		val |= 0b0000010000000000;
	}
	return val;
}

//"Pack" a half from a sign, exponent, and significand
_half_pack(unsigned int sign, unsigned int exponent, unsigned int significand){
	unsigned int res;
	res = (sign<<15) | (((exponent+15) << 10)&0b0111110000000000) | (significand&0b0000001111111111);
	return res;
}

//Normalize a significand and exponent
_half_normalize(unsigned int * exponent, int *significand){
	//Don't try to normalize if the significand is zero
	if(*significand){
		//Shift until leading 1 is in right place
		while(!(*significand & 0b1000000000000000)){
			*significand <<= 1;
			--(*exponent);
		}
		*significand >>= 5;
		*exponent += 5;
		return 1;
	}
	//set exponent to appropriate zero
	*exponent = -15;
	return 0;
}

//Add two halfs
hadd(half v0, half v1){
	int expDif;
	unsigned int sign0, sign1;
	int exp0, exp1, sig0, sig1;
	//Unpack
	sig0 = _half_unpack(v0, &sign0, &exp0);
	sig1 = _half_unpack(v1, &sign1, &exp1);
	//Shift sigs so that they align with the same exponent
	expDif = exp0 - exp1;
	if(expDif > 0){
		//exp0 is greater, so 1 is left shifted
		sig1 >>= expDif;
		exp1 += expDif;
	}
	else{
		//exp1 is greater, so 0 is left shifted
		sig0 >>= -expDif;
		exp0 += -expDif;
	}
	//Handle signs
	if(sign0){
		sig0 = -sig0;
	}
	if(sign1){
		sig1 = -sig1;
	}
	//Sum
	sig0 = sig0 + sig1;
	sign0 = 0;
	if(sig0 < 0){
		sig0 = -sig0;
		sign0 = 1;
	}
	_half_normalize(&exp0, &sig0);
	return _half_pack(sign0, exp0, sig0);
}

//Subtract two halfs
hsub(half v0, half v1){
	//FLip sign on v1
	v1 ^= 0b1000000000000000;
	return hadd(v0, v1);
}

//multiply two halfs
hmul(half v0, half v1){
	unsigned int sign0, sign1;
	int exp0, exp1, sig0, sig1;
	//Unpack, and shift values right 3 so as to not overflow on multiplication
	sig0 = _half_unpack(v0, &sign0, &exp0) >> 3;
	sig1 = _half_unpack(v1, &sign1, &exp1) >> 3;
	exp0 += 3;
	exp1 += 3;
	//get sign for final result
	sign0 = sign0 ^ sign1;
	//multiply and add exponents
	sig0 = sig0 * sig1;
	//10 is subtracted because the decimal place is at 10th number 
	exp0 = exp0 + exp1 - 10;
	_half_normalize(&exp0, &sig0);
	return _half_pack(sign0, exp0, sig0);
}

//divide two halfs
hdiv(half v0, half v1){
	unsigned int sign0, sign1, sig0, sig1;
	int exp0, exp1;
	//Unpack, and shift values right 3 so as to not overflow on multiplication
	sig0 = _half_unpack(v0, &sign0, &exp0) << 5;
	sig1 = _half_unpack(v1, &sign1, &exp1) >> 3;
	exp0 -= 5;
	exp1 += 3;
	//get sign for final result
	sign0 = sign0 ^ sign1;
	//multiply and add exponents
	sig0 = sig0 / sig1;
	//10 is subtracted because the decimal place is at 10th number 
	exp0 = exp0 - exp1 + 10;
	_half_normalize(&exp0, &sig0);
	return _half_pack(sign0, exp0, sig0);
}

//compare two halfs, returning 0 if they are equal, (<0) is v0 < v1, and (>0) if v1 > v0
hcmp(half v0, half v1){
	unsigned int sign0, sign1, sig0, sig1;
	int exp0, exp1;
	if(v0 == v1){
		return 0;
	}
	//Unpack
	sig0 = _half_unpack(v0, &sign0, &exp0);
	sig1 = _half_unpack(v1, &sign1, &exp1);
	//Check signs for a difference
	if(sign0 ^ sign1){
		return sign1 - sign0;
	}
	//set sign0 equal to 1 if both positive, -1 if both negative
	sign0 = sign0 ? -1 : 1;
	//calculate exponent difference
	exp0 = exp0 - exp1;
	if(exp0){return exp0*sign0;}
	//They have the same exponent, so return significand difference
	return (sig0 - sig1)*sign0;
}
