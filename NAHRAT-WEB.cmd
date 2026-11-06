@echo off
chcp 65001 >nul
setlocal EnableDelayedExpansion
title EditTwin - nahrat prezentaci na web
cd /d C:\edittwin\prezentace-web

set "REPO=https://github.com/axionyx078-png/edittwin-web.git"
set "WEB=https://axionyx078-png.github.io/edittwin-web/"

echo ==============================================
echo   EditTwin - nahrat prezentaci na web
echo   (GitHub Pages, repozitar edittwin-web)
echo ==============================================
echo.

if not exist ".git" (
  echo Prvni spusteni - zakladam git v teto slozce...
  git init >nul
  git checkout -b main >nul 2>&1
  git remote add origin %REPO%
  echo.
)

git add .
git diff --cached --quiet
if not errorlevel 1 (
  echo Nic noveho k nahrani - web uz je aktualni.
  echo Adresa: %WEB%
  pause
  exit /b 0
)

for /f %%d in ('powershell -NoProfile -Command "Get-Date -Format yyyy-MM-dd_HH-mm"') do set "MSG=prezentace %%d"
set "MSGFILE=%TEMP%\edittwin-web-commit-msg.txt"
> "!MSGFILE!" echo(!MSG!
git commit -F "!MSGFILE!"
if errorlevel 1 (
  echo.
  echo Commit se nepovedl - precti chybu nahore.
  pause
  exit /b 1
)

git push -u origin main
if errorlevel 1 (
  echo.
  echo Push se nepovedl - precti chybu nahore. Nejcastejsi duvody:
  echo  1. na GitHubu jeste neexistuje repozitar edittwin-web (zaloz ho: github.com/new, jmeno edittwin-web, Public)
  echo  2. internet, nebo prihlaseni na GitHub
  echo Soubory jsou ulozene mistne - az to pujde, spust tohle znovu.
  pause
  exit /b 1
)

echo.
echo Hotovo - prezentace je na GitHubu.
echo Po prvnim nahrani jeste zapni Pages: github.com/axionyx078-png/edittwin-web/settings/pages
echo   Source: Deploy from a branch, Branch: main, / (root), Save
echo Pak za 1-2 minuty bezi: %WEB%
pause
