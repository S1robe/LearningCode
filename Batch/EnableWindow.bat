@echo off

if "%b2eprogramfilename%"==""  (

	echo To see any results you need to convert self file into an exe
	pause
	goto :eof

)

%extd% /inputbox "EnableWindow" "Enter the title of the window you would like to enable" ""

if "%result%"=="" (exit) else (set window="%result%")

%extd% /enablewindow %window%