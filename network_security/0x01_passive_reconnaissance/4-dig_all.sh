#!/bin/bash
dig $1 A NS SOA MX TXT +noall +answer
