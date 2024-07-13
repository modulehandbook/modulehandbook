#!/bin/bash

f_tag=nudge/tag
f_sha=nudge/sha
if test -f $f_tag && test -f $f_sha
then 
    tag=$(cat $f_tag)
    sha=$(cat $f_sha)
    echo $tag
    echo $sha
    mv $f_tag ${f_tag}_done
    mv $f_sha ${f_sha}_done
    ./bin_deploy/staging.sh $tag $sha
fi
