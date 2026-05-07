@echo off

set "scriptName=PaddingFormatNum.ps1"

pushd %~dp0
PowerShell -ExecutionPolicy bypass -noprofile -File .\%scriptName%
popd & pause
exit /b