# reads ips for github actions and transforms them to firewall rules.
# needs certs to be installed:
# pip install pip-system-certs
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
def githubmeta_2_firewall():
    with urllib.request.urlopen(gh_url) as response:
        data = response.read()
        meta = json.loads(data)
        actions_ips = meta['actions']
        rules = [rule_template.format(ip) for ip in actions_ips]
        return rules

if __name__ == '__main__':
    rules = githubmeta_2_firewall()
    scriptfile = os.path.basename(__file__)
    print (header.format(scriptfile, gh_url, len(rules)))
    rules_in_lines = "\n".join(rules)
    print(rules_in_lines)
