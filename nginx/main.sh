#!/bin/sh

# Get current directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Selct nginx script:"
choice=$(gum choose "Create config" "Remove config" "List all configs")

case "$choice" in
    "Create config")
        bash $SCRIPT_DIR/config_create.sh
        ;;
    "Remove config")
        bash $SCRIPT_DIR/config_remove.sh
        ;;
    "List all configs")
        bash $SCRIPT_DIR/config_list.sh
        ;;
esac