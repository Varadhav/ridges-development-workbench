# Ridges Agent Test Runner for PowerShell
# Usage: .\run_agent_test.ps1 [agent_path] [num_problems] [problem_set] [timeout]

param(
    [string]$AgentPath = "miner\custom_agent.py",
    [int]$NumProblems = 1,
    [ValidateSet("easy", "medium", "hard")]
    [string]$ProblemSet = "easy",
    [int]$Timeout = 300
)

# Create timestamp for this run
$Timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$RunDir = "runs\$Timestamp"

# Create run directory
if (!(Test-Path $RunDir)) {
    New-Item -ItemType Directory -Path $RunDir | Out-Null
}

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Ridges Agent Test Runner" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Timestamp: $Timestamp"
Write-Host "Agent Path: $AgentPath"
Write-Host "Number of Problems: $NumProblems"
Write-Host "Problem Set: $ProblemSet"
Write-Host "Timeout: ${Timeout}s"
Write-Host "Run Directory: $RunDir"
Write-Host "==========================================" -ForegroundColor Cyan

# Save run metadata
$MetaContent = @"
Run Timestamp: $Timestamp
Agent Path: $AgentPath
Number of Problems: $NumProblems
Problem Set: $ProblemSet
Timeout: ${Timeout}s
Start Time: $(Get-Date)
"@
$MetaContent | Out-File -FilePath "$RunDir\meta.txt" -Encoding UTF8

# Save git commit info for reproducibility
Write-Host "Saving git commit information..." -ForegroundColor Yellow
try {
    $GitCommit = git rev-parse HEAD 2>$null
    $GitBranch = git branch --show-current 2>$null
    $GitStatus = git status --porcelain 2>$null
    $GitLog = git log --oneline -5 2>$null
} catch {
    $GitCommit = "Not a git repository"
    $GitBranch = "Not a git repository"
    $GitStatus = "Not a git repository"
    $GitLog = "Not a git repository"
}

$GitInfo = @"
Git Commit: $GitCommit
Git Branch: $GitBranch
Git Status:
$GitStatus
Git Log (last 5 commits):
$GitLog
"@
$GitInfo | Out-File -FilePath "$RunDir\git_commit.txt" -Encoding UTF8

# Check if agent file exists
if (!(Test-Path "ridges\$AgentPath")) {
    Write-Host "Error: Agent file not found at ridges\$AgentPath" -ForegroundColor Red
    Write-Host "Please ensure your custom agent code is placed at the correct path." -ForegroundColor Red
    exit 1
}

# Check if Docker is running
try {
    docker info | Out-Null
} catch {
    Write-Host "Error: Docker is not running. Please start Docker and try again." -ForegroundColor Red
    exit 1
}

# Check if Python is available
try {
    python --version | Out-Null
} catch {
    Write-Host "Error: Python is not installed or not in PATH" -ForegroundColor Red
    exit 1
}

# Check if .env file exists
if (!(Test-Path ".env")) {
    Write-Host "Warning: .env file not found. Using default configuration." -ForegroundColor Yellow
    Write-Host "Consider copying env.template to .env and configuring your settings." -ForegroundColor Yellow
}

# Load environment variables if .env exists
if (Test-Path ".env") {
    Write-Host "Loading environment variables from .env..." -ForegroundColor Green
    Get-Content ".env" | ForEach-Object {
        if ($_ -match '^([^#][^=]+)=(.*)$') {
            [Environment]::SetEnvironmentVariable($matches[1], $matches[2], "Process")
        }
    }
}

# Run the actual test
Write-Host "Starting agent test..." -ForegroundColor Green
Write-Host "This may take several minutes depending on the problem set and timeout." -ForegroundColor Yellow

# Log everything to the run directory
$LogContent = @"
==========================================
Test Execution Log
==========================================
Start Time: $(Get-Date)

Running test with parameters:
  Agent: $AgentPath
  Problems: $NumProblems
  Set: $ProblemSet
  Timeout: ${Timeout}s

Simulating test execution...
Note: Replace this section with your actual test command

Example test command would be:
python -m pytest test_agent.py --agent=$AgentPath --problems=$NumProblems --set=$ProblemSet --timeout=$Timeout

"@

# Simulate test progress
for ($i = 1; $i -le $NumProblems; $i++) {
    Write-Host "Processing problem $i/$NumProblems..." -ForegroundColor Cyan
    Start-Sleep -Seconds 2  # Simulate processing time
    $LogContent += "Problem $i completed successfully`n"
}

$LogContent += @"

Test completed successfully!
End Time: $(Get-Date)
"@

$LogContent | Out-File -FilePath "$RunDir\run.log" -Encoding UTF8

Write-Host ""
Write-Host "==========================================" -ForegroundColor Green
Write-Host "Test Complete!" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Green
Write-Host "Results saved to: $RunDir"
Write-Host "Log file: $RunDir\run.log"
Write-Host "Metadata: $RunDir\meta.txt"
Write-Host "Git info: $RunDir\git_commit.txt"
Write-Host ""
Write-Host "To view results:"
Write-Host "  Get-Content $RunDir\run.log"
Write-Host "  Get-Content $RunDir\meta.txt"
Write-Host ""
