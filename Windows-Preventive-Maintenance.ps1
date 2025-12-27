# ============================================
# Windows Preventive Maintenance Script
# Compatible: Windows 10 / Windows 11
# Author: PC HELP
# ============================================

# Verificar ejecución como administrador
if (-not ([Security.Principal.WindowsPrincipal] `
    [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
    [Security.Principal.WindowsBuiltInRole]::Administrator)) {

    Write-Host "Ejecuta este script como ADMINISTRADOR." -ForegroundColor Red
    exit
}

$LogFile = "$env:SystemDrive\Mantenimiento_Windows.log"

function Write-Log {
    param ([string]$Message)
    $time = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Add-Content -Path $LogFile -Value "$time - $Message"
}

Write-Log "Inicio de mantenimiento preventivo"

# -----------------------------
# Limpieza avanzada de disco
# -----------------------------
Write-Log "Ejecutando limpieza avanzada de disco"
Start-Process cleanmgr -ArgumentList "/sagerun:1" -Wait

# -----------------------------
# Limpieza de temporales
# -----------------------------
Write-Log "Limpiando carpetas temporales"

Get-ChildItem "$env:TEMP" -Recurse -Force -ErrorAction SilentlyContinue |
Remove-Item -Recurse -Force -ErrorAction SilentlyContinue

Get-ChildItem "C:\Windows\Temp" -Recurse -Force -ErrorAction SilentlyContinue |
Remove-Item -Recurse -Force -ErrorAction SilentlyContinue

# -----------------------------
# Desactivar hibernación
# -----------------------------
Write-Log "Desactivando hibernacion"
powercfg /h off

# -----------------------------
# Verificación de sistema
# -----------------------------
Write-Log "Ejecutando SFC"
sfc /scannow

Write-Log "Ejecutando DISM"
DISM /Online /Cleanup-Image /RestoreHealth

# -----------------------------
# Tareas programadas
# -----------------------------
Write-Log "Exportando tareas programadas"
schtasks /query /fo LIST /v > "$env:SystemDrive\tareas_programadas.txt"

# -----------------------------
# Actualización de aplicaciones
# -----------------------------
Write-Log "Actualizando aplicaciones con winget"
winget upgrade --all --silent --accept-source-agreements --accept-package-agreements

Write-Log "Mantenimiento finalizado correctamente"

Write-Host "Mantenimiento completado. Log guardado en $LogFile" -ForegroundColor Green
