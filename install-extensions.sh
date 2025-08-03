#!/bin/bash

# Extension installer script for VS Code (Flatpak)

# Check if filename argument is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <extensions_file>"
    echo "Example: $0 extensions.txt"
    exit 1
fi

EXTENSIONS_FILE="$1"

# Check if file exists
if [ ! -f "$EXTENSIONS_FILE" ]; then
    echo "Error: File '$EXTENSIONS_FILE' not found!"
    exit 1
fi

# Function to install extension
install_extension() {
    local extension="$1"
    code --install-extension $1 --force        
}

# Main script starts here
echo "VS Code Extension Installer"
echo "====================================="

# Check VS Code installation
check_vscode_flatpak

echo "Reading extensions from: $EXTENSIONS_FILE"
echo ""

# Counter for installed extensions
installed=0
failed=0

# Read and install extensions
while IFS= read -r line; do
    # Skip empty lines and comments
    [[ -z "$line" || "$line" =~ ^[[:space:]]*# ]] && continue
    
    # Clean up the extension name
    extension=$(echo "$line" | xargs)
    [[ -z "$extension" ]] && continue
    
    echo "Installing: $extension"
    
    if install_extension "$extension"; then
        echo "✓ Success: $extension"
        ((installed++))
    else
        echo "✗ Failed: $extension"
        ((failed++))
    fi
    echo ""
    
done < "$EXTENSIONS_FILE"

# Summary
echo "Installation completed!"
echo "Installed: $installed"
echo "Failed: $failed"
