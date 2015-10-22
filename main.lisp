;Load dependencies
(loop for lib in '(
   		   #P"lib/km-2-5-33.fasl" ; Compiled KM
		   #P"webapp/nutelliweb.asd" ; Webserver
		   )
   do (load lib))

;(compile-file #P"lib/km-2-5-33.lisp")  ;compile KM for faster process


(ql:quickload :caveman2)

; This "Nutrition" KM is mal-modeled and needed to be replaced.
;(untracekm) ;stop trace
(untracekm)
(km '#$(load-kb "kb/Nutelliweb.kb")) ;load a chemical nutrition kb

;Load and start web server
(asdf:operate 'asdf:load-op 'nutelliweb) ;load
(nutelliweb:start :port 9099) ;start
