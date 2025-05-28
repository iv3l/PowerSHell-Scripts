# Run as Administrator for full access
$pathsToClean = @(
    "$env:TEMP",                      # User temp folder
    "$env:WINDIR\Temp",              # Windows temp folder
    "$env:LOCALAPPDATA\Temp",        # Local user temp
    "$env:SystemDrive\Users\Public\Downloads"  # Optional: Public Downloads (comment if unsure)
)

foreach ($path in $pathsToClean) {
    if (Test-Path $path) {
        Write-Host "Cleaning: $path" -ForegroundColor Cyan
        Get-ChildItem -Path $path -Recurse -Force -ErrorAction SilentlyContinue |
            Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
    } else {
        Write-Host "Path not found: $path" -ForegroundColor DarkGray
    }
}

Write-Host "Temporary files cleanup complete." -ForegroundColor Green
