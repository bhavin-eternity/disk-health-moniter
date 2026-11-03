#!/usr/bin/env bash


RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Thresholds
THRESHOLD=80
LOG_FILE="system_health.log"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

echo -e "${BLUE}====================================${NC}"
echo -e "${BLUE}       SYSTEM HEALTH MONITOR        ${NC}"
echo -e "${BLUE}====================================${NC}"

# Get Disk Usage of root partition
DISK_USAGE=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')
echo -e "Current Disk Usage: ${DISK_USAGE}%" >> "$LOG_FILE"

# Check threshold
if [ "$DISK_USAGE" -gt "$THRESHOLD" ]; then
    MSG="[WARNING] Disk usage is above ${THRESHOLD}%! Consider clearing space."
    echo -e "${RED}$MSG${NC}"
    echo "$MSG" >> "$LOG_FILE"
else
    MSG="[OK] Disk space is within safe limits."
    echo -e "${GREEN}$MSG${NC}"
    echo "$MSG" >> "$LOG_FILE"
fi

echo -e "${BLUE}------------------------------------${NC}"

# Display Memory Info
echo "Memory Usage:"
echo "Memory Usage:" >> "$LOG_FILE"
if command -v free &> /dev/null; then
    # Linux system
    free -h | awk 'NR==1 || NR==2' | tee -a "$LOG_FILE"
elif command -v vm_stat &> /dev/null; then
    # macOS system
    top -l 1 -s 0 | grep -E "PhysMem" | tee -a "$LOG_FILE"
else
    echo "Memory stats unavailable." >> "$LOG_FILE"
fi

echo -e "${BLUE}====================================${NC}"
echo "">>"$LOG_FILE"
