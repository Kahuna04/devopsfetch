#!/bin/bash

get_activities_in_time_range() {
    local start_time="$1"
    local end_time="$2"

    if [[ -z "$start_time" || -z "$end_time" ]]; then
        echo "Please provide both start and end time in the format 'YYYY-MM-DD HH:MM:SS'."
        return 1
    fi

    # Convert times to epoch seconds
    local start_epoch
    local end_epoch
    start_epoch=$(date -d "$start_time" +%s 2>/dev/null)
    end_epoch=$(date -d "$end_time" +%s 2>/dev/null)

    if [[ $? -ne 0 ]]; then
        echo "Invalid date format. Please use 'YYYY-MM-DD HH:MM:SS'."
        return 1
    fi

    echo "Activities from $start_time to $end_time:"

    # Retrieve and filter log entries
    # Here, assuming `/var/log/syslog` is used; adapt as needed
    awk -v start="$start_epoch" -v end="$end_epoch" '
    {
        if ($0 ~ /^\S+\s+\S+\s+/) {
            log_time = $1 " " $2;
            log_epoch = mktime(gensub(/[-:]/, " ", "g", log_time) " 00");
            if (log_epoch >= start && log_epoch <= end) {
                print $0
            }
        }
    }
    ' /var/log/syslog
}

