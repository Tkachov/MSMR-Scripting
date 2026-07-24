param(
    [string]$DllPath = $env:MSMR_DLL_PATH,
    [string]$OutputDir = $env:MSMR_OUTPUT_DIR,
    [string]$ScriptName = $env:MSMR_SCRIPT_NAME,
    [string]$ScriptVersion = $env:MSMR_SCRIPT_VERSION,
    [string]$ScriptType = $env:MSMR_SCRIPT_TYPE,
    [string]$ScriptAuthor = $env:MSMR_SCRIPT_AUTHOR,
    [string]$ScriptDependencies = $env:MSMR_SCRIPT_DEPS
)

if (-not $ScriptName) {
    Write-Warning "Can't pack .script with ScriptName unset."
    exit 1
}

if ([string]::IsNullOrWhiteSpace($DllPath)) {
    Write-Error "DllPath is not set. Provide -DllPath or set MSMR_DLL_PATH."
    exit 1
}

$currentDir = (Get-Location).Path

if (-not [System.IO.Path]::IsPathRooted($DllPath)) {
    $DllPath = [System.IO.Path]::GetFullPath((Join-Path $currentDir $DllPath))
}

if (-not (Test-Path -LiteralPath $DllPath -PathType Leaf)) {
    Write-Error "DLL not found at '$DllPath'. Current working directory: '$currentDir'."
    exit 1
}

$dependencies = @()
if ($ScriptDependencies -ne "") {
    $dependencies = @($ScriptDependencies -split "," | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne "" })
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

$infoJson = (ConvertTo-Json $info) -replace '\\u003e', '>'
$infoJson = $infoJson -replace '\\u003c', '<'
Set-Content -Path $infoPath -Value $infoJson -Encoding UTF8

if (Test-Path $zipFile) { Remove-Item $zipFile -Force }
if (Test-Path $scriptFile) { Remove-Item $scriptFile -Force }

Compress-Archive -Path $infoPath -DestinationPath $zipFile
Compress-Archive -Update -Path $DllPath -DestinationPath $zipFile

Rename-Item -Path $zipFile -NewName "$ScriptName.script" -Force
Write-Output "Created $scriptFile"
