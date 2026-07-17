for e in development test staging production ; do 
    k=$(cat "config/credentials/$e.key")
    echo $k --- $e
done
