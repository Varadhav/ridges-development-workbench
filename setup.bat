@echo off
echo ==========================================
echo Ridges Agent Workbench Setup
echo ==========================================
echo.

REM Check if Python is installed
echo Checking Python installation...
python --version >nul 2>&1
if errorlevel 1 (
    echo ERROR: Python is not installed or not in PATH
    echo Please install Python 3.11+ and try again
    pause
    exit /b 1
) else (
    echo Python is installed
)

REM Check if Docker is installed and running
echo Checking Docker installation...
docker --version >nul 2>&1
if errorlevel 1 (
    echo ERROR: Docker is not installed or not in PATH
    echo Please install Docker Desktop and try again
    pause
    exit /b 1
) else (
    echo Docker is installed
)

docker info >nul 2>&1
if errorlevel 1 (
    echo WARNING: Docker is installed but not running
    echo Please start Docker Desktop and try again
    pause
    exit /b 1
) else (
    echo Docker is running
)

REM Create .env file from template if it doesn't exist
if not exist ".env" (
    echo Creating .env file from template...
    copy "env.template" ".env"
    echo .env file created. Please edit it with your actual API keys.
) else (
    echo .env file already exists
)

REM Create runs directory if it doesn't exist
if not exist "runs" mkdir "runs"

REM Check if ridges directory exists
if not exist "ridges" (
    echo WARNING: ridges directory not found
    echo Please clone the ridges repository into this directory
    echo or create the necessary structure manually
) else (
    echo ridges directory found
)

echo.
echo ==========================================
echo Setup Complete!
echo ==========================================
echo.
echo Next steps:
echo 1. Edit .env file with your Chutes API key
echo 2. Place your custom agent code in ridges\miner\custom_agent.py
echo 3. Run tests using: scripts\run_agent_test.bat
echo.
echo For more information, see README.md
echo.

pause
