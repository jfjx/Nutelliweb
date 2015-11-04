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

;;
;; Routing rules

(defroute ("/" :method :GET) ()
	(if (gethash :person *session*)
		(render #P"redirect.html" '(("url" . "/dashboard"))) ;; Redirect to dashboard if there's personal info in session
		(render #P"front.html")
	))
  
(defroute ("/" :method :POST) (&key _parsed)
	(setf (gethash :person *session*) (cdr (assoc "person" _parsed :test #'string=)))
	(render #P"redirect.html" '(("url" . "/dashboard"))))
	;;(render #P"front.html" (list "person" (gethash :person *session*))))
	;;(format nil "~S" (list "person" (cdr(assoc "person" _parsed :test #'string=))))
	;;(render #P"front.html" '( person ( ("name" . "test") ("gender" . "male") ("age" . "1") ("weight" . "2") ("height" . "3") ) )))
  
(defroute "/dashboard" ()
	(unless (gethash :person *session*) (throw-code 403))
	(render #P"dashboard.html"))

(defroute "/setting" ()
	(unless (gethash :person *session*) (throw-code 403))
	(render #P"setting.html" (list "person" (gethash :person *session*))))

(defroute "/recommended" ()
	(unless (gethash :person *session*) (throw-code 403))
	(render #P"recommended.html"))

(defroute "/dishes" ()
	(unless (gethash :person *session*) (throw-code 403))
	(render #P"dishes.html"))

(defroute "/nutrient" ()
	(unless (gethash :person *session*) (throw-code 403))
	(render #P"nutrient.html"))

;;
;; Error pages

(defmethod on-exception ((app <web>) (code (eql 404)))
  (declare (ignore app))
  (merge-pathnames #P"_errors/404.html"
                   *template-directory*))
