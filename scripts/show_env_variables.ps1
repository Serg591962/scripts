# Скрипт выводит переменные среды пользователя и системы в удобном виде

Write-Host "=== USER ENVIRONMENT VARIABLES ===`n"

# Переменные среды текущего пользователя
$userVars = [System.Environment]::GetEnvironmentVariables("User")
foreach ($key in $userVars.Keys) {
    $value = $userVars[$key]
    Write-Host "$key = $value"
}

Write-Host "`n=== SYSTEM ENVIRONMENT VARIABLES ===`n"

# Системные переменные среды
$systemVars = [System.Environment]::GetEnvironmentVariables("Machine")
foreach ($key in $systemVars.Keys) {
    $value = $systemVars[$key]
    Write-Host "$key = $value"
}

Write-Host "`n=== END OF ENVIRONMENT VARIABLES ==="
