#!/bin/bash

# import libraries
source "$(dirname "$0")/../lib/init.sh"
source "$LIB_DIR/set_picklist.sh"

# Main
jq -c '.picklists[]' "$SCRIPT_DIR/data/config.json" | while read picklist; do
    # init params
    picklist_object_name=$(remove_double_quotes $(echo $picklist | jq -c '.objectName'));
    picklist_field_name=$(remove_double_quotes $(echo $picklist | jq -c '.fieldName'));
    picklist_field_items=$(echo $picklist | jq -c '.items[]');
    echo_i "custom field" "$picklist_object_name.$picklist_field_name";
    # loop items in picklist
    echo "$picklist" | jq -c '.items[]' | while read item; do
        item_value=$(echo $item | jq -r '.Value');
        item_isactive=$(echo $item | jq -c '.Active');
        # get custom field containing the picklist
        echo_loading "Verify" "'$item_value'";
        get_result=$(echo $(sfdx accedx:customfield:list -u "$ACCEDX_ORG" -n "$picklist_object_name.$picklist_field_name" --json) | tr -d '[:cntrl:]')
        log_salesforce_response_if_error "$get_result";
        # validate picklist value
        # set item if non-valid
        if ! (validate_picklist_value_from_customfield_metadata "$(echo $get_result | jq -c '.result')" "$item_value" "$item_isactive"); then
            remove_last_line;
            echo_warn "upsert picklist item" "$item_value";
            update_result=$(echo $(sfdx accedx:customfield:picklist:set -u "$ACCEDX_ORG" --name "$picklist_object_name.$picklist_field_name" -v "$item_value" -A "$item_isactive" --json) | tr -d '[:cntrl:]');
            remove_last_line;
            log_salesforce_upsert_response "$update_result" "'$item_value' item set (active=$item_isactive)";
        else
            remove_last_line;
            echo_info "valid picklist item" "'$item_value'";
        fi
    done
    echo
done