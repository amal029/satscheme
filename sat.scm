(declare (hide all-clauses-are-true) (hide solve-clause)
	 (hide some-clause-is-false) (hide get-unit-clause)
	 (unit sat) (uses parsedimacs))
(require-extension section-combinators)
(require-extension matchable)

(define (all-clauses-are-true literals)
  (not (any (lambda (x) (eq? 'U (cdr x))) literals)))

(define (some-clause-is-false literals clauses)
  (if (any (lambda (x) (eq? 'U (cdr x))) literals) #f
      (begin
	(not (foldl and #t (map (right-section solve-clause literals) clauses))))))

(define solve-clause
  (match-lambda*
    ((() _) #t)
    (((h . t) l)
     (let ((hv (alist-ref (abs h) l)))
       (or (if (negative? h) (not hv)
	       hv) (solve-clause t l))))))

(define (get-unit-clause literals clauses)
  (find
   (lambda (clause)
     (if (and (not (null? clause)) (list? clause))
	 (cond
	  ((and (eq? (length clause) 1)
		(eq? (alist-ref (abs (car clause)) literals) 'U)) #t)
	  (else
	   (let-values (((us nus)
			 (partition
			  (lambda (x) (eq? (alist-ref (abs x) literals) 'U)) clause)))
	     (if (eq? (length us) 1) (not (solve-clause nus literals))
		 #f))))
	 (error "Clause not in form of a list (or null): " clause))) clauses))

;;; The main "sat" procedure
(define (dpll literals clauses)
  (cond
   ((some-clause-is-false literals clauses) #f) ;unsatisfied cnf
   ((all-clauses-are-true literals)
    (display "PROBLEM SATISFIED!!")
    (newline)
    (display literals)
    (newline)
    #t) ;satisfied cnf
   (else 
    (let* ((unit-clause (get-unit-clause literals clauses))
	   (unit-literal (if (not (eq? #f unit-clause))
			     (find (lambda (x)
				     (eq? (alist-ref (abs x) literals) 'U))
				   unit-clause)
			     #f)))
      (cond
       ((and (not (eq? #f unit-literal)) (negative? unit-literal))
	(dpll (alist-update (abs unit-literal) #f literals) clauses))
       ((and (not (eq? #f unit-literal)) (positive? unit-literal))
	(dpll (alist-update unit-literal #t literals) clauses))
       (else
	(let ((some-unassigned-proposition (find (lambda (x) (eq? 'U (cdr x))) literals)))
	  (if (not (eq? some-unassigned-proposition #f))
	      (if (dpll
		   (alist-update (car some-unassigned-proposition) #f literals) clauses) #t
		   (dpll
		    (alist-update (car some-unassigned-proposition) #t literals) clauses))
	      #t))))))))
