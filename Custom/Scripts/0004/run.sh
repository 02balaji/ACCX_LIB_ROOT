#!/bin/bash

# import libraries
source "$(dirname "$0")/../lib/init.sh"

# Main
domain_name=$(get_my_domain);
remote_sites=("my.salesforce.com" "visualforce.com" "lighting.force.com");
for url_suffix in ${remote_sites[@]}; do
    remote_site_name=$(echo "$url_suffix" | sed 's/\.//g');
    remote_site_url="https://$domain_name.$url_suffix";
    remote_site_disable_protocol_security=true;
    remote_site_is_active=true;
    echo_loading "$remote_site_name" "($remote_site_url)";
    # compare with remote site in sf
    sf_remote_site=$(sfdx accedx:remotesite:list -u "$ACCEDX_ORG" -n "$remote_site_name" --json | jq -c '{status,name,message,result}')
    remove_last_line;
    if [[ "$(echo $sf_remote_site | jq -r '.result.url')" != "$remote_site_url" ]] ||
       [[ "$(echo $sf_remote_site | jq -r '.result.disableProtocolSecurity')" != "$remote_site_disable_protocol_security" ]] ||
       [[ "$(echo $sf_remote_site | jq -r '.result.isActive')" != "$remote_site_is_active" ]]; then
        upsert_result=$(echo $(sfdx accedx:remotesite:set -u "$ACCEDX_ORG" -n "$remote_site_name" --url "$remote_site_url" -D "$remote_site_disable_protocol_security" -A "$remote_site_is_active" --json) | tr -d '[:cntrl:]')
        log_salesforce_retreive_response "$upsert_result" "$remote_site_name set to $remote_site_url"
    else
        echo_i "no changes" "$remote_site_name" "($remote_site_url)"
    fi
done