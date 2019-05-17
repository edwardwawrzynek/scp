#! /bin/sh

#SH Test program


#loops

(^ while (< count 5) <
	# single line expressions don't need parens
	+= count 1
	# variable interpolation
	touch (+ count ".txt")
	# the output of cat is passed to to = func
	= cont (cat file.txt)
	# here the output of cat is passed to stdin, since we are in while's code block
	cat file.txt
)


(hello <set)}

# pipes (parens are optional)
(cat file.txt | (wc -l)) | less

# output of shell commands can be passed in pipes blocks till + fun is done
+ count 5 | tee out.txt

# redirection
cat test.c | cc > out.txt

# even with shell commands
(* "hello world" 5) > out.txt

#finding return values requires (^ ) syntax (by default, passing comands to other commandsdoes substitution)
(if ( (^ mkdir test) ) (
	echo "failure making directory"
))

#>
block comment
this is a lot of text code
it doesnt really do anything, but shows some syntax
#<


#can be made clearer as:
(if (^ mkdir test) (
	echo "Failed again"
))

# subshell syntax (plus piping, (for is still blocking) (interpreter is forked, then procs again fork off, not just proc fork)
<(for (= i 0) (< i 500) (++ i) (
	echo (* i i)
)) | less>

# background process (in subshell)
(& ls -l)
& ls -l

(& for (= i 0) (< i 5) (++ i) (
	echo i
) )

<& ls -l | wc -l >

#single line syntax can be extended over multiple lines if we are still in sub function:
if (> a 5) {
	printf "a gt 5"
} else {
	printf "a lt 5"
}

# however, this doesn't work, as newline is interpreted as eol (it should be put in parens)
if (> a 5)
{
	printf "a gt 5"
}

#functions
(fn min (a b) (
	(if (a < b) (
		return a
	) else (
		return b
	))
))

#Technical details
#Command substitution requires a pipe to interpreter, which is read into string and passed as arg
#Shell func piping requires writing results into pipe (background shell commands are just in subshell)
#TODO: brackets for func bodies (makes command stdout redirection clearer)
#TODO: arrays, classes?
