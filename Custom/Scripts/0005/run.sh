#!/bin/bash

# import libraries
source "$(dirname "$0")/../lib/init.sh"
source "$LIB_DIR/set_picklist.sh"

# Main
set_picklists "$SCRIPT_DIR/data/config.json"