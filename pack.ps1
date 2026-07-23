param(
    [string]$DllPath,
    [string]$OutputDir,
    [string]$ScriptName,
    [string]$ScriptVersion = "1.0.0",
    [string]$ScriptType = "script",
    [string]$ScriptAuthor = "",
    [string]$ScriptDependencies = "",
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

$dependencies = @()
if ($ScriptDependencies -ne "") {
    $dependencies = $ScriptDependencies -split "," | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne "" }
}

$infoPath = Join-Path $OutputDir "info.json"
$zipFile = Join-Path $OutputDir "$ScriptName.zip"
$scriptFile = Join-Path $OutputDir "$ScriptName.script"

$info = [ordered]@{
    name           = $ScriptName
    type           = if ($ScriptType -ne "") { $ScriptType } else { "script" }
    author         = $ScriptAuthor
    version        = $ScriptVersion
    dependencies   = $dependencies
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
