#

tt=$(date +%Y-%m-%d--%H-%M-%S)

for h in $(cat deploy/util/hosts)
do
    echo 
    echo "-----------   $h   -----------"
    echo
    short_name=$(echo $h | sed -e "s/\..*//g")

    #ssh local@$h "cat ~/.ssh/authorized_keys"
    dt=$(date +%Y-%m-%d)
    ssh-keygen -t ed25519 -C "gh@${short_name}-${dt}" -f secrets/new_keys/${short_name} -q
done
