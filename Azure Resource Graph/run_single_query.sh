#!/bin/bash
# Run a single Azure Resource Graph query

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

if [ -z "$1" ] || [ -z "$2" ]; then
    echo -e "${YELLOW}Usage: $0 <query-file> <subscription-id> [resource-group]${NC}"
    echo ""
    echo "Examples:"
    echo "  $0 02_vm_dependencies.kql 12345678-1234-1234-1234-123456789012"
    echo "  $0 10_deletion_order.kql 12345678-1234-1234-1234-123456789012 rg-eus2-001"
    echo ""
    echo "Available queries:"
    ls -1 queries/*.kql | xargs -n 1 basename | sed 's/^/  /'
    exit 1
fi

QUERY_FILE=$1
SUBSCRIPTION_ID=$2
RESOURCE_GROUP=${3:-""}

# Add .kql extension if not provided
if [[ $QUERY_FILE != *.kql ]]; then
    QUERY_FILE="${QUERY_FILE}.kql"
fi

QUERY_PATH="queries/$QUERY_FILE"

if [ ! -f "$QUERY_PATH" ]; then
    echo -e "${YELLOW}Error: Query file not found: $QUERY_PATH${NC}"
    exit 1
fi

echo -e "${GREEN}Running: $QUERY_FILE${NC}\n"

# Read query
query=$(cat "$QUERY_PATH")

# Modify query if resource group is specified
if [ -n "$RESOURCE_GROUP" ]; then
    query="${query//YOUR_RESOURCE_GROUP/$RESOURCE_GROUP}"
    if [[ $query != *"where resourceGroup"* ]]; then
        query=$(echo "$query" | sed "2i| where resourceGroup == '$RESOURCE_GROUP'")
    fi
fi

# Run query
az graph query -q "$query" --subscriptions "$SUBSCRIPTION_ID" --output table

echo ""
echo -e "${GREEN}✓ Query complete${NC}"
echo ""
echo -e "${BLUE}To export to JSON:${NC}"
echo -e "  az graph query -q \"\$(cat $QUERY_PATH)\" --subscriptions $SUBSCRIPTION_ID --output json > output.json"
