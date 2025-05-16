#!/bin/sh
# mb 04.04.2008 (mb@fhtw-berlin.de)
# richter 19.5.2008 (richter@fhtw-berlin.de)
# witt 06.05.2013 (m.witt@htw-berlin.de)
# schultze 05.12.2013 (A.Schultze@htw-berlin.de)
#
################################################
#
# firewall.sh: Skript zur Konfiguration von iptables
#
# usage: als root ./firewall.sh ausfuehren
#
# Die Standarteinstellung laesst nichts aus dem Subnetz 141.45.x.x heraus und nichts von
# ausserhalb des Subnetzes hinein. Innerhalb des Subnetzes sind SSH, NTP und DNS
# freigeschaltet.
#
# Auf eigene Verantwortung und auf Verantwortung des Projektleiters koennen einzelne Dienste
# (SSH,HHTP,HTTPS) freigeschaltet werden, dazu die Kommentare in den Zeilen *vor* den
# der DROP Anweisungen wegnehmen. FTP sollte nicht verwendet werden, anstelle dessen bitte SFTP.
#
# Die erste Zeile erlaubt dabei immer Verbindungen ZU diesem Server auf dem gegebenen Port
# Die zweite Zeile erlaubt immer Verbindungen VON diesem Server ZU dem gegebenen Port des anderen Servers
#
################################################
#
# Alle Regeln aller Chains in Tabelle Filter loeschen
#
iptables -F
#
# Standart Policy fuer alle Chains DROP
#
iptables -P INPUT ACCEPT
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

#
# auf bestehenden und zugehoerigen verbindungen alles erlauben
#
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
#
# kommentar wegnehmen: SSH INPUT OUTPUT zulassen
# (bitte kein ftp, sondern sftp (ueber ssh))
#
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 22 -j ACCEPT
#
# kommentare wegnehmen: HTTPS INPUT OUTPUT zulassen
#
iptables -A INPUT -p tcp --dport 443 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 443 -j ACCEPT
#
# kommentare wegnehmen: HTTP alternativ INPUT OUTPUT zulassen
#
#iptables -A INPUT -p tcp --dport 8080 -j ACCEPT
#iptables -A OUTPUT -p tcp --dport 8080 -j ACCEPT
#
# enable httpredir.debian.org, security.debian.org
#
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 80 -j ACCEPT
#
# SMTP zulassen
#
iptables -A OUTPUT -p tcp --dport 587 -j ACCEPT

# loopback device zulassen
#
iptables -A INPUT -i lo -s 127.0.0.0/8 -d 127.0.0.0/8 -j ACCEPT
iptables -A OUTPUT -o lo -d 127.0.0.0/8 -s 127.0.0.0/8 -j ACCEPT
#
# alles von/nach aussen DROP
#
iptables -A INPUT ! -s 141.45.0.0/16 -j DROP
iptables -A OUTPUT ! -d 141.45.0.0/16 -j DROP
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
#iptables -A INPUT -p tcp --dport 443 -j ACCEPT
#iptables -A OUTPUT -p tcp --dport 443 -j ACCEPT
#
# kommentare wegnehmen: HTTP INPUT OUTPUT zulassen
#
#iptables -A INPUT -p tcp --dport 80 -j ACCEPT
#iptables -A OUTPUT -p tcp --dport 80 -j ACCEPT
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
# SMTP zulassen
#
iptables -A OUTPUT -p tcp --dport 587 -j ACCEPT
#
# NTP (Network Time Protocoll)
#
iptables -A OUTPUT -p udp --dport 123 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 123 -j ACCEPT
#
# RZ Mailer
#
#iptables -A OUTPUT -p tcp --dport 25 -d 141.45.10.101 -j ACCEPT
#
#
# kommentare entfernen: log all dropped
# bitte nur zum debuggen...
#
#iptables -A INPUT -j LOG --log-prefix ' ++ INPUT DROP ++ ' --log-level 4
#iptables -A OUTPUT -j LOG --log-prefix ' ++ OUTPUT DROP ++ ' --log-level 4
#
#
# Alles DROP was nicht akzeptiert wurde
# Diese beiden Zeilen duerfen NICHT entfernt werden
#
iptables -A INPUT -j DROP
iptables -A OUTPUT -j DROP
#
iptables-save > /etc/firewall.conf
#
echo -n "#"      > /etc/network/if-up.d/iptables
echo -n !       >> /etc/network/if-up.d/iptables
echo /bin/sh    >> /etc/network/if-up.d/iptables
echo "iptables-restore < /etc/firewall.conf" >> /etc/network/if-up.d/iptables
#
chmod +x /etc/network/if-up.d/iptables

