@echo off
setlocal EnableExtensions EnableDelayedExpansion

set "PROJECT=C:\Users\Abdul Muhymin Wani\Documents\Flutter_Projects\al_amin_2"
set "PATCH=%~dp0sync_firestore_service_low_read.dart"
set "TARGET=%PROJECT%\lib\database\sync_firestore_service.dart"

if not exist "%PROJECT%" (
  echo ERROR: Project folder not found:
  echo %PROJECT%
  pause
  exit /b 1
)

if not exist "%PATCH%" (
  echo ERROR: Patch file not found:
  echo %PATCH%
  pause
  exit /b 1
)

if not exist "%TARGET%" (
  echo ERROR: Target sync file not found:
  echo %TARGET%
  pause
  exit /b 1
)

for /f %%I in ('powershell -NoProfile -Command "Get-Date -Format yyyyMMdd_HHmmss"') do set "STAMP=%%I"
set "BACKUP=%PROJECT%\backup_before_firestore_low_read_!STAMP!"

mkdir "%BACKUP%" >nul 2>&1
if errorlevel 1 (
  echo ERROR: Could not create backup folder:
  echo %BACKUP%
  pause
  exit /b 1
)

copy /Y "%TARGET%" "%BACKUP%\sync_firestore_service.dart" >nul
if errorlevel 1 (
  echo ERROR: Could not back up the current sync file.
  pause
  exit /b 1
)

echo.
echo Backup created:
echo %BACKUP%
echo.
echo Installing low-read Firestore sync file...
copy /Y "%PATCH%" "%TARGET%" >nul
if errorlevel 1 (
  echo ERROR: Could not install the patch.
  echo The original file is preserved in:
  echo %BACKUP%
  pause
  exit /b 1
)

pushd "%PROJECT%"

echo.
echo Running flutter clean...
call flutter clean
if errorlevel 1 goto :fail

echo.
echo Running flutter pub get...
call flutter pub get
if errorlevel 1 goto :fail

echo.
echo Running flutter analyze...
call flutter analyze > analyze_after_low_read.txt 2>&1
set "ANALYZE_RC=%ERRORLEVEL%"

echo.
echo ========================================
echo Patch installation complete.
echo ========================================
echo.
echo New sync file:
echo %TARGET%
echo Backup:
echo %BACKUP%
echo Analyze report:
echo %PROJECT%\analyze_after_low_read.txt

echo.
echo flutter analyze exit code: %ANALYZE_RC%
if not "%ANALYZE_RC%"=="0" echo Analyze reported issues. Open analyze_after_low_read.txt before building.
popd
pause
exit /b %ANALYZE_RC%

:fail
popd
echo.
echo ERROR: Flutter command failed.
echo The original sync file remains backed up at:
echo %BACKUP%
pause
exit /b 1
