#!/bin/sh

temp_dir="./.temp"
sites_available_dir="/etc/nginx/sites-available"
sites_enabled_dir="/etc/nginx/sites-enabled"

app_name=$(gum input --placeholder "Enter the app name (this will also be the path):")

sites_available_config="${sites_available_dir}/${app_name}"
sites_enabled_config="${sites_enabled_dir}/${app_name}"


echo "Select PHP version:"
php_version_choice=$(gum choose "^8.2" "7.4")
case "$php_version_choice" in
    "^8.2")
        php_version=""
        ;;
    "7.4")
        php_version="74"
        ;;
esac

echo "Does this project use a /public directory?"
public_dir_choice=$(gum choose "Yes" "No")
case "$public_dir_choice" in
    "Yes")
        public_dir="/public"
        ;;
    "No")
        public_dir=""
        ;;
esac


if [ -f "${sites_available_dir}/${app_name}" ] || [ -f "${sites_enabled_dir}/${app_name}" ]; then
    echo "Error: A config file already exists with this app name in either sites-available or sites-enabled. Please choose another app name or remove the existing config file."
    exit 1
fi



# Create Nginx config file
cat > "$temp_dir" << EOL
server {
    listen 80;
    server_name ${app_name}.localhost;
    root /home/jack/Sites/${app_name}${public_dir};

    index index.php index.html;

    location / {
        try_files \$uri \$uri/ /index.php?\$query_string;
    }

    location ~ \.php$ {
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_pass unix:/run/php${php_version}-fpm/php-fpm.sock;
        fastcgi_index index.php;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        fastcgi_param PATH_INFO \$fastcgi_path_info;
    }

    location ~ /\.ht {
        deny all;
    }
}
EOL


sudo mv "$temp_dir" "$sites_available_config"
sudo ln -s "$sites_available_config" "$sites_enabled_config"

sudo systemctl restart nginx
sudo systemctl restart php${php_version}-fpm

if [ $? -eq 0 ]; then
    echo "Nginx configuration created and applied successfully!"
else
    echo "An error occurred. Please check the script and try again."
fi
