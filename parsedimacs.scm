;;; Author: Avinash Malik
;;; Thu Mar 26 16:14:50 NZDT 2015
;;; TODO: Add more error checking by looking at "p" 

(declare (hide dimacs) (unit parsedimacs))
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
	(display "Problem specification incomplete")
	(newline)
	(abort 'exn)))
     (else
      (letrec ((build-clauses
		(lambda (lls result)
		  (let-values (((x y) (span (lambda (v) (not (eq? v 0))) lls)))
		    (if (not (eq? (cdr y) '()))
			(build-clauses (cdr y) (cons x result))
			(cons x result))))))
	(build-clauses lines '()))))))

(define (parse-dimacs file-name)
  (call-with-input-file file-name dimacs))
