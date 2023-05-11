#!/bin/sh

sites_available_dir="/etc/nginx/sites-available"
sites_enabled_dir="/etc/nginx/sites-enabled"
options=()
files=("$sites_available_dir"/*)

# Add each file to the array without the full path
for file in "${files[@]}"; do
  if [[ -f "$file" ]]; then
    filename=$(basename "$file")
    options+=("$filename")
  fi
done

file_choice=$(gum choose "${options[@]}")

echo "Removing $file_choice configuration file..."

sudo rm $sites_available_dir/$file_choice
sudo rm $sites_enabled_dir/$file_choice

echo "$file_choice has been removed."

gum confirm "Would you like to restart Nginx?" && sudo systemctl restart nginx