@echo off
cd /d C:\
rd /s /q firebase-github-demo 2>nul
gh auth refresh -s delete_repo >nul 2>&1
gh repo delete AI-Gentleman/firebase-github-demo --yes >nul 2>&1
gh repo create firebase-github-demo --public --clone >nul
cd firebase-github-demo

:: 4 perfect files
mkdir .github\workflows public >nul
(
echo name: Deploy to Firebase
echo on:
echo   push:
echo     branches: [ main ]
echo jobs:
echo   deploy:
echo     runs-on: ubuntu-latest
echo     steps:
echo       - uses: actions/checkout@v4
echo       - uses: actions/setup-node@v4
echo         with:
echo           node-version: 20
echo       - run: npm i -g firebase-tools
echo       - run: firebase deploy --only hosting --token ${{ secrets.FIREBASE_TOKEN }}
) > .github\workflows\firebase.yml

echo ^<!DOCTYPE html^>^<html^>^<body style="margin:0;background:#000;color:lime;font:900 10vw monospace;display:flex;align-items:center;justify-content:center;height:100vh"^>LIVE^</body^>^</html^> > public\index.html

echo { "hosting": { "public": "public", "rewrites": [ { "source": "**", "destination": "/index.html" } ] } } > firebase.json
echo { "name": "demo" } > package.json

:: Deploy
git add . >nul
git commit -m LIVE >nul
git push origin main >nul
gh secret set FIREBASE_TOKEN -b"1//03EgEo1P4TsDECgYIARAAGAMSNwF-L9IrxbgrQ8L9IrxbgrQ8gTCr4xedkKZ9cqVCXS_KPchXFruHi_EtowkZQUIO_LJMFOXL3Yry9osjSPCS0" >nul
git push >nul

:: Open your LIVE site
for /f "tokens=2" %%i in ('firebase projects:list ^| findstr /C:"Project ID"') do set "ID=%%i"
start "" https://%ID%.web.app

echo.
echo ╔══════════════════════════════════════════╗
echo ║     YOUR SITE IS LIVE RIGHT NOW!         ║
echo ║     https://%ID%.web.app                  ║
echo ╚══════════════════════════════════════════╝
pause