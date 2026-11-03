#!/usr/bin/env bash


RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Thresholds
THRESHOLD=80

echo -e "${BLUE}====================================${NC}"
echo -e "${BLUE}       SYSTEM HEALTH MONITOR        ${NC}"
echo -e "${BLUE}====================================${NC}"

# Get Disk Usage of root partition
DISK_USAGE=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')
echo -e "Current Disk Usage: ${DISK_USAGE}%"

# Check threshold
if [ "$DISK_USAGE" -gt "$THRESHOLD" ]; then
    echo -e "${RED}[WARNING] Disk usage is above ${THRESHOLD}%! Consider clearing space.${NC}"
else
    echo -e "${GREEN}[OK] Disk space is within safe limits.${NC}"
fi

echo -e "${BLUE}------------------------------------${NC}"

# Display Memory Info
echo "Memory Usage:"
if command -v free &> /dev/null; then
    # Linux system
    free -h | awk 'NR==1 || NR==2'
elif command -v vm_stat &> /dev/null; then
    # macOS system
    top -l 1 -s 0 | grep -E "PhysMem"
else
    echo "Memory stats unavailable."
fi

echo -e "${BLUE}====================================${NC}"
