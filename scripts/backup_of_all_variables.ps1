# Get timestamp for unique filename
$timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"

# Backup folder
$backupFolder = "D:\scripts"

# Create folder if it doesn't exist
if (!(Test-Path $backupFolder)) {
    New-Item -Path $backupFolder -ItemType Directory | Out-Null
}

# Full path to backup file
$backupFile = "$backupFolder\env_backup_$timestamp.txt"

# Get all environment variables and save to file
Get-ChildItem Env: | Sort-Object Name | Out-File -FilePath $backupFile -Encoding UTF8

# Output result
Write-Host "Backup of environment variables saved to:" -ForegroundColor Green
Write-Host $backupFile -ForegroundColor Yellow
