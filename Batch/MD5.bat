@echo off

if "%b2eprogramfilename%"==""  (

	echo To see any results you need to convert cls file into an exe
	pause
	goto :eof

)

%extd% /browseforfile "Choose a file" "" "All Files (*.*)|*.*"

if "%result%"=="" (exit) else (set file="%result%")

%extd% /md5 %file%

if "%result%"=="" (exit) else (set md5="%result%")

%extd% /messagebox Result %md5%