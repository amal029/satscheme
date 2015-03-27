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
	      (letrec
		  ((get (lambda (c ll res)
			  (if (null? ll) res
			      (if (any (lambda (v)
					 (eq? (abs v) counter))
				       (list-ref ll c))
				  (get (+ c 1) ll (cons c res))
				  ;; else
				  (get (+ c 1) ll res)
				  )))))
		(get 0 clauses '())))))
    (build-map 1 (length literals) '())))

;;; The "literals" a-list holds literal -> (or #t #f '())
;;; The main "sat" procedure
;;; TODO: implement the functions listed in here!!
(define (sat literals clauses)
  (letrec ((dpll
	    (lambda (literals clauses)
	      (cond
	       ((all-clauses-are-true literals clauses) #t) ;satisfied cnf
	       ((some-clause-is-false literals clauses) #f) ;unsatisfied cnf
	       (else 
		;; Unit literal propogation
		(let* ((unit-clauses (get-unit-clauses clauses))
		       (clauses (foldl (left-section unit-propogate clauses) '() unit-clauses))
		       ;; TODO: This choice is completely, random, but can be made better!
		       (some-unassigned-proposition (find (lambda (x) (eq? 'U (cdr x))) literals)))
		  ;; resolution operation
		  (if (not (eq? some-unassigned-proposition #f))
		      (if (dpll
			   (alist-update (car some-unassigned-proposition) #t literals) clauses) #t
			   (dpll
			    (alist-update (car some-unassigned-proposition) #f literals) clauses))
		      #t)))))))
    (dpll literals clauses))) 
