<<<<<<< HEAD
<<<<<<< HEAD
#!/bin/bash

# import libraries
source "$(dirname "$0")/../lib/init.sh"

# main
for partition in $(jq -c '.partitions[]' "$SCRIPT_DIR/data/config.json"); do
    # init all parameters
    cachePartitonName=$(echo $partition | jq -r '.fullName');
    cachePartitonLabel=$(echo $partition | jq -r '.masterLabel');
    cachePartitonIsDefault=$(echo $partition | jq -r '.isDefaultPartition');
    cachePartitonSessionAllocation=$(echo $partition | jq -r '.platformCachePartitionTypes[] | select(.cacheType | contains("Session")).allocatedCapacity');
    cachePartitonOrgAllocation=$(echo $partition | jq -r '.platformCachePartitionTypes[] | select(.cacheType | contains("Organization")).allocatedCapacity');
    echo_loading "$cachePartitonName";
    cache_partition_retrieve_result=$(echo $(sfdx accedx:cache:list -u "$ACCEDX_ORG" -n "$cachePartitonName" --json) | tr -d '[:cntrl:]')
    remove_last_line;
    log_salesforce_response_if_error "$cache_partition_retrieve_result"
    allocatedOrgCapacity=$(echo "$cache_partition_retrieve_result" | jq -r '.result.platformCachePartitionTypes[] | select(.cacheType | contains("Organization")).allocatedCapacity')
    # compare with org allocation in sf
    if [[ "$allocatedOrgCapacity" != "${cachePartitonOrgAllocation}" ]]; then
        upsert_result=$(sfdx accedx:cache:set -u "$ACCEDX_ORG" -n "$cachePartitonName" -l $cachePartitonLabel -s $cachePartitonSessionAllocation -o $cachePartitonOrgAllocation -D $cachePartitonIsDefault --json)
        if [[ "$(echo $upsert_result | jq -c '.result.success')" != "false" ]]; then
            echo_success "$cachePartitonName partition set";
        else
            echo_failed "Unable to set partition: $cachePartitonName";
            output=$(echo $upsert_result | jq -c '{success: .result.success, errors: .result.errors}');
            echo ">>> $output";
            console_error $output;
        fi
    else
        echo_i "no changes" "$cachePartitonName";
    fi
done
=======
#!/bin/bash

# import libraries
source "$(dirname "$0")/../lib/init.sh"

# main
for partition in $(jq -c '.partitions[]' "$SCRIPT_DIR/data/config.json"); do
    # init all parameters
    cachePartitonName=$(echo $partition | jq -r '.fullName');
    cachePartitonLabel=$(echo $partition | jq -r '.masterLabel');
    cachePartitonIsDefault=$(echo $partition | jq -r '.isDefaultPartition');
    cachePartitonSessionAllocation=$(echo $partition | jq -r '.platformCachePartitionTypes[] | select(.cacheType | contains("Session")).allocatedCapacity');
    cachePartitonOrgAllocation=$(echo $partition | jq -r '.platformCachePartitionTypes[] | select(.cacheType | contains("Organization")).allocatedCapacity');
    echo_loading "$cachePartitonName";
    cache_partition_retrieve_result=$(echo $(sfdx accedx:cache:list -u "$ACCEDX_ORG" -n "$cachePartitonName" --json) | tr -d '[:cntrl:]')
    remove_last_line;
    log_salesforce_response_if_error "$cache_partition_retrieve_result"
    allocatedOrgCapacity=$(echo "$cache_partition_retrieve_result" | jq -r '.result.platformCachePartitionTypes[] | select(.cacheType | contains("Organization")).allocatedCapacity')
    # compare with org allocation in sf
    if [[ "$allocatedOrgCapacity" != "${cachePartitonOrgAllocation}" ]]; then
        upsert_result=$(sfdx accedx:cache:set -u "$ACCEDX_ORG" -n "$cachePartitonName" -l $cachePartitonLabel -s $cachePartitonSessionAllocation -o $cachePartitonOrgAllocation -D $cachePartitonIsDefault --json)
        if [[ "$(echo $upsert_result | jq -c '.result.success')" != "false" ]]; then
            echo_success "$cachePartitonName partition set";
        else
            echo_failed "Unable to set partition: $cachePartitonName";
            output=$(echo $upsert_result | jq -c '{success: .result.success, errors: .result.errors}');
            echo ">>> $output";
            console_error $output;
        fi
    else
        echo_i "no changes" "$cachePartitonName";
    fi
done
>>>>>>> branch 'main' of https://github.com/02balaji/ACCX_LIB_ROOT.git
=======
#!/bin/bash

# import libraries
source "$(dirname "$0")/../lib/init.sh"

# main
for partition in $(jq -c '.partitions[]' "$SCRIPT_DIR/data/config.json"); do
    # init all parameters
    cachePartitonName=$(echo $partition | jq -r '.fullName');
    cachePartitonLabel=$(echo $partition | jq -r '.masterLabel');
    cachePartitonIsDefault=$(echo $partition | jq -r '.isDefaultPartition');
    cachePartitonSessionAllocation=$(echo $partition | jq -r '.platformCachePartitionTypes[] | select(.cacheType | contains("Session")).allocatedCapacity');
    cachePartitonOrgAllocation=$(echo $partition | jq -r '.platformCachePartitionTypes[] | select(.cacheType | contains("Organization")).allocatedCapacity');
    echo_loading "$cachePartitonName";
    cache_partition_retrieve_result=$(echo $(sfdx accedx:cache:list -u "$ACCEDX_ORG" -n "$cachePartitonName" --json) | tr -d '[:cntrl:]')
    remove_last_line;
    log_salesforce_response_if_error "$cache_partition_retrieve_result"
    allocatedOrgCapacity=$(echo "$cache_partition_retrieve_result" | jq -r '.result.platformCachePartitionTypes[] | select(.cacheType | contains("Organization")).allocatedCapacity')
    # compare with org allocation in sf
    if [[ "$allocatedOrgCapacity" != "${cachePartitonOrgAllocation}" ]]; then
        upsert_result=$(sfdx accedx:cache:set -u "$ACCEDX_ORG" -n "$cachePartitonName" -l $cachePartitonLabel -s $cachePartitonSessionAllocation -o $cachePartitonOrgAllocation -D $cachePartitonIsDefault --json)
        if [[ "$(echo $upsert_result | jq -c '.result.success')" != "false" ]]; then
            echo_success "$cachePartitonName partition set";
        else
            echo_failed "Unable to set partition: $cachePartitonName";
            output=$(echo $upsert_result | jq -c '{success: .result.success, errors: .result.errors}');
            echo ">>> $output";
            console_error $output;
        fi
    else
        echo_i "no changes" "$cachePartitonName";
    fi
done
>>>>>>> branch 'main' of https://github.com/02balaji/ACCX_LIB_ROOT.git
echo;exit;