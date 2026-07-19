#

tt=$(date +%Y-%m-%d--%H-%M-%S)

for h in   module-handbook-staging.f4.htw-berlin.de mh-imi.f4.htw-berlin.de module-handbook.f4.htw-berlin.de
do
    echo 
    echo "-----------   $h   -----------"
    echo
    ssh local@$h "docker compose down" 
done
