@echo off

if "%b2eprogramfilename%"==""  (

	echo To see any results you need to convert cls file into an exe
	pause
	goto :eof

)

%extd% /getusername

if "%result%"=="" (exit) else (set username="%result%")

%extd% /messagebox "User name" %username%