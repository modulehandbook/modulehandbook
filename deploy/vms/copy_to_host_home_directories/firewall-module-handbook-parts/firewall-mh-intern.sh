
# ------------------------------------------------------------------------------------------
#
#     4. TEIL: INTERN: Speziell für Module-Handbook
#     This needs to be imported at the end, as the docker daemon 
#     is restarted
# ------------------------------------------------------------------------------------------
#
iptables -A OUTPUT -p tcp --dport 22 -j ACCEPT


# restart docker daemon 
# do this before saving, rules will be there
# probably not needed, as docker service will also be restarted after boot?

systemctl restart docker
