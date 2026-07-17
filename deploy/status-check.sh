# Source - https://stackoverflow.com/a/46913790
# Posted by Chris Gillatt, modified by community. See post 'Timeline' for change history
# Retrieved 2026-07-17, License - CC BY-SA 4.0

# doesn't work


#!/bin/bash

status_code=$(curl --write-out %{http_code} --silent --output https://module-handbook-staging.f4.htw-berlin.de)

if [[ "$status_code" -ne 200 ]] ; then
  echo "Site status changed to $status_code" #| mail -s "SITE STATUS CHECKER" "my_email@email.com" -r "STATUS_CHECKER"
  exit status_code
else
  exit 0
fi
