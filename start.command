#!/bin/bash
# Homeland Regalia Dashboard — Local Server
# Double-click this file to launch the dashboard in your browser.

# Move to the folder containing this script
cd "$(dirname "$0")"

echo ""
echo "  ╔══════════════════════════════════════════╗"
echo "  ║   Homeland Regalia — Local Dashboard     ║"
echo "  ║   http://localhost:8080                  ║"
echo "  ╚══════════════════════════════════════════╝"
echo ""
echo "  Starting local server..."
echo "  Press Ctrl+C to stop."
echo ""

# Open the browser after a 1-second delay
(sleep 1 && open http://localhost:8080) &

# Start the Python server
python3 -m http.server 8080
