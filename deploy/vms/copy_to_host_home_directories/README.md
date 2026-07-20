# Certificates

go in `NGINX_CERTIFICATES_GO_HERE_PLEASE` 

The origin of the filenames (which are used in compose.yaml for the nginx config templates)
are the environment configuration files in `deploy/environments` which is copied (and amended)
to .env on the server.

# Firewall Rules for the Module-Handbook

The firewall configuration script is copied during the deployment.

run it with 

```
sudo ./firewall-module-handbook.sh
```

It should run for a while as a rule for approx. 4000 possible github action hosts are added.

It differs from the original firewall.sh only in two places:
Import for additional external rules and another import for additional
internal rules.

The imported files are in the folder `firewall-module-handbook-parts`.

The firewall.sh file is preserved for reference as firewall-original.sh in case it
should be updated. 


```
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
```


# Development

The firewall scripts are in the folder `copy_to_host_home_directories`
in the source code.

To re-generate the zip with the github action host ips, find and run 

`gh-download-ips.sh`


