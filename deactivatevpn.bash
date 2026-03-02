#!/bin/bash

# Find the config file, regardless of where the script is called from
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
CONFIG_FILE="$SCRIPT_DIR/vpn_config.env"

# 1. Check if config file exists
if [[ ! -f "$CONFIG_FILE" ]]; then
    echo "Error: Configuration file '$CONFIG_FILE' not found."
    exit 1
fi

# 2. Source the config file to load variables
source "$CONFIG_FILE"

# 3. Validate that VPN_CLIENT is set and valid
if [[ -z "$VPN_CLIENT" ]]; then
    echo "Error: VPN_CLIENT is not defined in $CONFIG_FILE"
    exit 1
fi

if [[ ! -x "$VPN_CLIENT" ]]; then
    echo "Error: VPN_CLIENT path '$VPN_CLIENT' is not executable or does not exist."
    exit 1
fi

# --- Script Logic ---
echo "Disconnecting VPN..."
"$VPN_CLIENT" disconnect
