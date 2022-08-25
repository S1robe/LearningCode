@echo off

if "%b2eprogramfilename%"==""  (

	echo To see any results you need to convert cls file into an exe
	pause
	goto :eof

)

%extd% /showself

%extd% /sleep 2000

%extd% /hideself

%extd% /sleep 2000

%extd% /showself

%extd% /sleep 2000