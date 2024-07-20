
#!/bin/bash

while true; do
    clear

    if [ "$1" == "system" ]
    then
      bin/rails test:system
    else
      bin/rails test
    fi

    fswatch **/*.rb -1
    
done