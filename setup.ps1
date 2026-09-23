# setup.ps1 — Sumit's dev environment bootstrap

Write-Host "Installing winget packages..." -ForegroundColor Cyan

$packages = @(
    "Microsoft.VisualStudioCode",
    "Git.Git",
    "GitHub.GitHubDesktop",
    "GitHub.cli",
    "Brave.Brave",
    "Python.Python.3.12",
    "7zip.7zip",
    "Bitwarden.Bitwarden"   # remove if you use a different manager
)

foreach ($pkg in $packages) {
    winget install -e --id $pkg --accept-source-agreements --accept-package-agreements
}

# some files that werent in winget
$dl = "$env:USERPROFILE\Downloads\devsetup"
New-Item -ItemType Directory -Force -Path $dl | Out-Null

# PICkit 3 Programmer Application v3.10 (legacy standalone) [i use this particular version for mcu programming]
$pk3Url = "https://ww1.microchip.com/downloads/en/DeviceDoc/PICkit3%20Programmer%20Application%20v3.10.zip"
$pk3Zip = "$dl\PICkit3_Programmer_v3.10.zip"
Write-Host "`nDownloading PICkit 3 Programmer App..." -ForegroundColor Cyan
Invoke-WebRequest -Uri $pk3Url -OutFile $pk3Zip
Expand-Archive -Path $pk3Zip -DestinationPath "$dl\PICkit3_Programmer" -Force
Write-Host "PICkit 3 app extracted to $dl\PICkit3_Programmer" -ForegroundColor Green

#github, edit the 2nd line from this comment according to your own email (obviously i wont share mine)
git config --global user.name "Sumit"
git config --global user.email "your@email.com"   # <-- edit this

Write-Host "`nAuthenticating GitHub CLI..." -ForegroundColor Cyan
$sec = Read-Host "Paste GitHub PAT" -AsSecureString
$tok = [Runtime.InteropServices.Marshal]::PtrToStringAuto(
    [Runtime.InteropServices.Marshal]::SecureStringToBSTR($sec))
$tok | gh auth login --with-token
Remove-Variable tok, sec

#another embedded programming software
Write-Host "`nMPLAB X IDE: download from" -ForegroundColor Yellow
Write-Host "https://www.microchip.com/en-us/tools-resources/develop/mplab-x-ide" -ForegroundColor Yellow

Write-Host "`nDone. Remaining manual steps below." -ForegroundColor Green
