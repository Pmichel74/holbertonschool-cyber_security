#!/bin/bash
# SHA256 hash validator script
# Usage: ./2-sha256_validator.sh <filename> <expected_hash>
# Validates if the SHA256 hash of a file matches the expected hash
echo "$2  $1" | sha256sum -c