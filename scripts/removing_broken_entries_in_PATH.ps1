# Removing broken entries from PATH
$backupFile = "$PSScriptRoot\PATH_backup.txt"

# Backup current PATH
$envPath = [System.Environment]::GetEnvironmentVariable("Path", "Machine")
Set-Content -Path $backupFile -Value $envPath -Encoding UTF8
Write-Host "[INFO] Rezervnaya kopiya PATH sohranena v $backupFile"

# Split PATH entries
$pathEntries = $envPath -split ";"

# Detect broken entries
$brokenEntries = @()
foreach ($entry in $pathEntries) {
    if (-not [string]::IsNullOrWhiteSpace($entry) -and -not (Test-Path $entry)) {
        $brokenEntries += $entry
    }
}

if ($brokenEntries.Count -eq 0) {
    Write-Host "[INFO] Bityh zapisej ne najdeno."
    exit
}

Write-Host "[WARN] Najdeny bitye zapisi v PATH:"
$brokenEntries | ForEach-Object { Write-Host $_ }

# Ask if delete all
$deleteAll = Read-Host "Udalit vse najdennye bitye zapisi srazu? (Y/N)"
$newEntries = @()

foreach ($entry in $pathEntries) {
    if ($brokenEntries -contains $entry) {
        if ($deleteAll -match "^[Yy]$") {
            Write-Host "[DEL] Udalena: $entry"
            continue
        } else {
            $answer = Read-Host "Udalit etu zapis? '$entry' (Y/N)"
            if ($answer -match "^[Yy]$") {
                Write-Host "[DEL] Udalena: $entry"
                continue
            } else {
                Write-Host "[SKIP] Propushchena: $entry"
            }
        }
    }
    $newEntries += $entry
}

# Build new PATH
$newPath = ($newEntries -join ";").TrimEnd(";")
[System.Environment]::SetEnvironmentVariable("Path", $newPath, "Machine")

Write-Host "[OK] Ochistka PATH zavershena."
