#!/bin/bash

echo "Content-type: text/html"
echo ""

read QUERY_STRING

# Parse action and data
ACTION=$(echo "$QUERY_STRING" | grep -oP "(?<=action=)[^&]*")
DATA=$(echo "$QUERY_STRING" | grep -oP "(?<=data=)[^&]*")

# Sanitize the input data (allow only alphanumeric, spaces, and basic punctuation)
SANITIZED_DATA=$(echo "$DATA" | tr -d '\n' | sed 's/[^a-zA-Z0-9 .,!?-]//g')

# File path
DATA_FILE="/tmp/data.txt"

# Process actions
if [ "$ACTION" = "save" ]; then
    if [ -z "$SANITIZED_DATA" ]; then
        echo "<h1>Error: Empty or Invalid Data</h1>"
    else
        echo "$SANITIZED_DATA" >> "$DATA_FILE"
        echo "<h1>Data Saved!</h1>"
        echo "<p>Saved: $SANITIZED_DATA</p>"
    fi
elif [ "$ACTION" = "read" ]; then
    if [ -f "$DATA_FILE" ]; then
        echo "<h1>Data Read!</h1>"
        echo "<pre>$(cat "$DATA_FILE")</pre>"
    else
        echo "<h1>No Data Found!</h1>"
    fi
elif [ "$ACTION" = "clear" ]; then
    > "$DATA_FILE"
    echo "<h1>Data Cleared!</h1>"
else
    echo "<h1>Invalid Action</h1>"
    echo '<a href="/index.html">Back to Home</a>'
fi
