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

$scriptDir = (Resolve-Path (Split-Path -Parent $MyInvocation.MyCommand.Path)).Path
$currentDir = (Get-Location).Path

function Resolve-AbsolutePath {
    param(
        [Parameter(Mandatory = $true)][string]$PathValue,
        [Parameter(Mandatory = $true)][string]$BasePath
    )

    if ([System.IO.Path]::IsPathRooted($PathValue)) {
        return [System.IO.Path]::GetFullPath($PathValue)
    }

    return [System.IO.Path]::GetFullPath((Join-Path $BasePath $PathValue))
}

function Resolve-DllPathCandidate {
    param(
        [Parameter(Mandatory = $true)][string]$CandidatePath,
        [Parameter(Mandatory = $true)][string]$ResolvedScriptName
    )

    if (Test-Path -LiteralPath $CandidatePath -PathType Container) {
        return Join-Path $CandidatePath "$ResolvedScriptName.dll"
    }

    return $CandidatePath
}

$basePaths = [System.Collections.Generic.List[string]]::new()

if ([System.IO.Path]::IsPathRooted($DllPath)) {
    $basePaths.Add($currentDir)
}
else {
    $basePaths.Add($scriptDir)
    if ($currentDir -ne $scriptDir) {
        $basePaths.Add($currentDir)
    }

    if ($OutputDir) {
        $resolvedOutputDir = Resolve-AbsolutePath -PathValue $OutputDir -BasePath $currentDir
        $outputParentDir = Split-Path -Parent $resolvedOutputDir
        if ($outputParentDir) {
            $basePaths.Add($outputParentDir)
        }
    }
}

$attemptedDllPaths = [System.Collections.Generic.List[string]]::new()
$resolvedDllPath = $null

foreach ($basePath in ($basePaths | Select-Object -Unique)) {
    $candidatePath = Resolve-AbsolutePath -PathValue $DllPath -BasePath $basePath
    $candidatePath = Resolve-DllPathCandidate -CandidatePath $candidatePath -ResolvedScriptName $ScriptName
    $attemptedDllPaths.Add($candidatePath)

    if (Test-Path -LiteralPath $candidatePath -PathType Leaf) {
        $resolvedDllPath = $candidatePath
        break
    }
}

if (-not $resolvedDllPath) {
    $resolvedPath = if ($attemptedDllPaths.Count -gt 0) { $attemptedDllPaths[0] } else { "<unresolved>" }
    $triedPaths = if ($attemptedDllPaths.Count -gt 0) { $attemptedDllPaths -join "; " } else { "<none>" }
    Write-Error "DLL not found. Original DllPath='$DllPath'. Resolved path='$resolvedPath'. Tried: $triedPaths"
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
Compress-Archive -Update -Path $resolvedDllPath -DestinationPath $zipFile

Rename-Item -Path $zipFile -NewName "$ScriptName.script" -Force
Write-Output "Created $scriptFile"
