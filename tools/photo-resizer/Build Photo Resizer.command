#!/bin/bash
# Double-click to build "Photo Resizer.app" from the script next to this file.
cd "$(dirname "$0")" || exit 1
if osacompile -o "Photo Resizer.app" "Photo Resizer.applescript"; then
  echo "Built Photo Resizer.app. Drag it to your Applications folder or Dock."
  open -R "Photo Resizer.app"
else
  echo "The build failed. Copy the error above and send it to Claude."
  read -r -p "Press Return to close this window."
fi
