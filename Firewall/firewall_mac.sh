#!/bin/bash

###
# This script enables the macOS firewall and configures:
#  - Firewall: On
#  - Block all incoming connections: Off
#  - Automatically allow built-in software: On
#  - Automatically allow downloaded signed software: Off
#  - Stealth mode: On
###

# Enable the firewall
/usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on

# Disable "Block all incoming connections"
/usr/libexec/ApplicationFirewall/socketfilterfw --setblockall off

# Enable "Automatically allow built-in software"
/usr/libexec/ApplicationFirewall/socketfilterfw --setallowsigned on

# Disable "Automatically allow downloaded signed software"
/usr/libexec/ApplicationFirewall/socketfilterfw --setallowsignedapp off

# Enable Stealth mode
/usr/libexec/ApplicationFirewall/socketfilterfw --setstealthmode on

# Reload the firewall to apply changes
pkill -HUP socketfilterfw

exit 0