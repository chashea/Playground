#!/bin/bash
# Quick script to run dependency checks on Azure resources

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}================================${NC}"
echo -e "${GREEN}Azure Dependency Checker${NC}"
echo -e "${GREEN}================================${NC}\n"

# Check if Python is installed
if ! command -v python3 &> /dev/null; then
    echo -e "${RED}Error: Python 3 is not installed${NC}"
    exit 1
fi

# Check if Azure CLI is installed
if ! command -v az &> /dev/null; then
    echo -e "${YELLOW}Warning: Azure CLI not found. Make sure you have valid Azure credentials.${NC}"
fi

# Check if virtual environment exists
if [ ! -d "venv" ]; then
    echo -e "${YELLOW}Creating virtual environment...${NC}"
    python3 -m venv venv
fi

# Activate virtual environment
source venv/bin/activate

# Install/upgrade dependencies
echo -e "${GREEN}Installing dependencies...${NC}"
pip install -q --upgrade pip
pip install -q -r requirements.txt

# Check if user is logged in to Azure (if Azure CLI is available)
if command -v az &> /dev/null; then
    if ! az account show &> /dev/null; then
        echo -e "${YELLOW}Not logged in to Azure. Running 'az login'...${NC}"
        az login
    else
        echo -e "${GREEN}✓ Azure authentication verified${NC}"
    fi
fi

# Parse command line arguments
RESOURCE_GROUP=""
EXPORT_JSON=false
DRY_RUN=true

while [[ $# -gt 0 ]]; do
    case $1 in
        -g|--resource-group)
            RESOURCE_GROUP="$2"
            shift 2
            ;;
        -e|--export)
            EXPORT_JSON=true
            shift
            ;;
        --live)
            DRY_RUN=false
            shift
            ;;
        -h|--help)
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  -g, --resource-group NAME    Check specific resource group"
            echo "  -e, --export                 Export results to JSON"
            echo "  --live                       Run in live mode (make actual changes)"
            echo "  -h, --help                   Show this help message"
            echo ""
            echo "Examples:"
            echo "  $0                                    # Check all resources (dry run)"
            echo "  $0 -g rg-eus2-001                    # Check specific resource group"
            echo "  $0 -g rg-eus2-001 -e                 # Check and export to JSON"
            echo "  $0 -g rg-eus2-001 --live             # Actually destroy resources"
            exit 0
            ;;
        *)
            echo -e "${RED}Unknown option: $1${NC}"
            echo "Use -h or --help for usage information"
            exit 1
            ;;
    esac
done

# Run the dependency checker
echo -e "\n${GREEN}Running dependency check...${NC}\n"

if [ "$DRY_RUN" = true ]; then
    python3 check_azure_dependencies.py
else
    echo -e "${RED}⚠️  WARNING: Running in LIVE mode!${NC}"
    read -p "Are you sure you want to proceed? (yes/no): " confirm
    if [ "$confirm" != "yes" ]; then
        echo -e "${YELLOW}Operation cancelled${NC}"
        exit 0
    fi
    python3 safe_destroy_resources.py
fi

# Export to JSON if requested
if [ "$EXPORT_JSON" = true ]; then
    echo -e "\n${GREEN}Results exported to azure_dependencies.json${NC}"
fi

echo -e "\n${GREEN}✓ Dependency check complete!${NC}\n"

# Deactivate virtual environment
deactivate
