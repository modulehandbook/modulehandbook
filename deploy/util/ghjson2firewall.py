# reads ips for github actions and transforms them to firewall rules.
# needs certs to be installed:
# pip install pip-system-certs
# may be replaced with a one-liner:
# curl -s https://api.github.com/meta | python3 -c "import sys, json; print(json.load(sys.stdin)['actions'])"
# curl -s https://api.github.com/meta | python3 -c "import sys, json; print(' '.join(json.load(sys.stdin)['actions'])))"

import urllib.request
import json
import os

gh_url = 'https://api.github.com/meta'
rule_template = 'iptables -A INPUT -p tcp -s {} --dport 22 -j ACCEPT'
header = """
#!/bin/bash
# 
# THIS FILE IS GENERATED!
# 
# SCRIPT: {}
# DATA SOURCE: {}
# 
# Allow SSH (port 22) from {} possible GitHub Actions Hosts
#

"""

def get_ips():
    with urllib.request.urlopen(gh_url) as response:
        data = response.read()
        meta = json.loads(data)
        actions_ips = meta['actions']
        return actions_ips

def githubmeta_2_firewall():
    with urllib.request.urlopen(gh_url) as response:
        data = response.read()
        meta = json.loads(data)
        actions_ips = meta['actions']
        
        return rules

def filter_ip_v6(ips):
    return [ip for ip in ips if ':' not in ip]
    
def print_rules(ips):
    rules = [rule_template.format(ip) for ip in ips]
    scriptfile = os.path.basename(__file__)
    print (header.format(scriptfile, gh_url, len(rules)))
    rules_in_lines = "\n".join(rules)
    print(rules_in_lines)

def print_ips(ips):
    print("\n".join(ips))

if __name__ == '__main__':
    ips = get_ips()
    ips = filter_ip_v6(ips)

    # print_rules(ips)
    print_ips(ips)
