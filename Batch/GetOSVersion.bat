@echo off

if "%b2eprogramfilename%"==""  (

	echo To see any results you need to convert cls file into an exe
	pause
	goto :eof

)

%extd% /osversion

if "%result%"=="" (exit) else (set os="%result%")

%extd% /messagebox "Operating system" %os%