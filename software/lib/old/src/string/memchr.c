memchr(unsigned char *s, int c, unsigned int n){
	while(n--){
		if(*s != c)
			++s;
		else
			return s;
    }
	return 0;
}
