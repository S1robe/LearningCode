@echo off

if "%b2eprogramfilename%"==""  (

	echo To see any results you need to convert cls file into an exe
	pause
	goto :eof

)

%extd% /messagebox "" "OK, Cancel" 1

IF %result% EQU 1 %extd% /messagebox Result Ok

IF %result% EQU 2 %extd% /messagebox Result Cancel