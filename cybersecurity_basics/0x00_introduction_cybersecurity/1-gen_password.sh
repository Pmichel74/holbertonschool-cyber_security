#!/bin/bash
# Generate a random password using alphanumeric characters
# Usage: ./1-gen_password.sh [length]
# Default length is 20 characters if no argument is provided
tr -dc '[:alnum:]' < /dev/urandom | head -c "${1:-20}"