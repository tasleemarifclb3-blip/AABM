@echo off
setlocal
cd /d "%~dp0"

if not exist "web" mkdir "web"

echo.
echo === Al-Amin Drift Web setup ===
echo.

echo [1/3] Downloading sqlite3.wasm compatible with sqlite3 3.5.2...
curl.exe -L --fail --retry 3 -o "web\sqlite3.wasm" "https://github.com/simolus3/sqlite3.dart/releases/download/sqlite3-3.5.2/sqlite3.wasm"
if errorlevel 1 (
  echo ERROR: sqlite3.wasm download failed.
  exit /b 1
)

echo [2/3] Compiling Drift web worker...
dart compile js -O4 --no-source-maps web\drift_worker.dart -o web\drift_worker.dart.js
if errorlevel 1 (
  echo ERROR: Drift worker compilation failed.
  exit /b 1
)

echo [3/3] Checking files...
if not exist "web\sqlite3.wasm" exit /b 1
if not exist "web\drift_worker.dart.js" exit /b 1

echo.
echo SUCCESS: Drift web files are ready.
echo.
echo Next run:
echo   flutter pub get
echo   flutter run -d chrome
endlocal
