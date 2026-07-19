# ------------------------------------------------------------------------------------------
#
#    EXTERN - Spezielle Regeln für Module-Handbook
#           
# ------------------------------------------------------------------------------------------
#
# HTTP & HTTPS
# input is NOT needed, as docker adds forward rule 
# output is needed to download docker images

# iptables -A INPUT -p tcp --dport 80,443 -j ACCEPT
iptables -A OUTPUT -p tcp -m multiport --dports 80,443 -j ACCEPT
#
#
# SMTP zulassen für ActionMailer
#
iptables -A OUTPUT -p tcp --dport 587 -j ACCEPT


# for deployment via ssh from github actions
# allow ssh from github actions hosts

for i in $(unzip -p firewall-github-action-ips.zip); do

iptables -A INPUT -p tcp -s $i --dport 22 -j ACCEPT

done
