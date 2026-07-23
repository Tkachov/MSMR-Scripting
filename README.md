# MSMR-Scripting

This repo contains code for MSMR-Script-SDK and a template script that uses it.

The main purpose of the SDK script is to consolidate knowledge, allowing other scripts to depend on it. If such scripts don't hook any functions on their own and only rely on SDK, only the SDK will have to be updated when the game updates.

# Usage

Dependent scripts can use the .lib by including .h files from 'MSMR-Script-SDK/game/'.

# Building

To build the SDK .dll, you'd need to use vcpkg to download the dependencies. You may need to run `vcpkg integrate install` once to enable it.

Both SDK's and template script's projects have an extra property, `$GameDirectory`, which can be set via project properties in MSVC. As a post-build step in Debug builds, the .dll is copied to 'scripts/' subfolder of that directory. You could also setup debug target to be the game executable with `-scripts -console` arguments for easier debugging.

# Packaging

In **Release** builds, the post-build step runs `pack.ps1` which packages the compiled .dll into a `.script` file (a ZIP archive containing the .dll and an `info.json` metadata file). The packaged `.script` is placed in the build output directory and, if `$GameDirectory` is set, also copied to its 'scripts/' subfolder. (`powershell.exe` / Windows PowerShell 5.1 is built into Windows 10 and 11, so no extra setup is required.)

Script metadata is configured in the `ScriptMetadata` `PropertyGroup` in the `.vcxproj` file (also visible under the **Script metadata** page in VS project properties):

| Property | Description |
|---|---|
| `ScriptName` | Name of the script — used as the `.script` filename and `name` field in `info.json`. If left empty, Release builds copy the raw .dll instead of packaging. |
| `ScriptVersion` | Version string (e.g. `1.0.0`) written into `info.json`. Defaults to `1.0.0`. |
| `ScriptType` | Type written into `info.json`: `script` for a regular script, `lib` for a library. Defaults to `script`. |
| `ScriptAuthor` | Author name written into `info.json`. |
| `ScriptDependencies` | Comma-separated list of dependencies in `Name:Version` format (e.g. `MSMR-Script-SDK:1.0.0`), written as the `dependencies` array in `info.json`. Leave empty if none. |

# Credits and license

SDK code is heavily based on LDD565's [SM2ScriptTemplate](https://github.com/hbgda/SM2ScriptTemplate).

Following Overstrike, code here is under GPLv3.
