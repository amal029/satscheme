;;; This is for the compiled case
(declare (uses sat) (uses parsedimacs))

(require-extension srfi-18)
(require-extension getopt-long)
(require-extension section-combinators)


(define grammar
  `((file "Name of the input file in DIMACS cnf format"
	  (single-char #\f)
	  (value #t)
	  (required #f))
    (solve "Solve the sat problem"
	  (single-char #\s)
	  (value #f)
	  (required #f))
    (time "Timeout for the solver in seconds [0 means never timeout, default:0]"
	  (single-char #\t)
	  (value #t)
	  (required #f))
    (help "Print this help message"
	  (single-char #\h))))

(define (myparse timeout-value solve fn)
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
      (dpll (time->seconds (current-time)) 
	    (string->number timeout-value) ss clauses)))))


(let* ((options (getopt-long (argv) grammar))
       (fn (alist-ref 'file options))
       (s (alist-ref 'solve options))
       (h (alist-ref 'help options))
       (t (alist-ref 'time options))
       (tv (if (equal? t #f) "0"
	       t)))
  (if (or (equal? h #t) (equal? fn #f))
      (display (usage grammar))
      (if (list? fn)
	  (map (left-section myparse tv s) fn)
	  (myparse tv s fn))))
