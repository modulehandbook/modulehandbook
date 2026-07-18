#!/bin/sh
#
#
#
#
#
#
#
# ------------------------------------------------------------------------------------------
#
#     1. TEIL: EXTERN - übernommen aus # 17. Apr 2025  firewall.sh 
#           schultze 15.07.2024 (A.Schultze@htw-berlin.de)
# ------------------------------------------------------------------------------------------
# Alle Regeln aller Chains in Tabelle Filter loeschen
#
iptables -F
#
# Default Policy fuer alle Chains DROP
#
#
# auf bestehenden und zugehoerigen verbindungen alles erlauben
#
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
#
# NESSUS Netzwerkscanner
iptables -A INPUT -p tcp -s 10.45.64.36 -j ACCEPT
#
# loopback device zulassen
#
iptables -A INPUT -i lo -s 127.0.0.0/8 -d 127.0.0.0/8 -j ACCEPT
iptables -A OUTPUT -o lo -d 127.0.0.0/8 -s 127.0.0.0/8 -j ACCEPT

# ------------------------------------------------------------------------------------------
#
#     2. TEIL: EXTERN - Spezielle Regeln für Module-Handbook
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

for i in $(unzip -p github-action-ips.zip); do

iptables -A INPUT -p tcp -s $i --dport 22 -j ACCEPT

done



# ------------------------------------------------------------------------------------------
#
#                                DROP 
#           
# ------------------------------------------------------------------------------------------
#
# alles von/nach aussen DROP
#
iptables -A INPUT ! -s 141.45.0.0/16 -j DROP
iptables -A OUTPUT ! -d 141.45.0.0/16 -j DROP


# ------------------------------------------------------------------------------------------
#
#     5. TEIL: INTERN: aus firewall.sh übernommen
#           
# ------------------------------------------------------------------------------------------
#
# Ping zulassen
#
iptables -A INPUT -p icmp -j ACCEPT
iptables -A OUTPUT -p icmp -j ACCEPT
#
# SSH INPUT OUTPUT zulassen
#
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
#iptables -A OUTPUT -p tcp --dport 22 -j ACCEPT
#
# kommentare wegnehmen: HTTPS INPUT OUTPUT zulassen
#
iptables -A INPUT -p tcp --dport 443 -j ACCEPT
#iptables -A OUTPUT -p tcp --dport 443 -j ACCEPT
#
# kommentare wegnehmen: HTTP INPUT OUTPUT zulassen
#
#iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 80 -j ACCEPT
#
# DNS zulassen
#
iptables -A OUTPUT -p udp --dport 53 -j ACCEPT
#
# NTP (Network Time Protocoll)
#
iptables -A OUTPUT -p udp --dport 123 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 123 -j ACCEPT

#
# SSH zulassen
#
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 22 -j ACCEPT

#
# Ping zulassen
#
iptables -A INPUT -p icmp -j ACCEPT
iptables -A OUTPUT -p icmp -j ACCEPT

#
# DNS zulassen
#
iptables -A OUTPUT -p udp --dport 53 -j ACCEPT

#
# NTP (Network Time Protocoll)
#
iptables -A OUTPUT -p udp --dport 123 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 123 -j ACCEPT
#
# RZ Mailer
# module handbook needs to be able to send mails
#
iptables -A OUTPUT -p tcp --dport 25 -d 141.45.10.101 -j ACCEPT
# mailer 
iptables -A OUTPUT -p tcp --dport 587 -j ACCEPT
#
#
# LOGGING
#
#iptables -A INPUT -j LOG --log-prefix ' ++ INPUT DROP ++ ' --log-level 4
#iptables -A OUTPUT -j LOG --log-prefix ' ++ OUTPUT DROP ++ ' --log-level 4

# ------------------------------------------------------------------------------------------
#
#     4. TEIL: INTERN: Speziell für Module-Handbook

iptables -A OUTPUT -p tcp --dport 22 -j ACCEPT

# restart docker daemon 
# do this before saving, rules will be there
# probably not needed, as docker service will also be restarted after boot?

systemctl restart docker
#       Ende 4. TEIL: INTERN: Speziell für Module-Handbook    
# ------------------------------------------------------------------------------------------
#
#
# 
# write current rules 
iptables-save > /etc/firewall.conf

echo "#!/bin/sh"      > /etc/network/if-up.d/iptables
echo "iptables-restore < /etc/firewall.conf" >> /etc/network/if-up.d/iptables

chmod +x /etc/network/if-up.d/iptables

#
# Ping zulassen
#
iptables -A INPUT -p icmp -j ACCEPT
iptables -A OUTPUT -p icmp -j ACCEPT
#
# SSH INPUT OUTPUT zulassen
#
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
#iptables -A OUTPUT -p tcp --dport 22 -j ACCEPT
#
# kommentare wegnehmen: HTTPS INPUT OUTPUT zulassen
#
iptables -A INPUT -p tcp --dport 443 -j ACCEPT
#iptables -A OUTPUT -p tcp --dport 443 -j ACCEPT
#
# kommentare wegnehmen: HTTP INPUT OUTPUT zulassen
#
#iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 80 -j ACCEPT
#
# kommentare wegnehmen: HTTP alternativ INPUT OUTPUT zulassen
#
#iptables -A INPUT -p tcp --dport 8080 -j ACCEPT
#iptables -A OUTPUT -p tcp --dport 8080 -j ACCEPT
#
# DNS zulassen
#
iptables -A OUTPUT -p udp --dport 53 -j ACCEPT
#
# NTP (Network Time Protocoll)
#
iptables -A OUTPUT -p udp --dport 123 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 123 -j ACCEPT
#
# RZ Mailer
#
#iptables -A OUTPUT -p tcp --dport 25 -d 141.45.10.101 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 465 -d 141.45.10.101 -j ACCEPT

# Debugg-Information
#
#iptables -A INPUT -j LOG --log-prefix ' ++ INPUT DROP ++ ' --log-level 4
#iptables -A OUTPUT -j LOG --log-prefix ' ++ OUTPUT DROP ++ ' --log-level 4
#
iptables-save > /etc/firewall.conf
#
echo -n "#"      > /etc/network/if-up.d/iptables
echo -n !       >> /etc/network/if-up.d/iptables
echo /bin/sh    >> /etc/network/if-up.d/iptables
echo "iptables-restore < /etc/firewall.conf" >> /etc/network/if-up.d/iptables
#
chmod +x /etc/network/if-up.d/iptables
