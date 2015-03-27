;;; This is for the compiled case
(declare (uses sat) (uses parsedimacs))

(require-extension getopt-long)
(require-extension section-combinators)

(define grammar
  `((file "Name of the input file in DIMACS cnf format"
	  (single-char #\f)
	  (value #t)
	  (required #t))
    (solve "Solve the sat problem"
	  (single-char #\s)
	  (value #f)
	  (required #f))))

(define (myparse solve fn)
  (let-values (((ss clauses) (parse-dimacs fn)))
    (cond
     ((not solve)
      (for-each (lambda (l)
		  (display l)
		  (newline))
		ss)
      (for-each (lambda (l)
		  (display l)
		  (newline))
		clauses))
     (else
      (dpll ss clauses)))))


(let* ((options (getopt-long (argv) grammar))
       (fn (alist-ref 'file options))
       (s (alist-ref 'solve options)))
  (if (eq? fn #f)
      (usage)
      (if (list? fn)
	  (map (left-section myparse s) fn)
	  (myparse s fn))))
