/*      File io.c: 2.1 (83/03/20,16:02:07) */
/*% cc -O -c %
 *
 */

#include <stdio.h>
#include <string.h>
#include "defs.h"
#include "data.h"

/*
 *      open input file
 */
openin (p) char *p;
{
        strcpy(fname, p);
        fixname (fname);
        if (!checkname (fname))
                return (NO);
        if ((input = fopen (fname, "r")) == NULL) {
                pl ("Open failure on file:\n");
                pl (fname);
                return (NO);
        }
        kill ();
        return (YES);

}

/*
 *      open output file
 */
openout ()
{
        outfname (fname);
        if ((output = fopen (fname, "w")) == NULL) {
                pl ("Open failure on file:");
                pl(fname);
                return (NO);
        }
        kill ();
        return (YES);

}

// open .incl file

openincl ()
{
	inclfname(fname);
	if ((inclf = fopen (fname, "w")) == NULL) {
                pl ("Open failure on .incl - run scc without -i to not generate .incl");
                return (NO);
        }
	kill ();
	return (YES);
}

// change input filename to .incl filename

inclfname (s)
char    *s;
{
        while (*s)
                s++;
        *--s = 'i';
				*++s = 'n';
				*++s = 'c';
				*++s = 'l';
                *++s = '\0';

}

/*
 *      change input filename to output filename
 */
outfname (s)
char    *s;
{
        while (*s)
                s++;
        *--s = 's';
        *++s = '\0';

}

/**
 * remove NL from filenames
 */
fixname (s)
char    *s;
{
        while (*s && *s++ != LF);
        if (!*s) return;
        *(--s) = 0;

}

/**
 * check that filename is "*.c"
 */
checkname (s)
char    *s;
{
        while (*s)
                s++;
        if (*--s != 'c')
                return (NO);
        if (*--s != '.')
                return (NO);
        return (YES);

}

kill () {
        lptr = 0;
        line[lptr] = 0;
}

//if using right to left, read multi line function calls into one line
readline () {
        int     k;
        int prev_k;
        FILE    *unit;
        prev_k = 0;
#ifdef CALL_RIGHT_TO_LEFT
        char esc_s, esc_c;
        unsigned int semi_depth;
        esc_c = 0;
        esc_s = 0;
        semi_depth = 0;
#endif
        FOREVER {
                if (feof (input))
                        return;
                if ((unit = input2) == NULL)
                        unit = input;
                kill ();
                while ((k = fgetc (unit)) != EOF) {
#ifdef CALL_RIGHT_TO_LEFT
                        if(k == '"'){
                                esc_s = !esc_s;
                        } else if (k == '\''){
                                esc_c = !esc_c;
                        } else if (k == '(' && ((!esc_s) && (!esc_c))){
                                semi_depth++;
                        } else if (k == ')' && ((!esc_s) && (!esc_c))){
                                semi_depth--;
                        }
#endif
                        if ((k == CR) || (k == LF) | (lptr >= LINEMAX)){
#ifdef CALL_RIGHT_TO_LEFT
                                if(!semi_depth && prev_k != '\\'){
                                        break;
                                }            
#endif
#ifndef CALL_RIGHT_TO_LEFT
                                if(prev_k != '\\'){
                                        break;
                                }
#endif
                        } else {
                                line[lptr++] = k;
                        }
                        prev_k = k;
                }
                line[lptr] = 0;
                if (k <= 0)
                        if (input2 != NULL) {
                                input2 = inclstk[--inclsp];
                                fclose (unit);
                        }
                if (lptr) {
                        if ((ctext) & (cmode)) {
                                gen_comment ();
                                output_string (line);
                                newline ();
                        }
                        lptr = 0;
                        return;
                }
        }
}

inbyte () {
        while (ch () == 0) {
                if (feof (input))
                        return (0);
                preprocess ();
        }
        return (gch ());
}

inchar () {
        if (ch () == 0)
                readline ();
        if (feof (input))
                return (0);
        return (gch ());
}

/**
 * gets current char from input line and moves to the next one
 * @return current char
 */
gch () {
        if (ch () == 0)
                return (0);
        else
                return (line[lptr++] & 127);
}

/**
 * returns next char
 * @return next char
 */
nch () {
        if (ch () == 0)
                return (0);
        else
                return (line[lptr + 1] & 127);
}

/**
 * returns current char
 * @return current char
 */
ch () {
        return (line[lptr] & 127);
}

/*
 *      print a carriage return and a string only to console
 *
 */
pl (str)
char    *str;
{
        int     k;

        k = 0;
#if __CYGWIN__ == 1
        putchar (CR);
#endif
        putchar (LF);
        while (str[k])
                putchar (str[k++]);
}

