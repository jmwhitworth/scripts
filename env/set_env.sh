#!/bin/sh

# Check if Gum is installed
if ! command -v gum &> /dev/null; then
    echo "Error: Gum is not installed. Please install Gum and try again."
    echo "To install Gum, run:"
    echo "curl -sSL https://github.com/charmbracelet/gum/releases/download/v0.1.0/gum_0.1.0_linux_amd64.tar.gz | tar xzv -C /usr/local/bin"
    echo "Or 'sudo pacman -S gum' if you use Arch, btw"
    exit 1
fi


# Get paths
full_env_file=$(gum input --placeholder "Path to main env (default: all.env):")
dummy_env_file=$(gum input --placeholder "Path to sample env (default: .env.sample):")
output_env_file=$(gum input --placeholder "Path to output env (default: .env):")

# Set defaults if blank
full_env_file=${full_env_file:-all.env}
dummy_env_file=${dummy_env_file:-.env.sample}
output_env_file=${output_env_file:-.env}


# Check inputs exist
if [[ ! -f $full_env_file ]]; then
    echo "Error: $full_env_file not found."
    exit 1
fi
if [[ ! -f $dummy_env_file ]]; then
    echo "Error: $dummy_env_file not found."
    exit 1
fi


# Create an empty output file or overwrite the existing one
> $output_env_file

exclude_list=("ENVIRONMENT" "DB_URL" "DB_TESTS_URL WP_HOME WP_SITEURL")

while read -r dummy_line || [[ -n "$dummy_line" ]]; do
    dummy_key=$(echo "$dummy_line" | cut -d '=' -f 1)


    # Check if the key is in the exclude_list
    if [[ " ${exclude_list[*]} " =~ " ${dummy_key} " ]]; then
        # If the key is in the exclude list, keep the dummy data
        echo "$dummy_line" >> "$output_env_file"
    else
        # Check if the key exists in the full_env_file
        full_line=$(grep "^$dummy_key=" "$full_env_file")

        if [[ -n "$full_line" ]]; then
            # If the key exists in the full_env_file, copy the variable and value to the output_env_file
            echo "$full_line" >> "$output_env_file"
        else
            # If the key doesn't exist in the full_env_file, keep the dummy data
            echo "$dummy_line" >> "$output_env_file"
        fi
    fi
done < "$dummy_env_file"

echo "Updated env file is saved as $output_env_file."
