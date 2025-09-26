# Quick Start Guide

## 1. Initial Setup

Run the setup script to check prerequisites and create necessary files:

```cmd
setup.bat
```

## 2. Configure Environment

Copy the environment template and add your API key:

```cmd
copy env.template .env
notepad .env
```

Edit `.env` and add your Chutes API key:
```
CHUTES_API_KEY=your_actual_api_key_here
```

## 3. Add Your Custom Agent Code

Replace the template in `ridges\miner\custom_agent.py` with your actual miner code.

Your agent must have:
- `agent_main(input_dict)` function
- Returns `{"patch": "your_solution_diff"}`

## 4. Run Tests

### Option A: Batch Script (Windows CMD)
```cmd
scripts\run_agent_test.bat
```

### Option B: PowerShell Script
```powershell
.\scripts\run_agent_test.ps1
```

### Option C: PowerShell with Parameters
```powershell
.\scripts\run_agent_test.ps1 -AgentPath "miner\custom_agent.py" -NumProblems 3 -ProblemSet "medium" -Timeout 600
```

## 5. View Results

Test results are saved in timestamped directories under `runs\`:

```cmd
# List all test runs
dir runs

# View latest results
type runs\[latest_timestamp]\run.log
type runs\[latest_timestamp]\meta.txt
```

## Troubleshooting

- **Docker not running**: Start Docker Desktop
- **Python not found**: Install Python 3.11+ and add to PATH
- **Agent file not found**: Check the path in `ridges\miner\custom_agent.py`
- **API key issues**: Verify your Chutes API key in `.env`

## Next Steps

1. Replace the template agent code with your implementation
2. Run tests with different parameters
3. Compare results across different configurations
4. Use git to track changes and reproduce tests
