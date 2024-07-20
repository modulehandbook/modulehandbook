
#!/bin/bash

while true; do
    clear
    
    bin/rails test
    bin/rails test:system
    fswatch **/*.rb -1
    
done