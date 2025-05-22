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
REM Don't exit if commit fails - it might just mean there's nothing to commit

REM Check if remote origin exists
git remote -v | findstr origin >nul
if %ERRORLEVEL% NEQ 0 (
    echo.
    echo No remote repository is configured.
    echo Please create a new repository on GitHub and enter the URL below.
    echo Example: https://github.com/yourusername/DevDashboard.git
    echo.
    
    REM Use a hardcoded URL since the input is not working
    set repo_url=https://github.com/BradyM37/DevDashboard.git
    echo Using repository URL: %repo_url%
    
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

REM Try pushing to master branch
echo Trying to push to master branch...
git push -u origin master
if %ERRORLEVEL% NEQ 0 (
    echo.
    echo Failed to push to master branch. Trying with 'main' branch...
    
    REM Try pushing to main branch
    git push -u origin main
    if %ERRORLEVEL% NEQ 0 (
        echo.
        echo Failed to push to main branch. Creating main branch and trying again...
        
        REM Create main branch and push
        git checkout -b main
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
)

echo.
echo ===================================================
echo Success! Your project has been uploaded to GitHub.
echo ===================================================
echo.
pause