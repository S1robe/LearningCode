@echo off
title Lock
color 6
cls
goto Main
::Main Point of Execution
:Main
call login
::Checks the Login info, hands off to lockdown.bat if not valid entry
:login
echo "To access self drive you must provide your Name and issued password from Kira"
set /p "user=User:"
call :checkUser %user%
set /p "pass=Password:"
call :checkPass %pass%
break
:: checks the username
:checkUser
(For %A In (X:\bag.lck.auth) Do FindStr /MC:"%user%" "%%A">Nul &&(
	Echo %user% Passed)||Echo %user% Failed)>"logarythm"
if errorlevel 1 goto fail

:checkPass
find /c "%pass%" X:\bag.auth.lck ) echo  

break

:fail
echo "You are incorrect, please re-run the script and try again"
pause
lock.bat
break