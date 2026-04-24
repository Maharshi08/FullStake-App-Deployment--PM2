#!/bin/bash

# Enable strict error handling
set -euo pipefail

echo "======================================"
echo "Starting Full Deployment..."
echo "======================================"
echo "Current User: $(whoami)"
echo "Current Directory: $(pwd)"
echo "Shell: $SHELL"
echo ""

BASE_DIR="${BASE_DIR:-/home/alite-148/Task/fullstack-project}"
echo "Base Directory: $BASE_DIR"

cd "$BASE_DIR" || { echo "ERROR: Cannot cd to $BASE_DIR"; exit 1; }

echo ""
echo "======================================"
echo "Pull latest code..."
echo "======================================"
# Fix git permission issues in Jenkins
if [ -d .git ]; then
    echo "Fixing .git directory permissions..."
    git config core.filemode false || true
fi

if ! git pull origin master 2>&1; then
    echo "WARNING: Git pull failed, continuing anyway..."
fi

# =========================
# BACKEND SETUP
# =========================
echo ""
echo "======================================"
echo "Backend setup..."
echo "======================================"

cd "$BASE_DIR/backend" || { echo "ERROR: Cannot cd to backend"; exit 1; }

echo "Current directory: $(pwd)"
echo "Python version: $(python3 --version 2>&1 || echo 'Python not found')"

# Create/activate virtual environment if it doesn't exist
if [ ! -d venv ]; then
    echo "Creating virtual environment..."
    python3 -m venv venv
fi

# Activate venv in current shell
echo "Activating virtual environment..."
source venv/bin/activate

echo "Active Python: $(which python)"
echo "Pip version: $(pip --version)"

# Install/upgrade dependencies
echo "Installing dependencies..."
pip install --upgrade pip
pip install -r requirements.txt || { echo "ERROR: Failed to install requirements"; exit 1; }

echo "Checking gunicorn installation: $(which gunicorn || echo 'Not found')"

# Stop old PM2 instance
echo "Stopping old backend PM2 instance..."
pm2 delete flask-backend 2>/dev/null || true
sleep 1

# Start backend with PM2 (PM2 will keep venv context)
echo "Starting backend with PM2..."
if ! pm2 start ecosystem.config.js 2>&1; then
    echo "ERROR: Failed to start backend with PM2"
    echo "PM2 list:"
    pm2 list || true
    exit 1
fi

echo "Waiting for backend to start..."
sleep 3

echo "Backend PM2 status:"
pm2 show flask-backend 2>/dev/null || pm2 list || true

echo "Deactivating venv..."
deactivate 2>/dev/null || true

cd "$BASE_DIR"

# =========================
# FRONTEND SETUP
# =========================
echo ""
echo "======================================"
echo "Frontend setup..."
echo "======================================"

cd "$BASE_DIR/frontend" || { echo "ERROR: Cannot cd to frontend"; exit 1; }

echo "Current directory: $(pwd)"
echo "Node version: $(node --version || echo 'Node not found')"
echo "Npm version: $(npm --version || echo 'Npm not found')"

echo "Cleaning old build artifacts..."
rm -rf node_modules dist || true

echo "Installing npm dependencies..."
if ! npm install --production=false 2>&1; then
    echo "ERROR: Failed to install npm dependencies"
    exit 1
fi

echo "Building frontend SSR..."
if ! npm run build 2>&1; then
    echo "ERROR: Failed to build frontend"
    exit 1
fi

# Stop old PM2 instance
echo "Stopping old frontend PM2 instance..."
pm2 delete angular-ssr 2>/dev/null || true
sleep 1

# Start frontend
echo "Starting frontend with PM2..."
if ! pm2 start ecosystem.config.js 2>&1; then
    echo "ERROR: Failed to start frontend with PM2"
    echo "PM2 list:"
    pm2 list || true
    exit 1
fi

echo "Waiting for frontend to start..."
sleep 3

echo "Frontend PM2 status:"
pm2 show angular-ssr 2>/dev/null || pm2 list || true

cd "$BASE_DIR"

# =========================
# SAVE PM2 CONFIGURATION
# =========================
echo ""
echo "======================================"
echo "Saving PM2 configuration..."
echo "======================================"

pm2 save || true

echo ""
echo "======================================"
echo "Deployment Completed Successfully!"
echo "======================================"
echo ""
echo "Running PM2 instances:"
pm2 list

echo ""
echo "Backend health check:"
echo "curl http://127.0.0.1:8010/api/message"

echo ""
echo "Frontend health check:"
echo "curl http://localhost:4000"