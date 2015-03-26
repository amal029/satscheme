;;; DIMACS file format is as follows

;;; Line starting with character #c is a comment line and should be
;;; ignored.

;;; Line starting with #p should have 4 space separated elements.

;;; p cnf <num-of-variables> <num-of-clauses>

;;; Then following lines should have only comments or numbers.

;;; A negative number means not (remember).

(require-extension s)
(require-extension section-combinators)

(define (parse-dimacs p)
  (let*
      ((lines (filter
	       (lambda (l)
		 (not (or (s-starts-with? "c" l) (eq? l '())))) (read-lines p)))
       (pline (filter
	       (lambda (l)
		 (s-starts-with? "p" l)) lines))
       (lines (filter
	       (lambda (l)
		 (not (s-starts-with? "p" l))) lines))
       (lines (map string->number
		   (flatten (map (left-section s-split " ") lines)))))
    (cond
     ((eq? pline '())
      (begin
	(display "Problem specification incomplete")
	(newline)
	(abort 'exn)))
     (else
      (letrec ((build-clauses
		(lambda (lls result)
		  (let-values (((x y) (span (lambda (v) (not (eq? v 0))) lls)))
		    (let ((y1 (cdr y)))
		      (if (not (eq? y1 '()))
			  (build-clauses y1 (cons x result))
			  result))))))
	(build-clauses lines '()))))))

(define (main file-name)
  (call-with-input-file file-name parse-dimacs))
