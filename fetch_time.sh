#!/bin/bash

get_activities_in_time_range() {
    start_time="$1 00:00:00"
    end_time="$1 23:59:59"
    
    echo "Displaying system logs from $start_time to $end_time..."

    # Retrieve logs within the specified time range
    sudo journalctl --since="$start_time" --until="$end_time"
}

