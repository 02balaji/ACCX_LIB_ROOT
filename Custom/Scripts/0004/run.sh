#!/bin/bash

# Import libraries
source "$(dirname "$0")/../lib/init.sh"
source "$LIB_DIR/vlocity_interface_impl.sh"

impleament_vlocity_interfaces "$SCRIPT_DIR/data/plan.json"