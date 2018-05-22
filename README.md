Fork of tinyscheme http://tinyscheme.sourceforge.net/ by Dimitrios Souflis , Kevin Cozens and Jonathan S. Shapiro 


## SAM function

`(sam-tid b)` => returns the reference ID of the read `b`.

`(sam-contig b)` => returns the reference name the read `b` or `NIL`

`(sam-read-name b)` => returns the name the read `b`

`(sam-has-cigar b)` => returns `#t` if read is mapped and has a cigar 

`(sam-cigar-string b)` => returns the cigar string or NIL if it is not mapped.

`(sam-flag b)` => returns the SAM flag of the read

`(sam-mapq b)` => returns the MAPQ of the read

`(sam-read-seq)` => returns the read sequence

`(sam-read-qual)` => returns the read base qualities

`(sam-has-read-seq)` => returns true if the read has a sequence


## Extended functions

`(rand) => 0.89789` create a random float bewteen 0.0 and 1.0. 

`(tolower "ABC\n") => "abc\n" ` converts a string to lowercase

`(toupper "abc\n") => "ABC\n" ` converts a string to uppercase

`(trim " ABC  ") => "ABC" ` remove leading/trailing spaces

`(string-split "A B C " " ") => #(A B C) ` split a string using the delimiter (2nd arg). return value is a vector. trailing delimiters are skipped.

`(normalize-space "  A    B \n C \n\n") = > "A B C" ` collapses whitespace in a string.
