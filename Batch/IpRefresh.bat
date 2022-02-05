@echo off
runas /user:Garrett IpRefresh.bat
color 2
ipconfig /release 
ipconfig /flushdns
ipconfig /renew
cls