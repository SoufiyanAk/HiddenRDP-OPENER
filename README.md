# HiddenRDP-OPENER v2.1 - Script Generator

A versatile RDP configuration tool that generates different types of scripts based on your needs - from completely silent/hidden operations to full logging versions.

> **👨‍👩‍👧‍👦 Parental Control Notice**: This tool is designed for legitimate parental monitoring and system administration. The silent mode allows parents to monitor children's online activities discretely for safety purposes.

---

## 🎯 Key Features

### **Script Generation Modes:**

#### 1. **🤫 Silent/Hidden Script** - Perfect for Parental Control
- **Zero output** - completely invisible operation
- **No logs or traces** - runs without any visible indication
- **Instant execution** - one-click RDP access
- **Hidden admin account** - invisible in login screen
- **Ideal for parents** monitoring children's computer usage

#### 2. **📋 Normal Script** - Full Documentation
- Complete logging and progress feedback
- File backups and detailed reports
- Error handling and status messages
- Professional system administration

#### 3. **🔄 Rollback Script** - Clean Removal
- Removes all traces of RDP configuration
- Disables RDP connections
- Deletes created accounts
- Restores original system files

#### 4. **⚡ Direct Operations** - Immediate Execution
- Install or rollback in the current session
- No additional files created
- Quick testing and temporary access

---

## 🚀 Quick Start Guide

### For Parents (Silent Mode):
1. Run `RDPScript.bat` as Administrator
2. Choose option **[1] Generate Silent/Hidden Script**
3. Set username and password (or use defaults)
4. Copy the generated `RDP_Silent.bat` to target computer
5. Run `RDP_Silent.bat` as Administrator - **it will execute silently with no indication**
6. Access the computer via RDP using the hidden account

### For System Administrators (Normal Mode):
1. Run `RDPScript.bat` as Administrator
2. Choose option **[2] Generate Normal Script**
3. Configure username and password
4. Use the generated `RDP_Normal.bat` for documented installation

---

## 📋 Requirements

- **Operating Systems:** Windows 7, 8, 10, 11
- **Privileges:** Administrator access required
- **Use Case:** Legitimate system administration or parental monitoring

---

## 🔧 Detailed Usage

### 🤫 Silent Script Generation
```
Username: WindowsUser (default)
Password: Pass123! (default)
File: RDP_Silent.bat

Features:
✓ No console output whatsoever
✓ No log files created
✓ No visible progress indicators
✓ Hidden administrative account
✓ Automatic service restart
✓ Silent exit after completion
```

### 📋 Normal Script Generation  
```
Username: RDPAdmin (default)
Password: SecurePass123! (default)
File: RDP_Normal.bat

Features:
✓ Progress messages and status updates
✓ Detailed log file creation
✓ System file backups
✓ Error handling and reporting
✓ Completion summary display
```

### 🔄 Rollback Script
```
File: RDP_Rollback.bat

Features:
✓ Disables RDP connections
✓ Removes ALL created accounts (WindowsUser, RDPAdmin, etc.)
✓ Cleans registry entries
✓ Restores original system files
✓ Complete system cleanup
```

---

## 🛡️ Security & Ethics

### ✅ Legitimate Uses:
- **Parental monitoring** of children's computer activity
- **System administration** in corporate environments  
- **Remote support** for family members
- **Personal computer management** across multiple devices

### ⚠️ Important Security Notes:
- **Change default passwords immediately** after installation
- **Use only on computers you own** or have explicit permission to access
- **Inform users** when appropriate (except for parental monitoring of minors)
- **Run rollback scripts** when access is no longer needed
- **Monitor accounts** for any unauthorized usage

### 👨‍👩‍👧‍👦 For Parents:
The silent mode is specifically designed for parents who need to monitor their children's online activities for safety reasons. The hidden account allows parents to:
- Check browsing history and installed software
- Monitor online communications for safety
- Ensure children are following internet usage rules
- Provide remote technical support

---

## 📁 Generated Files

| File | Purpose | Visibility | Logs |
|------|---------|------------|------|
| `RDP_Silent.bat` | Stealth installation | None | None |
| `RDP_Normal.bat` | Standard installation | Full | Yes |
| `RDP_Rollback.bat` | Complete removal | Minimal | None |

---

## 🔍 Default Credentials

### Silent Script:
- **Username:** `WindowsUser`
- **Password:** `Pass123!`

### Normal Script:
- **Username:** `RDPAdmin`  
- **Password:** `SecurePass123!`

> **🔒 CRITICAL:** These are default credentials - **change them immediately** for security!

---

## 🎮 Step-by-Step: Parental Control Setup

### Initial Setup (One-time):
1. **Download** the script generator to your computer
2. **Run as Administrator:** Right-click → "Run as administrator"
3. **Select [1]** for Silent/Hidden Script
4. **Choose username/password** (write them down safely)
5. **Generated file:** `RDP_Silent.bat` is created

### Deployment (On child's computer):
1. **Copy** `RDP_Silent.bat` to the child's computer
2. **Right-click → Run as administrator** (requires admin access once)
3. **No visible output** - script runs completely silently
4. **RDP is now enabled** with hidden account

### Remote Access:
1. **Open Remote Desktop** on your computer
2. **Connect to child's computer** IP address
3. **Login with:** username and password you set
4. **Monitor safely** - account is invisible to child

### Cleanup (When no longer needed):
1. **Generate rollback script** from main generator
2. **Run rollback** on child's computer to remove all traces

---

## ❓ Troubleshooting

### Silent Script Issues:
- **No visible errors:** Check Windows Event Viewer for system errors
- **RDP not working:** Verify Windows Firewall allows RDP connections
- **Access denied:** Ensure script was run as Administrator

### Connection Problems:
- **Can't connect:** Check IP address and network connectivity
- **Login failed:** Verify username/password are correct
- **Account not found:** Script may have failed - try normal mode for debugging

### Cleanup Issues:
- **Account still visible:** Run rollback script as Administrator
- **RDP still enabled:** Manually disable in System Properties → Remote

---

## 📄 File Structure
```
project/
├── RDPScript.bat           # Main script generator
├── termsrv.dll            # Modified DLL (optional)
├── README.md              # This documentation
└── generated/             # Generated scripts appear here
    ├── RDP_Silent.bat     # Silent installation
    ├── RDP_Normal.bat     # Normal installation  
    └── RDP_Rollback.bat   # Cleanup script
```

---

## 🤝 Contributing

This project welcomes contributions for:
- Additional security features
- Better error handling
- Support for more Windows versions
- Enhanced stealth capabilities
- Improved parental control features

---

## 📜 License & Disclaimer

**Open source and free to use for legitimate purposes.**

### Legal Notice:
- **Permitted:** Parental monitoring of minor children
- **Permitted:** Administration of owned systems
- **Permitted:** Authorized corporate IT management
- **Prohibited:** Unauthorized access to systems
- **Prohibited:** Violating privacy laws or regulations

**Copyright © 2019-2025 Soufiyan AKAABOUB**

---

## ⚠️ Final Warning

**Use responsibly and legally.** This tool is designed for legitimate system administration and parental monitoring purposes. Users are fully responsible for compliance with local laws, regulations, and ethical guidelines. The authors assume no responsibility for misuse.
