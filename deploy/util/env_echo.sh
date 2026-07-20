
for var_name in $(cat ./deploy/environments/necessary_env_variables); do
    # works only in bash
    #echo "$var_name=${!var_name}" 

    eval "echo ${var_name}=\$$var_name"
done
