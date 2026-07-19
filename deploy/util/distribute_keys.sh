#

#module-handbook.f4.htw-berlin.de #
for h in $(cat deploy/util/hosts)
do
    echo 
    echo "-----------   $h   -----------"
    echo
    short_name=$(echo $h | sed -e "s/\..*//g")
    <"secrets/keys/${short_name}.pub" ssh local@$h 'cat - >> .ssh/authorized_keys'

    
done
