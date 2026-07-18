
for i in $(curl -s https://api.github.com/meta | python3 -c "import sys, json; print(' '.join(json.load(sys.stdin)['actions']))"); do
   # echo "iptables -A INPUT -p tcp -s $i --dport 22 -j ACCEPT"
   echo $i
done
