#!/bin/zsh

while true; do
    clear

    if [[ "$1" == "system" ]]
    then
      bin/rails test:system
    elif [[ "$1" == "lint" ]]
    then
      make static_code_checks
    else
      bin/rails test
    fi



    fswatch -1 ./**/*.rb ./**/*.yml ./**/*.html.erb
done