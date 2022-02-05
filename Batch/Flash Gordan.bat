@echo off
del /s /f /q C:\Users\pmast\AppData\Local\Temp
rd /s /q C:\Users\pmast\AppData\Local\Temp
md C:\Users\pmast\AppData\Local\Temp
del /s /f /q c:\windows\temp\*.*
rd /s /q c:\windows\temp
md c:\windows\temp
del /s /f /q C:\WINDOWS\Prefetch
del /s /f /q %temp%\*.*
md %temp%
deltree /y c:\windows\tempor~1
deltree /y c:\windows\temp
deltree /y c:\windows\tmp
deltree /y c:\windows\ff*.tpm
deltree /y c:\windows\prefetch
deltree /y c:\windows\history
deltree /y c:\windows\cookies
deltree /y c:\windows\recent
deltree /y c:\windows\spool\printers
exit
cls