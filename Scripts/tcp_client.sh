#!/bin/bash

SERVER="localhost"
PORT=12345

echo "Connecting to server at $SERVER:$PORT..."
echo "Type your commands (WRITE <filename> <content>, READ <filename>, LIST, DELETE <filename>, EXIT):"

# Open a persistent connection to the server
exec 3<>/dev/tcp/$SERVER/$PORT

while true; do
    # Read user input
    read -p "> " REQUEST

    # Send the request to the server
    echo "$REQUEST" >&3

    # Handle EXIT locally
    if [[ "$REQUEST" == "EXIT" ]]; then
        echo "Exiting client..."
        break
    fi

    # Read and display the server's response
    RESPONSE=""
    while read -t 1 LINE <&3; do
        RESPONSE+="$LINE"$
    done
    echo -e "Server response:$RESPONSE"
done

# Close the connection
exec 3<&-
exec 3>&-
