Banner
------

Original source:

http://www.atariarchives.org/basicgames/showpage.php?page=10

This program prints the input message, rotated 90 degrees clockwise,
in a 7x9 font where the "pixels" are blocks of a user-defined size.
It's clearly a relic of the days when terminals sent their output to a
continuous-feed printer rather than a video display, as witnessed by
the "SET PAGE" prompt (where the user would manually advance the paper
to a page break and then press Return/Enter to start).

Each of the characters is defined by an array of 7 integers, each
integer representing a "row" of the output rotated character. The
integers are the usual bitmap representation of the pixels in that
row, plus one. This allows the BASIC program to descend through the
powers of two starting with 256 and see if a bit is set if the current
value is greater that or equal to that power of two (subtracting the
current power of two if it is). I kept the same data values, but
instead just subtract one from each value and use bitwise AND
operations, which BASIC lacks.

I corrected two bugs in the original program. First, the prompt
"CENTERED" is spelled "CENTEED" originally. Second, the number "6"'s
data values produce a mirror image version of the character. Also, I
commented out the final operation that prints 75 blank lines (effectively
a page feed for a printer-based terminal.

Functionality to print banners like this, in many different typefaces,
was part of Brøderbund Software's program "The Print Shop" for the
Apple II family, and those dot-matrix printed banners were a mainstay
of American elementary school classrooms in the '80s.
