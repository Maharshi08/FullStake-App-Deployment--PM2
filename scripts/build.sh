#!/bin/bash

# Build script for frontend

echo "Building frontend..."
cd "$(dirname "$0")/../frontend"
npm run build

echo "Build complete!"