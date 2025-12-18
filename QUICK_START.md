# Azure Dependency Checker - Quick Start

## 🚀 Get Started in 3 Steps

### Step 1: Choose Your Tool

| Tool | When to Use | Location |
|------|-------------|----------|
| **Python (Full-Featured)** | Complete dependency analysis, automation, CI/CD | `/workspace/Python/` |
| **Azure CLI (Lightweight)** | Quick checks, no Python needed | `/workspace/Az Cli/check_dependencies.azcli` |
| **Automation Scripts** | One-command execution | `/workspace/Python/run_dependency_check.sh` or `.ps1` |

### Step 2: Quick Setup

**Python Solution:**
```bash
cd /workspace/Python
pip install -r requirements.txt
az login
```

**Edit subscription ID:**
- Open `check_azure_dependencies.py`
- Replace `<enter subscription id>` with your subscription ID

### Step 3: Run It

**Option A - Full Analysis:**
```bash
python check_azure_dependencies.py
```

**Option B - Automation Script (Linux/Mac):**
```bash
./run_dependency_check.sh
```

**Option C - Automation Script (Windows):**
```powershell
.\run_dependency_check.ps1
```

**Option D - Azure CLI Only:**
```bash
cd "/workspace/Az Cli"
# Edit subscription_id in check_dependencies.azcli first
. ./check_dependencies.azcli  # PowerShell
```

## 📊 What You'll Get

```
🔍 Dependency Analysis
  ↓
📋 Detailed Report showing:
  • Which resources depend on what
  • Which resources others depend on
  • Safe deletion order
  • Resource locks
  ↓
📄 JSON Export (optional)
  • Use in other tools
  • CI/CD integration
```

## 🎯 Common Tasks

### Check Dependencies Before Deleting a Resource

```python
from check_azure_dependencies import AzureDependencyChecker

checker = AzureDependencyChecker(["your-subscription-id"])
result = checker.check_resource_can_be_deleted(
    "/subscriptions/.../providers/Microsoft.Network/publicIPAddresses/pip-name"
)

print(f"Safe to delete? {result['can_delete_safely']}")
```

### Get Safe Deletion Order for Resource Group

```python
checker = AzureDependencyChecker(["your-subscription-id"])
checker.print_dependency_report(resource_group="rg-test")
```

### Safely Destroy Resources (Dry Run)

```python
from safe_destroy_resources import SafeResourceDestroyer

destroyer = SafeResourceDestroyer(
    subscription_id="your-id",
    dry_run=True  # Set False to actually destroy
)
destroyer.destroy_resources_safely(resource_group="rg-test")
```

## 📚 More Info

- **Detailed Guide**: See `README_DEPENDENCIES.md`
- **Complete Solution**: See `AZURE_DEPENDENCY_SOLUTION.md`
- **Examples**: All scripts have inline documentation

## ⚠️ Important Notes

1. **Always test with dry-run first** before making changes
2. **Backup important resources** before deletion
3. **Check for resource locks** - they prevent deletion
4. **Review the dependency report** carefully before proceeding

## 🛠️ Configuration Files

| File | Purpose |
|------|---------|
| `requirements.txt` | Python dependencies |
| `config.json.example` | Configuration template |
| `check_azure_dependencies.py` | Main dependency checker |
| `safe_destroy_resources.py` | Safe resource destroyer |
| `run_dependency_check.sh` | Bash automation |
| `run_dependency_check.ps1` | PowerShell automation |

## 🔧 Troubleshooting

**"Resource Graph not registered"**
```bash
az provider register --namespace Microsoft.ResourceGraph
```

**"Not authenticated"**
```bash
az login
```

**"Permission denied"**
- Ensure you have Reader role on subscription
- Check: `az role assignment list --assignee <your-email>`

## 📞 Need Help?

1. Check `README_DEPENDENCIES.md` for detailed documentation
2. Review `AZURE_DEPENDENCY_SOLUTION.md` for use cases
3. Check inline comments in the Python scripts

---

**Ready to go!** Start with a dry-run to see what the tool does:
```bash
cd /workspace/Python
python check_azure_dependencies.py
```
