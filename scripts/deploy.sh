#!/bin/bash
set -e

echo " Starting Full Deployment..."

BASE_DIR="$(cd "$(dirname "$0")/.." && pwd)"

FRONTEND_DIR="$BASE_DIR/frontend"
BACKEND_DIR="$BASE_DIR/backend"

# =========================
# BACKEND (Flask)
# =========================
echo " Starting Flask backend..."
cd "$BACKEND_DIR"

source venv/bin/activate

pm2 stop flask-backend 2>/dev/null || true
pm2 delete flask-backend 2>/dev/null || true
pm2 start ecosystem.config.js --env production

# =========================
# FRONTEND (Angular SSR)
# =========================
echo "Building Angular SSR..."
cd "$FRONTEND_DIR"

npm install
npm run build

echo " Starting Angular SSR..."
pm2 stop angular-ssr 2>/dev/null || true
pm2 delete angular-ssr 2>/dev/null || true
pm2 start ecosystem.config.js

# =========================
# SAVE PM2 STATE
# =========================
pm2 save

echo " Deployment Complete!"