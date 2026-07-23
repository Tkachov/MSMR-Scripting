param(
    [string]$DllPath,
    [string]$OutputDir,
    [string]$ScriptName,
    [string]$ScriptVersion = "1.0.0",
    [string]$ScriptAuthor = "",
    [string]$GameDirectory = ""
)

if (-not $ScriptName) {
    Write-Warning "ScriptName is not set, skipping .script packaging."
    if ($GameDirectory -ne "" -and (Test-Path $GameDirectory)) {
        $scriptsDir = Join-Path $GameDirectory "scripts"
        if (-not (Test-Path $scriptsDir)) {
            New-Item -ItemType Directory -Path $scriptsDir | Out-Null
        }
        Copy-Item -Path $DllPath -Destination $scriptsDir -Force
        Write-Output "Copied $DllPath to $scriptsDir"
    }
    exit 0
}

$infoPath = Join-Path $OutputDir "info.json"
$zipFile = Join-Path $OutputDir "$ScriptName.zip"
$scriptFile = Join-Path $OutputDir "$ScriptName.script"

$info = [ordered]@{
    name           = $ScriptName
    type           = "script"
    author         = $ScriptAuthor
    version        = $ScriptVersion
    game           = "MSMR"
    format_version = 1
}

$infoJson = ConvertTo-Json $info
Set-Content -Path $infoPath -Value $infoJson -Encoding UTF8

if (Test-Path $zipFile) { Remove-Item $zipFile -Force }
if (Test-Path $scriptFile) { Remove-Item $scriptFile -Force }

Compress-Archive -Path $infoPath -DestinationPath $zipFile
Compress-Archive -Update -Path $DllPath -DestinationPath $zipFile

Rename-Item -Path $zipFile -NewName "$ScriptName.script" -Force

Write-Output "Created $scriptFile"

if ($GameDirectory -ne "" -and (Test-Path $GameDirectory)) {
    $scriptsDir = Join-Path $GameDirectory "scripts"
    if (-not (Test-Path $scriptsDir)) {
        New-Item -ItemType Directory -Path $scriptsDir | Out-Null
    }
    Copy-Item -Path $scriptFile -Destination $scriptsDir -Force
    Write-Output "Copied to $scriptsDir"
}
