@echo off
chcp 65001 >nul
cd /d "%~dp0"
python "%~dp0src\usbi_xlsx_gui.py"
if errorlevel 1 pause
