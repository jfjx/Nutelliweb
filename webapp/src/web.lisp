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

;; User
(defroute ("/user" :method :POST) (&key _parsed)
	(setf (gethash :person *session*) (cdr (assoc "person" _parsed :test #'string=)))
	(render #P"redirect.html" '(("url" . "/dashboard"))))
	
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
		;;(format nil "~S" captures)
		(throw-code 403)
	))

(defroute ("/ajax/dishes" :method :POST) (&key _parsed)
	(if (gethash :person *session*)
		(progn
			(setf (gethash :dishes *session*) (append (gethash :dishes *session*) (cdr (assoc "dishes" _parsed :test #'string=))))
			(render-json (gethash :dishes *session*))
			;;(format nil "~S" (gethash :dishes *session*))
		)
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
		(render-json (gethash :person *session*))
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
