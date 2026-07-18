#!/bin/bash

# this script prepares the firewall rules for github actions
# run from project root

python deploy/util/ghjson2firewall.py > tmp/firewall-allow-github-actions.sh
zip deploy/vms/firewall-allow-github-actions.sh.zip tmp/firewall-allow-github-actions.sh
