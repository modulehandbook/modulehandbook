
# Firewall Rules for the Module-Handbook

The firewall scripts are copied with the deployment.

To re-generate the zip with the github action host ips, run 

gh-download-ips.sh


local@module-handbook:~$ diff firewall.sh firewall-module-handbook.sh
67a68,73
>
> #
> # Include Rules for Module-Handbook
> #
> ./firewall-module-handbook-parts/firewall-mh-extern.sh
>
117a124,130
>
> #
> # Include Rules for Module-Handbook
> #
> ./firewall-module-handbook-parts/firewall-mh-intern.sh
>
>
