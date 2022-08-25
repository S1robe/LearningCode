@echo off

if "%b2eprogramfilename%"==""  (

	echo To see any results you need to convert cls file into an exe
	pause
	goto :eof

)

%extd% /showself

%extd% /input

if "%result%"=="" (exit) else (set string="%result%")

%extd% /messagebox Result %string%
