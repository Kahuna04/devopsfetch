#!/bin/bash

get_activities_in_time_range() {
    local start_time=$1
    local end_time=$2
    echo "Activities from $start_time to $end_time:"
    awk -v start="$start_time" -v end="$end_time" '$0 >= start && $0 <= end' /var/log/syslog
}
