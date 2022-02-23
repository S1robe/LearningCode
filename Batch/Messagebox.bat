@echo off

if "%b2eprogramfilename%"==""  (

	echo To see any results you need to convert self file into an exe
	pause
	goto :eof

)

%extd% /messagebox Title "A simple Messagebox"