#!/bin/bash

# Find the config file, regardless of where the script is called from
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
CONFIG_FILE="$SCRIPT_DIR/vpn_config.env"

# 1. Check if config file exists
if [[ ! -f "$CONFIG_FILE" ]]; then
    echo "Error: Configuration file '$CONFIG_FILE' not found."
    echo "Please create it using the provided template."
    exit 1
fi

# 2. Source the config file to load variables
source "$CONFIG_FILE"

# 3. Validate that variables are not empty
check_variables() {
    local unset_vars=()

    if [[ -z "$DB_PATH" ]]; then unset_vars+=("DB_PATH"); fi
    if [[ -z "$ENTRY_NAME" ]]; then unset_vars+=("ENTRY_NAME"); fi
    if [[ -z "$VPN_HOST" ]]; then unset_vars+=("VPN_HOST"); fi
    if [[ -z "$VPN_CLIENT" ]]; then unset_vars+=("VPN_CLIENT"); fi

    if [[ ${#unset_vars[@]} -gt 0 ]]; then
        echo "Error: The following variables are not set in $CONFIG_FILE:"
        for var in "${unset_vars[@]}"; do
            echo "  - $var"
        done
        exit 1
    fi

    # Check if VPN_CLIENT exists and is executable
    if [[ ! -x "$VPN_CLIENT" ]]; then
        echo "Error: VPN_CLIENT path '$VPN_CLIENT' is not executable or does not exist."
        exit 1
    fi
}

# Run the validation
check_variables

# --- Script Logic ---

# Disconnect just in case it is connected right now
"$VPN_CLIENT" disconnect

echo "Connecting to $VPN_HOST..."

# Fetch credentials from KeePassXC
# This part is adjusted for TU Wien VPN, since double new line is requested after username.
# Therefore, keepassxc output is parsed into 3 lines in keepass array.

keepass=()
while IFS= read -r line; do
    keepass+=( "$line" )
done < <( keepassxc-cli show -s "$DB_PATH" "$ENTRY_NAME" -a Username -a Password -t )
# each line from keepass array is separate value
USERNAME=${keepass[0]}
PASSWORD=${keepass[1]}
TOTP=${keepass[2]}
# Execute the VPN connection
echo -e "connect $VPN_HOST\n$USERNAME\n\n$PASSWORD\n$TOTP" | "$VPN_CLIENT" -s
