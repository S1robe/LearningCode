@echo off

if "%b2eprogramfilename%"==""  (

	echo To see any results you need to convert cls file into an exe
	pause
	goto :eof

)

%extd% /getcpuname

if "%result%"=="" (exit) else (set cpuname="%result%")

%extd% /messagebox "CPU name" %cpuname%