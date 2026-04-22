#!/bin/bash
set -e

echo "Starting Full Deployment..."

BASE_DIR="$(cd "$(dirname "$0")/.." && pwd)"

FRONTEND_DIR="$BASE_DIR/frontend"
BACKEND_DIR="$BASE_DIR/backend"

# =========================
# BACKEND (Flask)
# =========================
echo "Starting Flask backend..."
cd "$BACKEND_DIR"

# Use python directly instead of activate
pm2 stop flask-backend 2>/dev/null || true
pm2 delete flask-backend 2>/dev/null || true

pm2 start app.py \
  --name flask-backend \
  --interpreter "$BACKEND_DIR/venv/bin/python3"

# =========================
# FRONTEND (Angular)
# =========================
echo "Building Angular..."
cd "$FRONTEND_DIR"

rm -rf node_modules dist
npm ci
npm run build

echo "Starting Angular..."
pm2 stop angular-ssr 2>/dev/null || true
pm2 delete angular-ssr 2>/dev/null || true

pm2 start ecosystem.config.js

# =========================
# SAVE PM2 STATE
# =========================
pm2 save

echo "Deployment Complete!"