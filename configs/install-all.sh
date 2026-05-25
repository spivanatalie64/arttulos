#!/bin/bash
set -e
bash /root/pacnixum-install.sh
bash /root/ai-assistant-install.sh
bash /root/branding-install.sh
bash /root/scrapec-install.sh
bash /root/immutable-patch.sh
echo "ArttulOS: All installations complete."
