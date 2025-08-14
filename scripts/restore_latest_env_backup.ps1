# Script: restore_latest_env_backup.ps1

$backupFolder = "D:\scripts"

$backupFiles = Get-ChildItem $backupFolder -Filter "env_backup_*.txt" | Sort-Object LastWriteTime -Descending

if ($backupFiles.Count -eq 0) {
    Write-Host "No backups found in $backupFolder" -ForegroundColor Red
    exit
}

$latestBackup = $backupFiles[0]
$backupPath = $latestBackup.FullName

Write-Host "Restoring latest backup:" -ForegroundColor Yellow
Write-Host "$($latestBackup.Name) (Date: $($latestBackup.LastWriteTime))" -ForegroundColor Yellow

$lines = Get-Content $backupPath

foreach ($line in $lines) {
    if ($line -match '^(.*?)=(.*)$') {
        $name = $matches[1].Trim()
        $value = $matches[2].Trim()
        [Environment]::SetEnvironmentVariable($name, $value, [EnvironmentVariableTarget]::User)
        [Environment]::SetEnvironmentVariable($name, $value, [EnvironmentVariableTarget]::Machine)
    }
}

Write-Host "Restore completed." -ForegroundColor Green
Write-Host "Restart system or log off to apply changes." -ForegroundColor Yellow
