#!/bin/bash

# Script to reproduce the SSR import error
# Runs vite --force repeatedly until the error is found (max 5 attempts)

ATTEMPT=1
MAX_ATTEMPTS=5
ERROR_PATTERN="Cannot access '__vite_ssr_import_"
LOG_FILE="/tmp/vite-output-$$.log"

cleanup() {
    rm -f "$LOG_FILE"
    exit 1
}
trap cleanup INT TERM

while [ $ATTEMPT -le $MAX_ATTEMPTS ]; do
    echo "Attempt #$ATTEMPT/$MAX_ATTEMPTS - Starting Vite..."
    
    # Start vite in background and capture output to file
    npx vite --force > "$LOG_FILE" 2>&1 &
    VITE_PID=$!
    
    # Wait 5 seconds
    sleep 5
    
    # Check if error appeared in the log
    if grep -q "$ERROR_PATTERN" "$LOG_FILE"; then
        echo ""
        echo "=========================================="
        echo "ERROR FOUND on attempt #$ATTEMPT!"
        echo "=========================================="
        cat "$LOG_FILE"
        kill $VITE_PID 2>/dev/null
        wait $VITE_PID 2>/dev/null
        rm -f "$LOG_FILE"
        exit 0
    fi
    
    # Kill vite
    kill $VITE_PID 2>/dev/null
    wait $VITE_PID 2>/dev/null
    
    ATTEMPT=$((ATTEMPT + 1))
    sleep 1
done

echo "No error found after $MAX_ATTEMPTS attempts - bug appears to be fixed"
rm -f "$LOG_FILE"
exit 1
