# Windows Preventive Maintenance Script

PowerShell script for basic preventive maintenance on Windows systems.

## Features
- Disk cleanup
- Temporary files removal
- System integrity verification
- Network reset
- Application updates using winget

## Requirements
- Windows 10 / 11
- PowerShell 5.1 or higher
- Administrator privileges

## Usage
1. Backup important data
2. Run PowerShell as Administrator
3. Execute:
   ```powershell
   Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
   .\Windows-Preventive-Maintenance.ps1


