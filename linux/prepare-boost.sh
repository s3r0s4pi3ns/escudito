#!/usr/bin/env bash

set -euo pipefail

greenColour='\033[0;32m'
redColour='\033[0;31m'
blueColour='\033[0;34m'
yellowColour='\033[1;33m'
purpleColour='\033[0;35m'
cyanColour='\033[0;36m'
grayColour='\033[0;37m'

endColour='\033[0m'

CURRENT_DIR=$(dirname "$0")

source "$CURRENT_DIR/../helpers/utils.sh"

main() {
    apply_sshd_configuration_file
}

###
#  [SSH HARDENING] 
# Be careful to define this security rules because once the configuration is applied, you cannot login with root anymore
# Make sure you generated the ssh keys and has a privilege user
###

apply_sshd_configuration_file() {
    local SSH_CONFIGURATION_FILE="$CURRENT_DIR/sshd_config/hardening-init.conf"    
    declare -i SSH_PORT=22
  
    if directory_exists "/etc/sshd_config.d"; then
        while port_in_valid_range $SSH_PORT -eq 0; do 
            read -rp "$yellowColour [ SSH Hardening ]$endColour Select a port for OpenSSH service (Default 22) " SSH_PORT
        done

        cp "$SSH_CONFIGURATION_FILE" /etc/sshd_config.d/
    else
      echo -e "$yellowColour [ SSH Hardening ]$endColour The configuration folder /etc/sshd_config.d does not exists in this system$redColour [FAILED]$endColour"   
    fi
}

main