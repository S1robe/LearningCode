@echo off

setlocal enableDelayedExpansion
:start

set /p inputcode=Code:
set /p code=Text:
set chars=0123456789abcdefghijklmnopqrstuvwxyz

for /L %%N in (10 1 36) do (

for /F %%C in ("!chars:~%%N,1!") do (

set /a MATH=%%N*%inputcode%

for /F %%F in ("!MATH!") do (
set "code=!code:%%F=%%C!"
)
)
)
for /f %%F in ("!code!") do (
set "code=!code:-=!"
)

echo !code!
pause
cls
goto start