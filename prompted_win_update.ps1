

# IF SCRIPT DOESN'T RUN MAKE SURE THAT SCRIPT EXECUTION IS ENABLED AND YOU ARE LOGGED IN AS ADMIN

﻿# Ensure script can run by temporarily setting execution policy
Try {
    $currentPolicy = Get-ExecutionPolicy -Scope Process
    If ($currentPolicy -ne 'Bypass') {
        Write-Host "[INFO] Setting execution policy to Bypass for this session..."
        Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force
    }
} Catch {
    Write-Host "[ERROR] Failed to set execution policy: $_"
    Exit 1
}

Function Write-Log {
    param([string]$Message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Write-Host "[$timestamp] $Message"
}

# Check for admin privileges
If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
    [Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Log "ERROR: Please run this script as Administrator."
    Exit 1
}

Write-Log "Starting Windows update check..."

# Ensure NuGet and PSWindowsUpdate
Try {
    If (-not (Get-PackageProvider -Name NuGet -ErrorAction SilentlyContinue)) {
        Write-Log "Installing NuGet..."
        Install-PackageProvider -Name NuGet -Force -Scope CurrentUser
    } else {
        Write-Log "NuGet already present."
    }

    If (-not (Get-Module -ListAvailable -Name PSWindowsUpdate)) {
        Write-Log "Installing PSWindowsUpdate module..."
        Install-Module -Name PSWindowsUpdate -Force -Scope CurrentUser
    } else {
        Write-Log "PSWindowsUpdate module already present."
    }

    Import-Module PSWindowsUpdate -Force
    Write-Log "Module imported. Checking for updates..."

    $updates = Get-WindowsUpdate

    If ($updates.Count -eq 0) {
        Write-Log "No updates available. Your system is up to date."
        Exit 0
    }

    Write-Log "The following updates are available:"
    $updates | ForEach-Object { Write-Log " → $($_.Title)" }

    # Prompt the user
    $confirmation = Read-Host "`nDo you want to install these updates now? [Y/n]"

    If ($confirmation -eq "Y" -or $confirmation -eq "y" -or $confirmation -eq "") {
        Write-Log "Installing updates..."
        Install-WindowsUpdate -AcceptAll -AutoReboot -Verbose
        Write-Log "Updates installed. Reboot may occur automatically."
    } else {
        Write-Log "User cancelled update installation."
        Exit 0
    }
}
Catch {
    Write-Log "ERROR: $_"
    Exit 1
}
