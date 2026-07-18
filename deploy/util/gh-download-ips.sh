#!/bin/bash

tmpfile=github-action-ips
outputfile=deploy/vms/firewall/github-action-ips.zip

curl -s https://api.github.com/meta | python3 -c "import sys, json; print('\n'.join(json.load(sys.stdin)['actions']))" > $tmpfile
zip $outputfile $tmpfile
rm $tmpfile
