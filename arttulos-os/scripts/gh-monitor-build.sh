#!/bin/bash
# Monitor GitHub Actions build status for ArttulOS in a new terminal
set -e

REPO="spivanatalie64/arttulos"

MONITOR_CMD="bash -c 'echo Recent workflow runs:; gh run list --repo $REPO --limit 5; RUN_ID=$(gh run list --repo $REPO --limit 1 --json databaseId --jq \".[0].databaseId\"); if [ -z \"$RUN_ID\" ]; then echo No workflow runs found.; exit 1; fi; echo Monitoring latest run: $RUN_ID; gh run watch $RUN_ID --repo $REPO; echo Build monitoring complete.'"

# Try to open in gnome-terminal, xterm, or konsole
if command -v gnome-terminal &>/dev/null; then
  gnome-terminal -- $MONITOR_CMD
elif command -v xterm &>/dev/null; then
  xterm -e "$MONITOR_CMD"
elif command -v konsole &>/dev/null; then
  konsole -e $MONITOR_CMD
else
  echo "No supported terminal found. Running in current shell."
  eval $MONITOR_CMD
fi
