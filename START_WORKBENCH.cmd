@echo off
setlocal
set "PYTHONUTF8=1"
set "TI60_BUNDLE_ROOT=%~dp0release"
cd /d "%~dp0workbench"
python -B bootstrap.py
