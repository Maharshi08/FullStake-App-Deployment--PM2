#!/bin/bash
set -e

echo "Starting Full Deployment..."

BASE_DIR="/home/alite-148/Task/fullstack-project"

cd $BASE_DIR

echo "Pull latest code..."
git pull origin master

# =========================
# BACKEND SETUP
# =========================
echo "Backend setup..."

cd backend

# activate venv
source venv/bin/activate

# install deps (important)
pip install -r requirements.txt || true

# restart backend
pm2 delete flask-backend || true
pm2 start ecosystem.config.js

cd ..

# =========================
# FRONTEND SETUP
# =========================
echo "Frontend setup..."

cd frontend

rm -rf node_modules dist || true

npm install
npm run build

# restart frontend
pm2 delete angular-ssr || true
pm2 start ecosystem.config.js

cd ..

# =========================
# SAVE PM2
# =========================
pm2 save

echo "Deployment Completed!"