#!/bin/bash

list_users_and_last_logins() {
    echo "Users and Last Logins:"
    echo "User     Terminal  Login Time          Duration"
    echo "-------------------------------------------------"
    last -a | awk '{if ($1 != last_user) {printf "%-8s %-9s %-19s %-10s\n", $1, $2, $3" "$4" "$5, $6; last_user=$1}}'
}

get_user_info() {
    local username=$1
    echo "Information for User $username:"
    finger $username
}

