#!/bin/sh

sites_available_dir="/etc/nginx/sites-available"

# Get a list of all files in the sites-available directory
configs=$(ls $sites_available_dir)

# Use gum choose to present the list of configs to the user
selected_config=$(gum choose $configs)

# If gum choose was interrupted (e.g., by Ctrl+C), exit the script
if [ $? -ne 0 ]; then
    echo "Operation was interrupted. Exiting..."
    exit 1
fi

# Open the selected config in nano
sudo nano "${sites_available_dir}/${selected_config}"

sudo systemctl restart nginx
