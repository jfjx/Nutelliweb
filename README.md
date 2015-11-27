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
    * [Windows One-click startup script] (start.bat)
    * [One-click startup lisp script] (main.lisp)
  * KM
    * [KM test file](t/kb.lisp)
  * Web
    * [Web controller](webapp/src/web.lisp)