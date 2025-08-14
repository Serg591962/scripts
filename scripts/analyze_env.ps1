# Analyze environment variables and paths

Write-Host "=== Environment Variables Analysis ===" -ForegroundColor Cyan

# Known variable descriptions
$envDescriptions = @{
    "PATH" = "List of directories to search for executables"
    "TEMP" = "Temporary folder for the user"
    "TMP" = "Alternative temporary folder variable"
    "JAVA_HOME" = "Path to Java installation"
    "GRADLE_USER_HOME" = "Custom Gradle cache location"
    "ANDROID_HOME" = "Path to Android SDK"
    "ANDROID_AVD_HOME" = "Path to Android Virtual Devices"
    "NODE_PATH" = "Path to global Node.js modules"
}

# Get all environment variables
$envVars = Get-ChildItem Env:

foreach ($var in $envVars) {
    $desc = $envDescriptions[$var.Name]
    if (-not $desc) { $desc = "No description available" }
    Write-Host "`n$($var.Name) = $($var.Value)"
    Write-Host "    Description: $desc"
    # If it's a path, check if it exists
    if (Test-Path $var.Value) {
        Write-Host "    Status: Path exists" -ForegroundColor Green
    } elseif ($var.Value -match "^[A-Za-z]:\\") {
        Write-Host "    Status: Path NOT found" -ForegroundColor Red
    }
}

Write-Host "`n=== PATH Variable Analysis ===" -ForegroundColor Yellow
$pathEntries = $env:PATH -split ";"
foreach ($p in $pathEntries) {
    if ($p.Trim() -ne "") {
        if (Test-Path $p) {
            Write-Host "[OK] $p" -ForegroundColor Green
        } else {
            Write-Host "[MISSING] $p" -ForegroundColor Red
        }
    }
}

Write-Host "`n=== Possible Safe Removals (MISSING paths) ===" -ForegroundColor Magenta
foreach ($p in $pathEntries) {
    if ($p.Trim() -ne "" -and -not (Test-Path $p)) {
        Write-Host $p
    }
}

Write-Host "`nAnalysis complete."
