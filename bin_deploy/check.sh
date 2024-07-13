#!/bin/bash


SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && cd .. && pwd )


f_tag=${SCRIPT_DIR}/container_nudge/tag
f_sha=${SCRIPT_DIR}/container_nudge/sha
if test -f $f_tag && test -f $f_sha
then 
    tag=$(cat $f_tag)
    sha=$(cat $f_sha)
    echo $tag
    echo $sha
    sudo mv $f_tag ${f_tag}_done
    sudo mv $f_sha ${f_sha}_done
    ${SCRIPT_DIR}/bin_deploy/staging.sh $tag $sha
fi
