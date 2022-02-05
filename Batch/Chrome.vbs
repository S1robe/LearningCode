set g = wscript.CreateObject("WScript.shell")
g.CurrentDirectory = "C:\Users\Mom\Desktop"
g.run "chrome"
wscript.sleep 5000
g.run "taskkill /f /im chrome.exe", , True
g.run "notepad"

wscript.sleep 1000
g.sendkeys "Lol, you thought this was normal Google huh XD" & vbLf
wscript.sleep 3000
g.sendkeys "its not btw, but anyway I now i have complete control of this computer thanks to you" & vbLf
wscript.sleep 5000
g.sendkeys "um yeah" & vbLf
wscript.sleep 3000
g.sendkeys "."
wscript.sleep 1000
g.sendkeys "."
wscript.sleep 1000
g.sendkeys "."
wscript.sleep 1000
g.sendkeys "."
wscript.sleep 1000
g.sendkeys "."
wscript.sleep 1000
g.sendkeys "."
wscript.sleep 1000
g.sendkeys "."
wscript.sleep 1000
g.sendkeys "." & vbCrLfs
wscript.sleep 1000
g.sendkeys "byeeeeeee!!!"	
wscript.sleep 2000



g.run "taskkill /f /im notepad.exe", , True
g.run "cmd /k RunMe.bat", 1, True