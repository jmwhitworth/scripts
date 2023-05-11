#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BOOTSTRAP="bootstrap"

# Sets all included scripts as executable
for subdirectory in "$SCRIPT_DIR"/*; do
  if [[ -d "$subdirectory" ]]; then
    for file in "$subdirectory"/*.sh; do
      if [[ -f "$file" ]]; then
        chmod +x "$file"
        echo "Added execute permission to $file"
      fi
    done
  fi
done

# Add the bootstrap to ~/.zshrc
if grep -q "source $SCRIPT_DIR/$BOOTSTRAP" ~/.zshrc; then
  echo "Alias already exists. Skipping..."
else
  echo "" >> ~/.zshrc
  echo "# Link to Jw scripts" >> ~/.zshrc
  echo "source $SCRIPT_DIR/$BOOTSTRAP" >> ~/.zshrc
  echo "" >> ~/.zshrc
  echo "Alias created. Either run 'source ~/.zshrc' or restart terminal."
fi

