(in-package :cl-user)
(defpackage nutelliweb.web
  (:use :cl
        :caveman2
        :nutelliweb.config
        :nutelliweb.view
        :nutelliweb.db
        :datafly
        :sxql)
  (:export :*web*))
(in-package :nutelliweb.web)

;; for @route annotation
(syntax:use-syntax :annot)

;;
;; Application

(defclass <web> (<app>) ())
(defvar *web* (make-instance '<web>))
(clear-routing-rules *web*)

;; My Helpers
(defun without-last(lst)
	(reverse (cdr (reverse lst))))


;;
;; Routing rules
;;
;; me - get post put
;; nutrition - get
;; dishes - get post put
;; recommended - get
;;
;; dashboard - get
;;

(defroute ("/" :method :GET) ()
	(if (gethash :person *session*)
		(render #P"redirect.html" '(("url" . "/dashboard"))) ;; Redirect to dashboard if there's a personal info in session
		(render #P"front.html") ;; Otherwise render front page
	))

(defroute "/dashboard" ()
	(unless (gethash :person *session*) (throw-code 403))
	(render #P"dashboard.html" ))

;; User ;#1 : destructive replace example
(defroute ("/user" :method :POST) (&key _parsed)
  (let ((q '#$(*me has (instance-of (Person)) (gender (*Male)) (age (27)) (weight ((a WeightValue with (num (70)) (unit (*KiloGram))))) (height ((a HeightValue with (num (170)) (unit (*CentiMeter))))))) (p nil) (c nil)) ; q:KM command seed
    (setq p (nthcdr 3 q)) ;p: 3rd cdr = gender
    (rplaca (cadr (pop p)) (if (string= "male" (cdr (assoc "gender" (cdar _parsed) :test #'string=)))
			       '#$*Male '#$*Female)) ; pop makes step next = age
    (rplaca (cadr (pop p)) (parse-integer (cdr (assoc "age" (cdar _parsed) :test #'string=))))
    (setq c (nthcdr 3 (caadr (pop p)))) ; skip "a WeightValue with"
    (rplaca (cadr (pop c)) (parse-integer (cdr (assoc "weight" (cdar _parsed) :test #'string=))))
    (rplaca (cadr (pop c)) '#$*KiloGram)
    (setq c (nthcdr 3 (caadr (pop p)))) ; skip "a HeightValue with"
    (rplaca (cadr (pop c)) (parse-integer (cdr (assoc "height" (cdar _parsed) :test #'string=))))
    (rplaca (cadr (pop c)) '#$*CentiMeter)
    (print q) ; for debug
    (cl-user::km0 q) ; apply to KM
    (setf (gethash :person *session*) (cdr (assoc "person" _parsed :test #'string=)))
    (render #P"redirect.html" '(("url" . "/dashboard")))))

(defroute ("/ajax/user" :method :GET) ()
	(if (gethash :person *session*)
		(render-json (gethash :person *session*))
		(throw-code 403)
	))

(defroute ("/ajax/user" :method :POST) (&key _parsed)
	(setf (gethash :person *session*) (cdr (assoc "person" _parsed :test #'string=)))
	(render-json (gethash :person *session*)))

(defroute ("/ajax/user" :method :PUT) (&key _parsed)
	(if (gethash :person *session*)
		(progn
		  (setf (gethash :person *session*) (cdr (assoc "person" _parsed :test #'string=)))
		  (render-json (gethash :person *session*))
		)
		(throw-code 403)))

;; Dishes

;;(defun get-dishes (lst year month day)
;;	(loop for item in lst
;;		when(and
;;			(eq (cadr (assoc "year" item :test #'equal)) year)
;;			(eq (cadr (assoc "month" item :test #'equal)) month)
;;			(eq (cadr (assoc "day" item :test #'equal)) day))
;;			collect item))

;;(defroute ("/dishes" :method :POST) (&key _parsed)
;;	(if (gethash :person *session*)
;;		(progn
;;			(setf (gethash :dishes *session*) (append (gethash :dishes *session*) (cdr (assoc "dishes" _parsed :test #'string=))))
;;			;;(render-json (gethash :dishes *session*))
;;			(format nil "~S" (gethash :dishes *session*))
;;		)
;;		(throw-code 403)
;;	))

(defroute ("/ajax/dishes" :method :GET) ()
	(if (gethash :person *session*)
		(render-json (gethash :dishes *session*))
		(throw-code 403)
	))
;; #2 : recursive replace example
(defun recursive-replace (i l)
  (mapcar #'(lambda (x) (if (eq x T) (pop (car l)) (if (listp x) (recursive-replace x l) x))) i))

(defroute ("/ajax/dishes" :method :POST) (&key _parsed)
  (if (gethash :person *session*)
      (let ((a '#$(a Food with (nutritions ((the nutritions of T))) (weight ((a WeightValue with (num (T)) (unit (T)))))))) ; q:KM command seed
	(setq a (recursive-replace a (list (list
				    (intern (concatenate 'string "*" (cdr (assoc "name" (cadar _parsed) :test #'string=))))
				    (parse-integer (cdr (assoc "amount" (cadar _parsed) :test #'string=)))
				    (let ((s (cdr (assoc "unit" (cadar _parsed) :test #'string=))))
				      (cond ((string= s "mg") '#$*MilliGram)
					    ((string= s "mcg") '#$*MicroGram)
					    ((string= s "kg") '#$*KiloGram)
					    (T '#$*Gram))) ))))
	(print a) ; for debug
	(cl-user::km-unique0 a) ; apply to KM, return=new food instance symbol
	(setf (gethash :dishes *session*) (append (gethash :dishes *session*) (cdr (assoc "dishes" _parsed :test #'string=))))
	(render-json (gethash :dishes *session*)))
      (throw-code 403)
      ))

(defroute ("/ajax/dishes" :method :PUT) (&key _parsed)
	(if (gethash :person *session*)
		(progn
			(setf (gethash :dishes *session*) (cdr (assoc "dishes" _parsed :test #'string=)))
			(render-json (gethash :dishes *session*))
			;;(format nil "~S" (gethash :dishes *session*))
		)
		(throw-code 403)
	))
	
(defroute ("/ajax/dishes" :method :DELETE) ()
	(if (gethash :person *session*)
		(progn
			(setf (gethash :dishes *session*) nil)
			(render-json (gethash :dishes *session*))
		)
		(throw-code 403)
	))
	
;; Nutrition
(defroute ("/ajax/nutrition" :method :GET) ()
	(if (gethash :person *session*)
		(progn
;			(cl-user::km0 (append '#$(*me has) (list(append '#$(age) (list(list(parse-integer(cdr(assoc "age" (gethash :person *session*) :test #'string=)))))))))
;			(cl-user::km0 (append '#$(*me has) (list(append '#$(weight) (list(list(parse-integer(cdr(assoc "weight" (gethash :person *session*) :test #'string=)))))))))
;			(cl-user::km0 (append '#$(*me has) (list(append '#$(height) (list(list(parse-integer(cdr(assoc "height" (gethash :person *session*) :test #'string=)))))))))
			;(cl-user::km0 '#$(make-sentence (:seq "My daily calorie status is" ((the |daily taken calorie| of *me) / (the |daily needed calorie| of *me) * 100) "nospace" "%"))))
			;;(render-json (gethash :person *session*))
			;(render-json (assoc "height" (gethash :person *session*) :test #'string=))
;			(format nil "~S" (append '#$(*me has) (list(append '#$(age) (list(list(parse-integer(cdr(assoc "height" (gethash :person *session*) :test #'string=)))))))))
			
		)
		(throw-code 403)
	))

;; Recommanded
(defroute ("/ajax/recommended" :method :GET) ()
	(if (gethash :person *session*)
		(render-json (gethash :person *session*))
		(throw-code 403)
	))
	
;; Foods
(defroute ("/ajax/foodlist" :method :GET) ()
	(render-json (cl-user::km0 '#$(the all-instances of Food))))
	;;(format nil "~S" (km0 '#$(the all-instances of Food)))))
	
;;(defroute ("/" :method :POST) (&key _parsed)
;;	(setf (gethash :person *session*) (cdr (assoc "person" _parsed :test #'string=)))
;;	(render #P"redirect.html" '(("url" . "/dashboard"))))
	;;(render #P"front.html" (list "person" (gethash :person *session*))))
	;;(format nil "~S" (list "person" (cdr(assoc "person" _parsed :test #'string=))))
	;;(render #P"front.html" '( person ( ("name" . "test") ("gender" . "male") ("age" . "1") ("weight" . "2") ("height" . "3") ) )))


;; Error pages

(defmethod on-exception ((app <web>) (code (eql 404)))
  (declare (ignore app))
  (merge-pathnames #P"_errors/404.html"
                   *template-directory*))
