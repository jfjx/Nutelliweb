;Load KM
(load #P"lib/km-2-5-33.fasl") ; Load coompiled KM
;(loop for lib in '(
;   		   #P"lib/km-2-5-33.lisp"
;		   )
;   do (load lib))

;(compile-file #P"lib/km-2-5-33.lisp")					;compile KM for faster process


(ql:quickload :caveman2)

; This "Nutrition" KM is mal-modeled and needed to be replaced.
					;(untracekm) ;stop trace
(untracekm)
(km '(load-kb "kb/Nutelliweb.kb")) ;load a chemical nutrition kb

;Load and start web server
;(caveman2:make-project #P"webapp" :name "nutelliweb") ;make a new skeleton
(load "webapp/nutelliweb.asd")
(asdf:operate 'asdf:load-op 'nutelliweb) ;load
(nutelliweb:start :port 9099) ;start
