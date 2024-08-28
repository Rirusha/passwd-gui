#!/bin/bash

current_password="$1"
new_password="$2"

{
    echo "$current_password"
    echo "$new_password"
    echo "$new_password"
} | passwd
