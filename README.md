# NutelliWeb
Lisp based daily nutrition intake trace [KM](http://www.cs.utexas.edu/users/mfkb/km.html) connected with local web framework ([Caveman 2](http://8arrow.org/caveman/))

### One-click startup on Windows
Run `start.bat`

### Requirements on Windows
  * ([Chocolatey](https://chocolatey.org) package names)
    * [openssl.light](https://chocolatey.org/packages/openssl.light)
    * [mingw](https://chocolatey.org/packages/mingw)
    * [sbcl](https://chocolatey.org/packages/sbcl)
```
cinst -y openssl.light mingw sbcl
```
  * [Quicklisp](https://www.quicklisp.org/beta/)

### Mainly checkable sources
  * Windows One-click startup
    * [One-click startup lisp script] (main.lisp)
  * KM
    * [KM test file](t/kb.lisp)
  * Web
    * [Web controller](webapp/src/web.lisp)

### REST-KM Controller example
  * [Example #1 : destructive replace](webapp/src/web.lisp#L49)
  * [Example #2 : recursive replace](webapp/src/web.lisp#L110)