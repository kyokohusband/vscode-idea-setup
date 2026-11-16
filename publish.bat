@echo off
setlocal
cd /d "%~dp0"

echo.
echo Before running this script:
echo   1. Create an EMPTY PUBLIC repo named vscode-idea-setup at https://github.com/new
echo   2. Do NOT check "Add a README file", .gitignore or license
echo.

set /p GHUSER=Your GitHub username: 
if "%GHUSER%"=="" (echo Username is required. & exit /b 1)

git remote remove origin >nul 2>&1
git remote add origin https://github.com/%GHUSER%/vscode-idea-setup.git
if errorlevel 1 (echo Failed to add remote. & exit /b 1)

git branch -M main
git push -u origin main

echo.
echo If prompted, sign in with your browser, or use a Personal Access Token as the password.
pause
