# satscheme
A SAT solver written in scheme

# Requirements

- Chicken scheme implementation
- Following eggs from chicken-scheme:
  * matchable
  * combinators
  * s

# Running the sat solver ($ is the user prompt)
```
$> make clean && make
$> ./main -f <file-name> -s
```
  * The file should be in the DIMACS format with space (not tab separation)
  * With the `-s` switch, the program prints out the result: the given
    formula is satisfiable or not and the value of each proposition as
    an association list
  * Without the `-s` switch only the parsed clauses and the association
    list of uninitialized (`'U`) propositions is printed out.
