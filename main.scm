;;; This is for the compiled case
(declare (uses parsedimacs))

(require-extension getopt-long)

(define grammar
  `((file "Name of the input file in DIMACS cnf format"
		  (single-char #\f)
		  (value #t)
		  (required #t))))

(define (myparse fn)
  (for-each (lambda (l)
			  (display l) (newline)) (parse-dimacs fn)))


(let* ((options (getopt-long (argv) grammar))
	   (fn (alist-ref 'file options)))
  (if (eq? fn #f)
	(usage)
	(if (list? fn)
	  (map myparse fn)
	  (myparse fn))))
