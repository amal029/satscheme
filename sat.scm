(declare (hide map-literal->clause) (unit sat) (uses parsedimacs))
(require-extension section-combinators)

(define (map-literal->clause literals clauses)
  (letrec ((build-map
	    (lambda (counter u ss)
	      (if (eq? counter u)
		  (alist-cons counter (get-clause-list counter clauses) ss)
		  (build-map (+ counter 1)
			     (alist-cons counter
					 (get-clause-list counter clauses)
					 ss)))))
	   (get-clause-list
	    (lambda (counter clauses)
	      )))
    (build-map 0 (length literals) '())))
