@echo off
echo ===================================================
echo    DevDashboard - GitHub API Integration Tool
echo ===================================================
echo.
echo Building application...
cd "C:\Users\Bdog3\Desktop\DevDashboard - A Github API Intergration Tool"

call gradlew clean build
if %ERRORLEVEL% NEQ 0 (
    echo.
    echo Build failed! Please check the errors above.
    echo.
    pause
    exit /b %ERRORLEVEL%
)

echo.
echo Starting DevDashboard application...
echo.
echo The application will open in your default browser shortly.
echo To stop the application, press Ctrl+C in this window.
echo.

start "" http://localhost:8080

echo Application starting...
echo.

call gradlew bootRun

pause