# Description: Scans open TCP ports on the local machine
# Usage: .\port_scanner.ps1 [--detailed]

Write-Host "Running Port Scan - $(Get-Date)"

# Set output folder and create it if it doesn't exist
$outputFolder = "..\outputs"
if (-not (Test-Path $outputFolder)) {
    Write-Host "Creating outputs directory..."
    New-Item -ItemType Directory -Path $outputFolder | Out-Null
} else {
    Write-Host "Using existing outputs directory..."
}

# Create timestamped output file
$timestamp = Get-Date -Format "yyyy-MM-dd_HHmm"
$outputFile = "$outputFolder\port_scan_$timestamp.txt"

# Try to use Get-NetTCPConnection or fallback to netstat
if (Get-Command Get-NetTCPConnection -ErrorAction SilentlyContinue) {
    # Modern Windows (PowerShell 5+, Windows 10+)
    $connections = Get-NetTCPConnection | Where-Object { $_.State -eq "Listen" }
} else {
    # Older Windows
    $connections = netstat -an | Select-String "LISTENING"
}

# Display open ports
Write-Host "`nOpen Ports:"

if ($connections -is [System.Array] -or $connections -is [System.Collections.IEnumerable]) {
    foreach ($conn in $connections) {
        if ($conn.LocalAddress -and $conn.LocalPort) {
            $line = "{0}:{1}" -f $conn.LocalAddress, $conn.LocalPort
            Write-Output $line
            Add-Content -Path $outputFile -Value $line
        }
    }
} else {
    # netstat fallback output
    $connections | ForEach-Object {
        Write-Output $_
        Add-Content -Path $outputFile -Value $_
    }
}

# If --detailed is passed, show more info
if ($args[0] -eq "--detailed") {
    Write-Host "`nDetailed Scan:"

    if (Get-Command Get-NetTCPConnection -ErrorAction SilentlyContinue) {
        $detailed = Get-NetTCPConnection
        $detailed | Format-Table -AutoSize | Out-String | Tee-Object -FilePath $outputFile -Append
    } else {
        netstat -ano | Tee-Object -FilePath $outputFile -Append
    }
}

Write-Host "`nResults saved to $outputFile"
