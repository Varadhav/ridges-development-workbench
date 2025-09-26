# My Ridges Agent Workbench

Personal workbench for working with the Ridges AI agent system and running reproducible local evaluations with custom miner code.

## Prerequisites

Before using this workbench, ensure you have:

* **Python 3.11+** installed and available
* **Local ridges repository** cloned and set up in the same directory as this workbench
* **Chutes API key** configured in `ridges/proxy/.env`
* **Docker** installed and running (required for local testing)
* **Git** for version control

## Project Structure

* `scripts/` - Automation scripts for testing and evaluation  
   * `run_agent_test.bat` - Windows batch script for testing
   * `run_agent_test.ps1` - PowerShell script for testing
* `runs/` - Timestamped test results and logs (ignored by git)
* `ridges/` - Local copy of the Ridges repository
* `env.template` - Environment configuration template
* `README.md` - This documentation
* `.gitignore` - Git ignore configuration

## Getting Your Custom Miner Code

### Step 1: Prepare Your Miner Code

1. Ensure your custom miner code contains:
   * `agent_main(input_dict)` function as the main entry point
   * Proper error handling and return format: `{"patch": "...diff..."}`
   * No unauthorized outbound network calls (only proxy endpoints allowed)

### Step 2: Place Your Miner Code

1. Save your custom miner code to `ridges/miner/custom_agent.py`
2. Update the test script to use your custom agent path

### Step 3: Verify Agent Structure

Ensure your custom agent contains:

* `agent_main(input_dict)` function as the main entry point
* Proper error handling and return format: `{"patch": "...diff..."}`
* No unauthorized outbound network calls (only proxy endpoints allowed)

## Environment Configuration

The workbench includes a comprehensive environment template for easy configuration:

```cmd
# Copy the template and customize with your values
copy env.template .env

# Edit .env with your actual API keys and preferences
notepad .env
```

The template includes configuration for:

* **Chutes API Key**: Your API key from the Chutes platform
* **Testing Parameters**: Default values for agent testing
* **Docker Configuration**: Sandbox image settings
* **Development Options**: Debug mode, auto-updates, etc.

## Running Tests

### Basic Usage

```cmd
# Run with default parameters (1 easy problem, 300s timeout)
scripts\run_agent_test.bat

# Run with custom parameters
scripts\run_agent_test.bat [agent_path] [num_problems] [problem_set] [timeout]
```

### PowerShell Usage

```powershell
# Run with default parameters
.\scripts\run_agent_test.ps1

# Run with custom parameters
.\scripts\run_agent_test.ps1 -AgentPath "miner\custom_agent.py" -NumProblems 3 -ProblemSet "medium" -Timeout 600
```

### Example Commands

```cmd
# Test with defaults
scripts\run_agent_test.bat

# Test 2 medium problems with 15-minute timeout
scripts\run_agent_test.bat miner\custom_agent.py 2 medium 900

# Test 5 easy problems with default timeout
scripts\run_agent_test.bat miner\custom_agent.py 5 easy 300
```

### Parameters

* **agent_path**: Path to agent file (default: `miner\custom_agent.py`)
* **num_problems**: Number of problems to test (default: `1`)
* **problem_set**: Difficulty level - `easy`, `medium`, or `hard` (default: `easy`)
* **timeout**: Timeout per problem in seconds (default: `300`)

## Test Results and Logs

### Where Logs Are Saved

All test results are automatically saved to timestamped directories:

```
runs/
├── 20250922_143052/     # Timestamp: YYYYMMDD_HHMMSS
│   ├── meta.txt         # Test parameters and run metadata
│   ├── git_commit.txt   # Git commit info for reproducibility
│   └── run.log          # Complete test output and results
└── 20250922_150234/     # Another test run
    ├── meta.txt
    ├── git_commit.txt
    └── run.log
```

### Log Contents

* **meta.txt**: Run parameters, timestamp, agent path, problem set details
* **git_commit.txt**: Git commit hash, branch, and repository status for reproducibility
* **run.log**: Complete test execution log including:  
   * Test setup and configuration  
   * Individual problem results  
   * Performance metrics and timing  
   * Error messages and debugging info  
   * Cleanup and summary statistics

### Reading Results

```cmd
# List all test runs
dir runs

# View the last 20 lines of a specific test
type runs\[latest_timestamp]\run.log

# Check test parameters
type runs\[latest_timestamp]\meta.txt

# Review git commit info for reproducibility
type runs\[latest_timestamp]\git_commit.txt
```

## Workflow Summary

1. **Setup**: Run `setup.bat` to check prerequisites
2. **Configure**: Copy `env.template` to `.env` and add your API key
3. **Get Agent**: Place your custom miner code in `ridges\miner\custom_agent.py`
4. **Test**: Run `scripts\run_agent_test.bat` with desired parameters
5. **Review**: Check timestamped results in `runs\` directory
6. **Compare**: Use logs to compare different agents or parameter configurations
7. **Reproduce**: Git commit tracking ensures tests can be reproduced exactly

## Important Notes

### Benchmarking Purpose Only

**This workbench is designed for processing and benchmarking agents only, not for agent improvement or development.**

* Use this system to evaluate and compare different custom agents
* Measure performance across different problem sets and configurations
* Generate reproducible benchmark results for analysis
* Track agent performance over time with consistent testing

### Not for Agent Development

* Do not use this workbench for modifying or improving agent code
* Agent development should be done in dedicated development environments
* This system focuses on evaluation and comparison of existing agents

### Data and Privacy

* Test results remain local to your system
* No agent code or results are shared externally without explicit action
* Git tracking ensures full reproducibility of benchmark results
* Logs contain detailed execution information for thorough analysis

## Troubleshooting

### Common Issues

**"Agent file not found"**

* Ensure agent file exists at the specified path
* Check that the path is relative to the ridges directory

**"Docker not running"**

* Start Docker Desktop or Docker service
* Verify Docker permissions for your user

**"Python command not found"**

* Ensure Python 3.11+ is installed and accessible
* Check that Python is in your system PATH

**Test hangs at proxy startup**

* Check network connectivity to Chutes backend
* Verify API key is correctly configured in `ridges\proxy\.env`
* Ensure no firewall blocking required connections

### Getting Help

If you encounter issues:

1. Check the complete logs in `runs\[timestamp]\run.log`
2. Verify all prerequisites are properly installed
3. Ensure the ridges repository is properly set up
4. Confirm your Chutes API key is valid and correctly configured

## Version History

* **v0.1.0**: Initial release with automated testing wrapper and comprehensive logging

## Agent Source

**Agent Used**: Your custom miner agent  
**Source**: Custom implementation  
**Location**: `ridges\miner\custom_agent.py`  
**Function**: `agent_main(input_dict)` returning `{"patch": "..."}`

## About

Local testing environment for Ridges agents with Chutes integration and custom miner code.
