#

tt=$(date +%Y-%m-%d--%H-%M-%S)
outputdir=output/firewall-conf/$tt
mkdir -p $outputdir

for h in   module-handbook-staging.f4.htw-berlin.de mh-imi.f4.htw-berlin.de module-handbook.f4.htw-berlin.de
do
    echo 
    echo "-----------   $h   -----------"
    echo
    
    scp local@$h:/etc/firewall.conf $outputdir/firewall-$h.conf
done
/etc/firewall.conf