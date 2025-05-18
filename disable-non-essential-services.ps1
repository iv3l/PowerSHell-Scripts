# List of non-essential services to stop (temporary)
$servicesToStop = @(
    "WSearch",          # Windows Search
    "Spooler",          # Print Spooler
    "Fax",              # Fax Service
    "DiagTrack",        # Connected User Experiences and Telemetry
    "SysMain",          # Superfetch
    "XblGameSave",      # Xbox Game Save
    "bthserv",          # Bluetooth Support
    "RemoteRegistry",
    "RetailDemo",
    "MapsBroker",
    "PhoneSvc",
    "PrintNotify",
    "wlidsvc",
    "AppXSvc",
    "CDPSvc",
    "DPS",
    "dmwappushservice",
    "TabletInputService",
    "OneSyncSvc",
    "WMPNetworkSvc",
    "SharedAccess",
    "WerSvc"
)

foreach ($serviceName in $servicesToStop) {
    try {
        $service = Get-Service -Name $serviceName -ErrorAction Stop

        if ($service.Status -eq "Running") {
            Write-Host "Stopping $($service.DisplayName)..." -ForegroundColor Yellow
            Stop-Service -Name $serviceName -Force -ErrorAction Stop
            Write-Host " -> Stopped." -ForegroundColor Green
        } else {
            Write-Host "Skipping $($service.DisplayName): Already stopped." -ForegroundColor DarkGray
        }
    } catch {
        Write-Host "Skipping $serviceName : Not found or can't be stopped." -ForegroundColor Red
    }
}
