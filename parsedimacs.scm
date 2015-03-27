;;; Author: Avinash Malik
;;; Thu Mar 26 16:14:50 NZDT 2015
;;; TODO: Add more error checking by looking at "p" 

(declare (uses extras) (hide dimacs) (unit parsedimacs))
(require-extension s)
(require-extension section-combinators)

(define (dimacs p)
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
	(error 'dimacs "Problem specification incomplete" 'ERORR)))
     (else
      (letrec ((build-clauses
		(lambda (lls result)
		  (let-values (((x y) (span (lambda (v) (not (eq? v 0))) lls)))
		    (if (not (eq? (cdr y) '()))
			(build-clauses (cdr y) (cons x result))
			(values (cddr (s-split " " (car pline)))
				(cons x result)))))))
	(build-clauses lines '()))))))

(define (parse-dimacs file-name)
  (let-values (((pline clauses) (call-with-input-file file-name dimacs)))
    (letrec ((build-sat-set
	      (lambda (counter u ss)
		(if (eq? counter u) (alist-cons counter 'U  ss)
		    (build-sat-set (+ counter 1) u
				   (alist-cons counter 'U ss)))))
	     (fc (filter (compose not (left-section eq? #f)) clauses)))
      (values
       (build-sat-set 1 (string->number (car pline)) '())
       fc))))
