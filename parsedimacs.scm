;;; DIMACS file format is as follows

;;; Line starting with character #c is a comment line and should be
;;; ignored.

;;; Line starting with #p should have 4 space separated elements.

;;; p cnf <num-of-variables> <num-of-clauses>

;;; Then following lines should have only comments or numbers.

;;; A negative number means not (remember).
