# NutelliWeb

### One-click startup on Windows
Run `start.bat`

### Requirements on Windows
  * ([Chocolatey](https://chocolatey.org) package names)
    * [openssl.light](https://chocolatey.org/packages/openssl.light)
    * [mingw](https://chocolatey.org/packages/mingw)
    * [sbcl](https://chocolatey.org/packages/sbcl)
  * [Quicklisp](https://www.quicklisp.org/beta/)

### Mainly checkable sources
  * Windows One-click startup
    * [Windows One-click startup script] (blob/master/start.bat)
    * [One-click startup lisp script] (blob/master/main.lisp)
  * KM
    * [KM test file](blob/master/t/kb.lisp)
  * Web
    * [Web controller](blob/master/webapp/src/web.lisp)