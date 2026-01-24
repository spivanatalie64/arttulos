#!/bin/bash
# Run all post-install integration scripts for ArttulOS
set -e

bash /root/pacnixum-install.sh
bash /root/ai-assistant-install.sh
bash /root/branding-install.sh
bash /root/scrapec-install.sh
