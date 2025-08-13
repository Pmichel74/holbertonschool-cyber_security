#!/bin/bash
dig @ns-1455.awsdns-53.org +noall +answer $1 A $1 NS $1 SOA $1 MX $1 TXT 2>/dev/null
