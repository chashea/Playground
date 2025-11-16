#!/bin/bash
# Run all Azure Resource Graph queries for dependency checking

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Check if subscription ID is provided
if [ -z "$1" ]; then
    echo -e "${YELLOW}Usage: $0 <subscription-id> [resource-group]${NC}"
    echo ""
    echo "Examples:"
    echo "  $0 12345678-1234-1234-1234-123456789012"
    echo "  $0 12345678-1234-1234-1234-123456789012 rg-eus2-001"
    exit 1
fi

SUBSCRIPTION_ID=$1
RESOURCE_GROUP=${2:-""}

echo -e "${GREEN}================================${NC}"
echo -e "${GREEN}Azure Resource Graph Query Runner${NC}"
echo -e "${GREEN}================================${NC}\n"
echo -e "${BLUE}Subscription ID: ${SUBSCRIPTION_ID}${NC}"
if [ -n "$RESOURCE_GROUP" ]; then
    echo -e "${BLUE}Resource Group: ${RESOURCE_GROUP}${NC}"
fi
echo ""

# Check if Azure CLI is installed
if ! command -v az &> /dev/null; then
    echo -e "${YELLOW}Error: Azure CLI is not installed${NC}"
    exit 1
fi

# Check if logged in
if ! az account show &> /dev/null; then
    echo -e "${YELLOW}Not logged in. Running 'az login'...${NC}"
    az login
fi

# Set subscription
az account set --subscription "$SUBSCRIPTION_ID"

# Check if Resource Graph extension is installed
if ! az extension list --query "[?name=='resource-graph']" -o tsv &> /dev/null; then
    echo -e "${YELLOW}Installing Resource Graph extension...${NC}"
    az extension add --name resource-graph
fi

# Create output directory
OUTPUT_DIR="output/$(date +%Y%m%d_%H%M%S)"
mkdir -p "$OUTPUT_DIR"

echo -e "\n${GREEN}Running queries...${NC}\n"

# Array of query files with descriptions
declare -A queries
queries=(
    ["01_all_dependencies.kql"]="All Resources with Dependencies"
    ["02_vm_dependencies.kql"]="Virtual Machine Dependencies"
    ["03_network_dependencies.kql"]="Network Resource Dependencies"
    ["04_nic_dependencies.kql"]="Network Interface Dependencies"
    ["05_disk_dependencies.kql"]="Managed Disk Dependencies"
    ["06_public_ip_dependencies.kql"]="Public IP Address Dependencies"
    ["07_vnet_dependencies.kql"]="Virtual Network Dependencies"
    ["08_resource_locks.kql"]="Resource Locks"
    ["09_unused_resources.kql"]="Potentially Unused Resources"
    ["10_deletion_order.kql"]="Resource Deletion Order"
    ["11_firewall_dependencies.kql"]="Azure Firewall Dependencies"
    ["12_bastion_dependencies.kql"]="Azure Bastion Dependencies"
    ["13_storage_dependencies.kql"]="Storage Account Dependencies"
    ["14_cross_resource_group_deps.kql"]="Cross-Resource Group Dependencies"
    ["15_resource_summary.kql"]="Resource Summary by Type"
)

# Run each query
for query_file in "${!queries[@]}"; do
    description="${queries[$query_file]}"
    query_path="queries/$query_file"
    output_file="$OUTPUT_DIR/${query_file%.kql}.json"
    
    if [ ! -f "$query_path" ]; then
        echo -e "${YELLOW}⚠ Skipping $query_file - file not found${NC}"
        continue
    fi
    
    echo -e "${BLUE}Running: ${description}${NC}"
    
    # Modify query if resource group is specified
    if [ -n "$RESOURCE_GROUP" ] && [ "$query_file" != "08_resource_locks.kql" ]; then
        query=$(cat "$query_path")
        # Add resource group filter after the first line
        modified_query="$query"
        if [[ $query != *"resourceGroup"* ]] || [[ $query != *"YOUR_RESOURCE_GROUP"* ]]; then
            modified_query=$(echo "$query" | sed "2i| where resourceGroup == '$RESOURCE_GROUP'")
        else
            # Replace YOUR_RESOURCE_GROUP placeholder
            modified_query="${query//YOUR_RESOURCE_GROUP/$RESOURCE_GROUP}"
        fi
        
        az graph query -q "$modified_query" \
            --subscriptions "$SUBSCRIPTION_ID" \
            --output json > "$output_file" 2>/dev/null || echo "{\"error\": \"Query failed\"}" > "$output_file"
    else
        # Replace placeholder if it exists
        query=$(cat "$query_path")
        query="${query//YOUR_RESOURCE_GROUP/$RESOURCE_GROUP}"
        
        az graph query -q "$query" \
            --subscriptions "$SUBSCRIPTION_ID" \
            --output json > "$output_file" 2>/dev/null || echo "{\"error\": \"Query failed\"}" > "$output_file"
    fi
    
    # Check if query returned results
    result_count=$(jq -r '.data | length' "$output_file" 2>/dev/null || echo "0")
    echo -e "  ✓ Results: ${result_count} records → ${output_file}\n"
done

echo -e "${GREEN}================================${NC}"
echo -e "${GREEN}✓ All queries complete!${NC}"
echo -e "${GREEN}================================${NC}\n"
echo -e "${BLUE}Results saved to: ${OUTPUT_DIR}/${NC}\n"

# Generate summary report
echo -e "${GREEN}Generating summary report...${NC}"
cat > "$OUTPUT_DIR/SUMMARY.md" << EOF
# Azure Resource Dependency Report
Generated: $(date)
Subscription: $SUBSCRIPTION_ID
$([ -n "$RESOURCE_GROUP" ] && echo "Resource Group: $RESOURCE_GROUP")

## Query Results

EOF

for query_file in "${!queries[@]}"; do
    description="${queries[$query_file]}"
    output_file="$OUTPUT_DIR/${query_file%.kql}.json"
    result_count=$(jq -r '.data | length' "$output_file" 2>/dev/null || echo "0")
    
    echo "- **${description}**: ${result_count} results" >> "$OUTPUT_DIR/SUMMARY.md"
done

echo -e "\n${GREEN}✓ Summary report: ${OUTPUT_DIR}/SUMMARY.md${NC}\n"
