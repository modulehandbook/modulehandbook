#!/bin/bash

ENV=imi_production
TAG=$(git -c 'versionsort.suffix=-' \
    ls-remote --exit-code --refs --sort='version:refname' --tags origin '*.*.*' \
    | tail --lines=1 \
    | cut -d '/' -f 3)
#    | cut --delimiter='/' --fields=3


deploy/deploy.sh $ENV $TAG