#!/bin/bash

# Setup script for full-stack project

echo "Setting up backend..."
cd "$(dirname "$0")/../backend"
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt

echo "Setting up frontend..."
cd "$(dirname "$0")/../frontend"
npm install

echo "Setup complete!"