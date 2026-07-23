# MSMR-Scripting

This repo contains code for MSMR-Script-SDK and a template script that uses it.

The main purpose of the SDK script is to consolidate knowledge, allowing other scripts to depend on it. If such scripts don't hook any functions on their own and only rely on SDK, only the SDK will have to be updated when the game updates.

# Usage

Dependent scripts can use the .lib by including .h files from 'MSMR-Script-SDK/game/'.

# Building

To build the SDK .dll, you'd need to use vcpkg to download the dependencies. You may need to run `vcpkg integrate install` once to enable it.

Both SDK's and template script's projects have an extra property, `$GameDirectory`, which can be set via project properties in MSVC. As a post-build step in Debug builds, the .dll is copied to 'scripts/' subfolder of that directory. You could also setup debug target to be the game executable with `-scripts -console` arguments for easier debugging.

# Packaging

In **Release** builds, the post-build step runs `pack.ps1` which packages the compiled .dll into a `.script` file (a ZIP archive containing the .dll and an `info.json` metadata file). The packaged `.script` is placed in the build output directory and, if `$GameDirectory` is set, also copied to its 'scripts/' subfolder.

Script metadata can be set via project properties under the **Script metadata** page:

| Property | Description |
|---|---|
| **Script Name** | Name of the script — used as the `.script` filename and `name` field in `info.json`. If left empty in Release builds the raw .dll is deployed instead. |
| **Script Version** | Version string (e.g. `1.0.0`) written into `info.json`. |
| **Script Author** | Author name written into `info.json`. |

# Credits and license

SDK code is heavily based on LDD565's [SM2ScriptTemplate](https://github.com/hbgda/SM2ScriptTemplate).

Following Overstrike, code here is under GPLv3.
