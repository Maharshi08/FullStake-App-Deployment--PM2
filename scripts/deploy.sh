#!/bin/bash

# Deploy script for backend

echo "Deploying backend..."
cd "$(dirname "$0")/../backend"
pm2 restart ecosystem.config.js --env production

echo "Deployment complete!"