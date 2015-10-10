;Load KM
(loop for lib in '(
   		   #P"lib/km-2-5-33.lisp"
		   )
   do (load lib))

(ql:quickload :caveman2)

; This "Nutrition" KM is mal-modeled and needed to be replaced.
;(km '(load-kb "kb/Nutrition.kb")) ;load a chemical nutrition kb

;Load and start web server
;(caveman2:make-project #P"webapp" :name "nutelliweb") ;make a new skeleton
(load "webapp/nutelliweb.asd")
(asdf:operate 'asdf:load-op 'nutelliweb) ;load
(nutelliweb:start :port 9099) ;start
