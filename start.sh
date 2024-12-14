#!/bin/bash

# Start gammu-smsd in the background
gammu-smsd --config /etc/gammu-smsd/gammu-smsdrc --daemon

# Start the Node.js API server
node /app/app.js
