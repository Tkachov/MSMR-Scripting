# MSMR-Scripting

This repo contains code for MSMR-Script-SDK and a template script that uses it.

The main purpose of the SDK script is to consolidate knowledge, allowing other scripts to depend on it. If such scripts don't hook any functions on their own and only rely on SDK, only the SDK will have to be updated when the game updates.

# Usage

Dependent scripts can use the .lib by including .h files from 'MSMR-Script-SDK/game/'.

# Building

To build the SDK .dll, you'd need to use vcpkg to download the dependencies. You may need to run `vcpkg integrate install` once to enable it.

Both SDK's and template script's projects have an extra property, `$GameDirectory`, which can be set via project properties in MSVC. As a post-build step, .dll is copied to 'scripts/' subfolder of that directory. You could also setup debug target to be the game executable with `-scripts -console` arguments for easier debugging.

# Credits and license

SDK code is heavily based on LDD565's [SM2ScriptTemplate](https://github.com/hbgda/SM2ScriptTemplate).

Following Overstrike, code here is under GPLv3.
