
for i in $(unzip -p github-action-ips.zip); do
   echo "iptables -A INPUT -p tcp -s $i --dport 22 -j ACCEPT"
done
