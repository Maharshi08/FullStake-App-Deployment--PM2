#!/bin/bash

# Run backend in DEVELOPMENT mode on port 5000 with auto-reload

echo "Starting backend in DEVELOPMENT mode on port 5000..."
cd "$(dirname "$0")/../backend"

source venv/bin/activate
export FLASK_ENV=development
export PORT=5000

python app.py
