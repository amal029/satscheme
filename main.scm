;;; This is for the compiled case
;; (declare (uses parsedimacs))
(include "parsedimacs")

(require-extension args)
(require-extension srfi-37)

(define opts
  (list 
   (args:make-option (f file) (required: "NAME")   "parse file NAME")
   (args:make-option (v V version) #:none "Display version"
		     (print "main $Revision: 0.1 $")
		     (exit))
   (args:make-option (h help)      #:none     "Display this text"
		     (usage))))

(define (parse fn)
  (for-each (lambda (l)
	      (display l) (newline)) (parse-dimacs fn)))

(define (usage)
  (with-output-to-port (current-error-port)
    (lambda ()
      (print "Usage: " (car (argv)) " [options...] [files...]")
      (newline)
      (print (args:usage opts))
      (print "Report bugs to avinash.malik at auckland.ac.nz")))
  (exit 1))

;;; This is for the compiled case
;;; FIXME: getting seg-faults from the chicken libraray

;; (receive (options operands)
;;     (args:parse (command-line-arguments) opts)
;;   (parse (alist-ref 'f options)))

;; This is for the interpreter case!
(define (main args)
  (if (not (eq? args '()))
      (parse (car args))
      (usage)))
