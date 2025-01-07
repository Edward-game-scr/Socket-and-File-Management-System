#!/bin/bash

PORT=12345
FILE_DIR="/tmp/server_files"
mkdir -p "$FILE_DIR"

echo "Starting server on port $PORT..."
echo "Press Ctrl+C to stop the server."

while true; do
    # Listen for incoming connections
    nc -lk $PORT | while read -r REQUEST; do
        # Parse the client command
        COMMAND=$(echo "$REQUEST" | awk '{print $1}')
        FILENAME=$(echo "$REQUEST" | awk '{print $2}')
        CONTENT=$(echo "$REQUEST" | cut -d' ' -f3-)

        echo "Received command: $COMMAND, File: $FILENAME, Content: $CONTENT"

        if [[ "$COMMAND" == "WRITE" && -n "$FILENAME" && -n "$CONTENT" ]]; then
            # Append data to the file
            echo "$CONTENT" >> "$FILE_DIR/$FILENAME"
            echo "Data appended to $FILENAME"

        elif [[ "$COMMAND" == "READ" && -n "$FILENAME" ]]; then
            # Read data from the file
            FULL_PATH="$FILE_DIR/$FILENAME"
            if [[ -f "$FULL_PATH" ]]; then
                cat "$FULL_PATH"
            else
                echo "Error: File $FILENAME not found"
            fi
        elif [[ "$COMMAND" == "LIST" ]]; then
            # List all files in the directory
            FILE_LIST=$(ls -1 "$FILE_DIR")
            if [[ -z "$FILE_LIST" ]]; then
                echo "No files available."
            else
                echo "Available files:"
                echo "$FILE_LIST"
            fi
        elif [[ "$COMMAND" == "DELETE" && -n "$FILENAME" ]]; then
            # Delete the specified file
            FULL_PATH="$FILE_DIR/$FILENAME"
            if [[ -f "$FULL_PATH" ]]; then
                rm "$FULL_PATH"
                echo "File $FILENAME deleted."
            else
                echo "Error: File $FILENAME not found."
            fi
        elif [[ "$COMMAND" == "EXIT" ]]; then
            echo "Shutting down the server..."
            exit 0
        else
            # Handle invalid commands
            echo "Error: Invalid command or arguments."
        fi
    done
done
