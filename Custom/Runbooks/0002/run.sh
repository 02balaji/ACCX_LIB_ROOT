#!/bin/bash

# Import libraries
source "$(dirname "$0")/../lib/init.sh"
source "$LIB_DIR/set_custom_settings.sh"

# Main
set_custom_settings "$SCRIPT_DIR/data/config.json"