#!/bin/bash
# Full Stack SSR + Flask Build & Deploy Script

set -e

PROJECT_ROOT="/home/alite-148/Task/fullstack-project"
FRONTEND_DIR="$PROJECT_ROOT/frontend"
BACKEND_DIR="$PROJECT_ROOT/backend"

echo "======================================"
echo "  Full Stack SSR Build & Deploy"
echo "======================================"

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Function to print status
print_status() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_step() {
    echo -e "${YELLOW}→ $1${NC}"
}

# ============ STEP 1: Build Frontend ============
print_step "Building Angular frontend with SSR..."

cd "$FRONTEND_DIR"

# Install dependencies if needed
if [ ! -d "node_modules" ]; then
    print_status "Installing npm packages..."
    npm install
fi

# Build production SSR
npm run build:ssr

if [ -d "dist/frontend/server" ] && [ -f "dist/frontend/server/server.mjs" ]; then
    print_status "Frontend built successfully"
else
    echo -e "${RED}✗ Frontend build failed${NC}"
    exit 1
fi

# ============ STEP 2: Setup Python Backend ============
print_step "Setting up Python backend..."

cd "$BACKEND_DIR"

# Activate virtual environment
if [ ! -d ".venv" ] && [ ! -d "venv" ]; then
    print_status "Creating Python virtual environment..."
    python3 -m venv venv
fi

# Determine venv path
if [ -d "venv" ]; then
    VENV_PATH="venv"
else
    VENV_PATH=".venv"
fi

source "$VENV_PATH/bin/activate"

# Install requirements
if [ -f "requirements.txt" ]; then
    print_status "Installing Python packages..."
    pip install -q -r requirements.txt
fi

deactivate

# ============ STEP 3: Stop existing processes ============
print_step "Stopping existing PM2 processes..."

pm2 stop all 2>/dev/null || true
sleep 1

# ============ STEP 4: Start Flask backend ============
print_step "Starting Flask backend..."

cd "$BACKEND_DIR"
pm2 start ecosystem.config.js --interpreter="$VENV_PATH/bin/python" 2>/dev/null || \
pm2 start app.py --name="flask-backend" --interpreter="$VENV_PATH/bin/python" 2>/dev/null || \
pm2 start "gunicorn -w 2 -b 0.0.0.0:8010 app:app" --name="flask-backend" 2>/dev/null

print_status "Flask backend started on port 8010"

# ============ STEP 5: Start Angular SSR ============
print_step "Starting Angular SSR..."

cd "$FRONTEND_DIR"
pm2 start ecosystem.config.js

print_status "Angular SSR started on port 4000"

# ============ STEP 6: Verify Services ============
print_step "Verifying services..."

sleep 2

echo ""
print_status "PM2 Process Status:"
pm2 list

echo ""
print_step "Testing Flask API..."
FLASK_TEST=$(curl -s http://localhost:8010/api/message | grep -o "Hello" || echo "")
if [ ! -z "$FLASK_TEST" ]; then
    print_status "Flask API responding ✓"
else
    echo -e "${RED}✗ Flask API not responding${NC}"
fi

echo ""
print_step "Testing Angular SSR..."
SSR_TEST=$(curl -s http://localhost:4000 | grep -o "Full Stack App" || echo "")
if [ ! -z "$SSR_TEST" ]; then
    print_status "Angular SSR responding ✓"
else
    echo -e "${YELLOW}⚠ Angular SSR page not loading (might need browser check)${NC}"
fi

echo ""
echo "======================================"
print_status "Deployment complete!"
echo "======================================"
echo ""
echo "URLs:"
echo "  Angular SSR: http://localhost:4000"
echo "  Flask API: http://localhost:8010"
echo "  API Test: curl http://localhost:4000/api/message"
echo ""
echo "Logs:"
echo "  View all: pm2 logs"
echo "  Flask: pm2 logs flask-backend"
echo "  Angular: pm2 logs angular-ssr"
echo ""
