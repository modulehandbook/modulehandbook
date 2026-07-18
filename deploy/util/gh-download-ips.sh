#!/bin/bash

tmpfile=github-action-ips
outputfile=deploy/vms/copy_to_host_home_directories/firewall-github-action-ips.zip

#curl -s https://api.github.com/meta | python3 -c "import sys, json; print('\n'.join(json.load(sys.stdin)['actions']))" > $tmpfile
python deploy/util/ghjson2firewall.py > $tmpfile

zip $outputfile $tmpfile
rm $tmpfile
