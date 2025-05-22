@echo off
echo ===================================================
echo    Upload DevDashboard to GitHub
echo ===================================================
echo.

cd "C:\Users\Bdog3\Desktop\DevDashboard - A Github API Intergration Tool"

REM Check if Git is installed
where git >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo Git is not installed or not in your PATH.
    echo Please install Git from https://git-scm.com/downloads
    pause
    exit /b 1
)

REM Initialize Git repository if not already initialized
if not exist .git (
    echo Initializing Git repository...
    git init
    if %ERRORLEVEL% NEQ 0 (
        echo Failed to initialize Git repository.
        pause
        exit /b 1
    )
)

REM Create .gitignore file if it doesn't exist
if not exist .gitignore (
    echo Creating .gitignore file...
    echo # Gradle files > .gitignore
    echo .gradle/ >> .gitignore
    echo build/ >> .gitignore
    echo !gradle/wrapper/gradle-wrapper.jar >> .gitignore
    echo # IDE files >> .gitignore
    echo .idea/ >> .gitignore
    echo *.iml >> .gitignore
    echo .vscode/ >> .gitignore
    echo # Compiled class files >> .gitignore
    echo *.class >> .gitignore
    echo # Log files >> .gitignore
    echo *.log >> .gitignore
    echo # Package files >> .gitignore
    echo *.jar >> .gitignore
    echo *.war >> .gitignore
    echo *.ear >> .gitignore
    echo # Other >> .gitignore
    echo .DS_Store >> .gitignore
)

REM Add all files to Git
echo Adding files to Git...
git add .
if %ERRORLEVEL% NEQ 0 (
    echo Failed to add files to Git.
    pause
    exit /b 1
)

REM Commit changes
echo.
echo Committing changes...
set /p commit_message="Enter commit message (or press Enter for default message): "
if "%commit_message%"=="" set commit_message="Initial commit of DevDashboard - GitHub API Integration Tool"

git commit -m "%commit_message%"
if %ERRORLEVEL% NEQ 0 (
    echo Failed to commit changes.
    pause
    exit /b 1
)

REM Check if remote origin exists
git remote -v | findstr origin >nul
if %ERRORLEVEL% NEQ 0 (
    echo.
    echo No remote repository is configured.
    echo Please create a new repository on GitHub and enter the URL below.
    echo Example: https://github.com/yourusername/DevDashboard.git
    echo.
    
    set repo_url=
    set /p repo_url="Enter GitHub repository URL: "
    
    if "%repo_url%"=="" (
        echo No repository URL provided.
        pause
        exit /b 1
    )
    
    echo Adding remote repository: %repo_url%
    git remote add origin %repo_url%
    if %ERRORLEVEL% NEQ 0 (
        echo Failed to add remote repository.
        pause
        exit /b 1
    )
)

REM Push to GitHub
echo.
echo Pushing to GitHub...
git push -u origin master
if %ERRORLEVEL% NEQ 0 (
    echo.
    echo Failed to push to GitHub. Trying with 'main' branch instead...
    git push -u origin main
    if %ERRORLEVEL% NEQ 0 (
        echo.
        echo Failed to push to GitHub.
        echo You might need to:
        echo 1. Check your internet connection
        echo 2. Verify your GitHub credentials
        echo 3. Ensure the repository exists on GitHub
        pause
        exit /b 1
    )
)

echo.
echo ===================================================
echo Success! Your project has been uploaded to GitHub.
echo ===================================================
echo.
pause