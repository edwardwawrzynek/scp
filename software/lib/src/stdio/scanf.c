/* modified version of mirror.fsf.org/pmon2000/2.x/src/lib/libc/scanf.c */
#include <stdio.h>
#include <stdarg.h>
#include <string.h>
#include <ctype.h>
#include <stdlib.h>

#define MAXLN 256

#define ISSPACE " \t\n\r\f\v"

/*
 *  _atob(vp,p,base)
 */
static int

_atob (uint16_t *vp, char *p, int base)
{
	uint16_t value, v1, v2;

	char *q, tmp[20];
	int digit;

	if (p[0] == '0' && (p[1] == 'x' || p[1] == 'X')) {
		base = 16;
		p += 2;
	}

	if (base == 16 && (q = strchr (p, '.')) != 0) {
		if (q - p > sizeof(tmp) - 1)
			return (0);

		strncpy (tmp, p, q - p);
		tmp[q - p] = '\0';
		if (!_atob (&v1, tmp, 16))
			return (0);

		q++;
		if (strchr (q, '.'))
			return (0);

		if (!_atob (&v2, q, 16))
			return (0);
		*vp = (v1 << 16) + v2;
		return (1);
	}

	value = *vp = 0;
	for (; *p; p++) {
		if (*p >= '0' && *p <= '9')
			digit = *p - '0';
		else if (*p >= 'a' && *p <= 'f')
			digit = *p - 'a' + 10;
		else if (*p >= 'A' && *p <= 'F')
			digit = *p - 'A' + 10;
		else
			return (0);

		if (digit >= base)
			return (0);
		value *= base;
		value += digit;
	}
	*vp = value;
	return (1);
}

/*
 *  atob(vp,p,base)
 *      converts p to binary result in vp, rtn 1 on success
 */
static int
atob(uint16_t *vp, char *p, int base)
{
    uint16_t v;
	if (_atob (&v, p, base)) {
		*vp = v;
		return (1);
	}
	return (0);
}


/*
 *  scanf(fmt,va_alist)
 */
int scanf (const char *fmt, ...)
{
    int             count;
    va_list ap;

    va_start (ap, fmt);
    count = vfscanf (stdin, fmt, ap);
    va_end (ap);
    return (count);
}

/*
 *  fscanf(fp,fmt,va_alist)
 */
int fscanf (FILE *fp, const char *fmt, ...)
{
    int             count;
    va_list ap;

    va_start (ap, fmt);
    count = vfscanf (fp, fmt, ap);
    va_end (ap);
    return (count);
}

/*
 *  sscanf(buf,fmt,va_alist)
 */
int sscanf (const char *buf, const char *fmt, ...)
{
    int             count;
    va_list ap;

    va_start (ap, fmt);
    count = vsscanf (buf, fmt, ap);
    va_end (ap);
    return (count);
}

/*
 *  vfscanf(fp,fmt,ap)
 */
int vfscanf (FILE *fp, const char *fmt, va_list ap)
{
    int             count;
    char            buf[MAXLN + 1];

    if (fgets (buf, MAXLN, fp) == 0)
	return (-1);
    count = vsscanf (buf, fmt, ap);
    return (count);
}


/*
 *  vsscanf(buf,fmt,ap)
 */
int vsscanf (const char *buf, const char *s, va_list ap)
{
    int             count, noassign, width, base, lflag;
    const char     *tc;
    char           *t, tmp[MAXLN];

    count = noassign = width = lflag = 0;
    while (*s && *buf) {
	while (isspace (*s))
	    s++;
	if (*s == '%') {
	    s++;
	    for (; *s; s++) {
		if (strchr ("dibouxcsefg%", *s))
		    break;
		if (*s == '*')
		    noassign = 1;
		else if (*s == 'l' || *s == 'L')
		    lflag = 1;
		else if (*s >= '1' && *s <= '9') {
		    for (tc = s; isdigit (*s); s++);
		    strncpy (tmp, tc, s - tc);
		    tmp[s - tc] = '\0';
		    atob (&width, tmp, 10);
		    s--;
		}
	    }
	    if (*s == 's') {
		while (isspace (*buf))
		    buf++;
		if (!width)
		    width = strcspn (buf, ISSPACE);
		if (!noassign) {
		    strncpy (t = va_arg (ap, char *), buf, width);
		    t[width] = '\0';
		}
		buf += width;
	    } else if (*s == 'c') {
		if (!width)
		    width = 1;
		if (!noassign) {
		    strncpy (t = va_arg (ap, char *), buf, width);
		    t[width] = '\0';
		}
		buf += width;
	    } else if (strchr ("dobxu", *s)) {
		while (isspace (*buf))
		    buf++;
		if (*s == 'd' || *s == 'u')
		    base = 10;
		else if (*s == 'x')
		    base = 16;
		else if (*s == 'o')
		    base = 8;
		else if (*s == 'b')
		    base = 2;
		if (!width) {
		    if (isspace (*(s + 1)) || *(s + 1) == 0)
			width = strcspn (buf, ISSPACE);
		    else
			width = strchr (buf, *(s + 1)) - buf;
		}
		strncpy (tmp, buf, width);
		tmp[width] = '\0';
		buf += width;
		if (!noassign)
		    atob (va_arg (ap, uint16_t *), tmp, base);
	    }
	    if (!noassign)
		count++;
	    width = noassign = lflag = 0;
	    s++;
	} else {
	    while (isspace (*buf))
		buf++;
	    if (*s != *buf)
		break;
	    else
		s++, buf++;
	}
    }
    return (count);
}
