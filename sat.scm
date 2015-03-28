(declare (hide all-clauses-are-true) (hide solve-clause)
	 (hide some-clause-is-false) (hide get-unit-clause)
	 (unit sat) (uses parsedimacs))
(require-extension section-combinators)
(require-extension matchable)

(define (all-clauses-are-true literals clauses)
  (not (any (lambda (x) (eqv? 'U (cdr x))) literals)))

(define (some-clause-is-false literals clauses)
  (if (any (lambda (x) (eqv? 'U (cdr x))) literals) #f
      (not (foldl and #t (map (right-section solve-clause literals) clauses)))))

(define solve-clause
  (match-lambda*
    ((() _) #f)
    (((h . t) l)
     (let ((hv (alist-ref (abs h) l)))
       (or (if (negative? h) (not hv)
	       hv) (solve-clause t l))))))

(define (get-unit-clause literals clauses)
  (find
   (lambda (clause)
     (if (and (not (null? clause)) (list? clause))
	 (cond
	  ((and (equal? (length clause) 1)
		(equal? (alist-ref (abs (car clause)) literals) 'U)) #t)
	  (else
	   (let-values (((us nus)
			 (partition
			  (lambda (x) (equal? (alist-ref (abs x) literals) 'U)) clause)))
	     (if (equal? (length us) 1) (not (solve-clause nus literals))
		 #f))))
	 (error "Clause not in form of a list (or null): " clause))) clauses))

;;; The main "sat" procedure
(define (dpll literals clauses)
  (cond
   ((some-clause-is-false literals clauses) #f) ;unsatisfied cnf
   ((all-clauses-are-true literals clauses)
    (display "PROBLEM SATISFIED!!")
    (newline)
    (display literals)
    (newline)
    #t) ;satisfied cnf
   (else 
    (let* ((unit-clause (get-unit-clause literals clauses))
	   (unit-literal (if (not (equal? #f unit-clause))
			     (find (lambda (x)
				     (equal? (alist-ref (abs x) literals) 'U))
				   unit-clause)
			     #f)))
      (cond
       ((and (not (equal? #f unit-literal)) (negative? unit-literal))
	(let-values (((_ updated-clauses)
		      (partition (lambda (x)
				   (any (lambda (y) (equal? unit-literal y)) x)) clauses)))
	  (dpll (alist-update (abs unit-literal) #f literals) updated-clauses)))
       ((and (not (equal? #f unit-literal)) (positive? unit-literal))
	(let-values (((_ updated-clauses)
		      (partition (lambda (x)
				   (any (lambda (y) (equal? unit-literal y)) x)) clauses)))
	  (dpll (alist-update unit-literal #t literals) updated-clauses)))
       (else
	(let* ((unassigned-propositions (filter (lambda (x) (equal? 'U (cdr x))) literals))
	       (jw-rule (lambda (literal)
			  (let* ((clist (filter
					 (lambda (x)
					   (any (lambda (y)
						  (equal? (car literal) y)) x)) clauses))
				 (vlist (map (lambda (x) (expt 2 (- (length x)))) clist)))
			    (foldl + 0 vlist))))
	       (jw-rule-values (map jw-rule unassigned-propositions))
	       (zipped-values (zip unassigned-propositions jw-rule-values))
	       (val (sort zipped-values (lambda (x y)
					  (< (car (cdr x)) (car (cdr y))))))
	       (some-unassigned-proposition (if (null? val) #f
						(car (last val)))))
	  (if (not (equal? some-unassigned-proposition #f))
	      (if (dpll
		   (alist-update (car some-unassigned-proposition) #f literals) clauses) #t
		   (dpll
		    (alist-update (car some-unassigned-proposition) #t literals) clauses))
	      #t))))))))
