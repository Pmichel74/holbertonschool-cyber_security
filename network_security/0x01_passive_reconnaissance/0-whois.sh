#!/bin/bash
whois $1 | awk -F":" '/^(Registrant|Admin|Tech) (Name|Organization|Street|City|State\/Province|Postal Code|Country|Phone|Fax|Email|Phone Ext:|Fax Ext:)/{print $1"," $2}' > $1.csv
