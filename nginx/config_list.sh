#!/bin/sh

sites_available_dir="/etc/nginx/sites-available"
sites_enabled_dir="/etc/nginx/sites-enabled"

echo
echo "Sites available ($sites_available_dir):"
ls $sites_available_dir

echo
echo "Sites enabled ($sites_enabled_dir):"
ls $sites_enabled_dir
echo
