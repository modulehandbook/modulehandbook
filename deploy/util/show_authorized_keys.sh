#

tt=$(date +%Y-%m-%d--%H-%M-%S)

for h in $(cat deploy/util/hosts)
do
    echo 
    echo "-----------   $h   -----------"
    echo
    ssh local@$h "cat ~/.ssh/authorized_keys" 
done
