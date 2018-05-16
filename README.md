Fork of tinyscheme http://tinyscheme.sourceforge.net/ by Dimitrios Souflis , Kevin Cozens and Jonathan S. Shapiro 

## Extended functions

`(rand) => 0.89789` create a random float bewteen 0.0 and 1.0. 

`(tolower "ABC\n") => "abc\n" ` converts a string to lowercase

`(toupper "abc\n") => "ABC\n" ` converts a string to uppercase

`(trim " ABC  ") => "ABC" ` remove leading/trailing spaces

`(regcomp "[A-Z]") ` ; `(regcomp "[A-Z]" "i") ` compiles regular expression. Second optional argument is a modifier: 'i' for ignore case.

`(string-match "aatgc" (regcomp "[A-Z]+" "i")) => #t ` test the whole string for a regular expression. if the second argument is a string, we use a simple string comparaion.
