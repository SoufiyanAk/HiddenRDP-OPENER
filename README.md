# HiddenRDP-OPENER v2.0

A comprehensive script for managing Remote Desktop Protocol (RDP) configuration on Windows systems with full installation and rollback capabilities.

> **⚠️ Security Notice**: This script creates administrative accounts and modifies system files. Use only on systems you own or have explicit authorization to modify. Always follow your organization's security policies and change default passwords immediately.

---

## 🚀 New Features in v2.0

- **Interactive Menu System**: Easy-to-use menu for installation, rollback, and status checking
- **Complete Rollback Functionality**: Safely undo all changes made by the script
- **Enhanced Backup System**: Automatic backup of registry settings and system files
- **Status Monitoring**: View current RDP configuration and backup status
- **Improved Logging**: Comprehensive logging of all operations
- **Error Handling**: Better error detection and user feedback

---

## 🎯 Requirements

- **Supported Operating Systems:**
  - Windows 7
  - Windows 8/8.1
  - Windows 10
  - Windows 11
  - *Note: Administrator privileges required*

---

## 📋 How It Works

The script provides four main functions through an interactive menu:

### 1. **Install/Configure RDP**
- Creates a temporary administrative account with secure settings
- Enables RDP connections through registry modifications
- Backs up original system files and registry settings
- Configures user visibility settings
- Deploys modified `termsrv.dll` (if available)

### 2. **Rollback/Uninstall**
- Removes the temporary administrative account
- Disables RDP connections
- Restores original system files from backups
- Cleans up registry modifications
- Maintains system integrity

### 3. **View Status**
- Shows current RDP configuration status
- Lists existing temporary accounts
- Displays available backup files
- Provides system overview

### 4. **Exit**
- Safely exits the script

---

## 🔧 Installation & Usage

### Step 1: Prepare Files
1. Download `RDPScript.bat` and `termsrv.dll` (if needed)
2. Place both files in the same directory on the target system
3. Right-click on `RDPScript.bat` and select "Run as Administrator"

### Step 2: Configure Settings (Optional)
Before running, you can customize these variables in the script:
```batch
SET TEMP_USER=RDPTempAdmin          # Change username
SET TEMP_PASSWORD=#SecureTempPwd123! # Change password (IMPORTANT!)
```

### Step 3: Run the Script
1. Execute `RDPScript.bat` as Administrator
2. Select option [1] to install RDP configuration
3. Follow the on-screen prompts
4. **Important**: Change the temporary password immediately after installation

---

## 🔄 Rollback Process

To completely remove all changes:
1. Run `RDPScript.bat` as Administrator
2. Select option [2] for rollback
3. Confirm the rollback when prompted
4. The script will automatically:
   - Remove temporary accounts
   - Disable RDP connections
   - Restore original files
   - Clean registry entries

---

## 📊 Status Monitoring

Use option [3] to check:
- Current RDP enable/disable status
- Temporary account existence
- Available backup files
- System configuration overview

---

## 🛡️ Security Considerations

### Best Practices:
- **Change default passwords immediately** after installation
- **Use strong, unique passwords** for temporary accounts
- **Remove temporary accounts** when no longer needed
- **Run rollback** to clean up when finished
- **Monitor system logs** for any unusual activity

### Default Credentials (CHANGE THESE!):
- Username: `RDPTempAdmin`
- Password: `#SecureTempPwd123!`

---

## 📁 File Structure

```
project/
├── RDPScript.bat       # Main script with menu system
├── termsrv.dll         # Modified terminal services DLL (optional)
└── README.md          # This documentation
```

---

## 📝 Logging & Backups

The script creates several backup and log files:

### Log Files:
- `C:\RDP_Config_YYYYMMDD.log` - Operation logs

### Backup Files:
- `C:\Windows_System32_Backup_HHMMSS\` - System file backups
- `C:\RDP_Registry_Backup_YYYYMMDD.reg` - Registry backups

---

## ❓ Troubleshooting

### Common Issues:

**"Access Denied" Error:**
- Ensure you're running as Administrator
- Check Windows UAC settings

**DLL Deployment Failed:**
- Verify `termsrv.dll` exists in the same directory
- Check file permissions
- Ensure no antivirus interference

**User Account Creation Failed:**
- Check password complexity requirements
- Verify account naming conventions
- Review local security policies

**Rollback Issues:**
- Ensure backup files exist before rolling back
- Run as Administrator
- Check log files for specific errors

---

## 🔧 Advanced Configuration

### Custom User Account:
```batch
SET TEMP_USER=YourCustomUsername
SET TEMP_PASSWORD=YourSecurePassword123!
```

### Custom Backup Location:
```batch
SET BACKUP_DIR=D:\CustomBackupPath
```

---

## 📜 License

This project is open source and free to use with no conditions.

**Copyright © 2019-2025 Soufiyan AKAABOUB**  
All rights reserved.

---

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

---

## ⚠️ Disclaimer

This software is provided "as is" without warranty. Users are responsible for:
- Compliance with local laws and regulations
- System security and integrity
- Proper authorization before use
- Regular security audits

**Use at your own risk and only on systems you own or have explicit permission to modify.**
