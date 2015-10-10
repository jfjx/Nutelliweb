(in-package :cl-user)
(defpackage nutelliweb-test-asd
  (:use :cl :asdf))
(in-package :nutelliweb-test-asd)

(defsystem nutelliweb-test
  :author ""
  :license ""
  :depends-on (:nutelliweb
               :prove)
  :components ((:module "t"
                :components
                ((:file "nutelliweb"))))
  :perform (load-op :after (op c) (asdf:clear-system c)))
