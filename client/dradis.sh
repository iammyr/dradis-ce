#!/bin/bash

URL=http://0.0.0.0:3000/api/commands

if [ "$#" -lt 1 ]; then
    echo "You must pass to this script at least 1 bash command"
fi

# log commands to the server as a string
curl --verbose -X POST -H "Content-Type: application/json" -d {"line": "$*" } -u 'dread'  $URL

# execute commands locally
$*
