#!/bin/bash

list_users_and_last_logins() {
    echo "Users and Last Logins:"
    last -a
}

get_user_info() {
    local username=$1
    echo "Information for User $username:"
    finger $username
}
