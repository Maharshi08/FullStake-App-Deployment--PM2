# Angular SSR + Flask Backend Setup Guide

## ✅ Issues Fixed

### 1. **SSR Memory Heap Crash**
**Problem:** Angular component was calling API in constructor → SSR repeated calls infinitely → memory buildup → crash

**Solution:** 
- Moved API calls from `constructor` to `ngOnInit()`
- Added `isPlatformBrowser()` check to skip API calls during SSR
- Only browser renders will fetch data, server-side renders serve static HTML

**Files Changed:** `frontend/src/app/app.component.ts`

### 2. **Proxy URL Misconfiguration**
**Problem:** `environment.apiUrl` used `http://localhost:8010/api` → doesn't work in SSR context

**Solution:**
- Changed to relative path: `/api`
- Works in both SSR (proxied by Express) and browser (proxied by Nginx)

**Files Changed:** `frontend/src/environments/environment.ts`

### 3. **Node.js Memory Limit**
**Problem:** PM2 running with default 512MB heap limit → crashes under SSR load

**Solution:**
- Added `NODE_OPTIONS: "--max-old-space-size=1024"` → 1GB heap
- Added `max_memory_restart: "800M"` → auto-restart if exceeds 800MB

**Files Changed:** `frontend/ecosystem.config.js`

### 4. **Flask CORS Issues**
**Problem:** SSR proxy couldn't communicate with Flask properly due to CORS headers

**Solution:**
- Configured CORS specifically for SSR proxy
- Added OPTIONS handling for POST requests
- Better error handling for requests

**Files Changed:** `backend/app.py`

### 5. **Proxy Error Handling**
**Problem:** No error logging when proxy failed

**Solution:**
- Added `onError` handler in Express proxy middleware
- Better error responses to client

**Files Changed:** `frontend/server.ts`

---

## 🚀 Testing Checklist

### Phase 1: Backend Setup
```bash
# 1. Start Flask backend
cd /home/alite-148/Task/fullstack-project
source .venv/bin/activate
python backend/app.py

# 2. Test Flask APIs
curl http://localhost:8010/api/message
curl -X POST http://localhost:8010/api/echo -H "Content-Type: application/json" -d '{"message":"test"}'
```

Expected responses:
```json
{"message": "Hello from Flask Backend!"}
{"echo": "test"}
```

### Phase 2: Build Frontend
```bash
# Build Angular with SSR
cd frontend
npm run build:ssr

# Verify build output
ls -la dist/frontend/server/
ls -la dist/frontend/browser/
```

### Phase 3: Test SSR Locally (Dev)
```bash
# Terminal 1: Start Flask backend
cd backend
source ../.venv/bin/activate
python app.py

# Terminal 2: Start SSR server (Node directly)
cd frontend
NODE_OPTIONS="--max-old-space-size=1024" node dist/frontend/server/server.mjs

# Terminal 3: Test SSR requests
curl http://localhost:4000/api/message
curl http://localhost:4000

# Check if browser can load
open http://localhost:4000
```

### Phase 4: PM2 Production Deployment
```bash
# 1. Stop any existing processes
pm2 stop all
pm2 delete all

# 2. Build frontend (production)
cd frontend
npm run build:ssr

# 3. Deploy Flask backend
pm2 start ecosystem.config.js --cwd /home/alite-148/Task/fullstack-project/backend

# 4. Deploy Angular SSR
pm2 start frontend/ecosystem.config.js

# 5. Verify
pm2 list
pm2 logs

# 6. Test
curl http://localhost:4000/api/message
curl http://localhost:4000
```

### Phase 5: Full Stack with Nginx
```bash
# Update Nginx config to proxy to SSR (port 4000) instead of static files
sudo nano /etc/nginx/sites-available/fullstack

# Configuration should be:
server {
    listen 80;
    server_name localhost;

    # Proxy all traffic to Angular SSR on port 4000
    location / {
        proxy_pass http://127.0.0.1:4000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}

# Test and restart
sudo nginx -t
sudo systemctl restart nginx

# Test
curl http://localhost
```

---

## 📊 Architecture After Fixes

```
Browser (http://localhost)
        ↓
      Nginx (port 80)
        ↓
    Angular SSR (port 4000) ← express-server
        ↓
    Proxy Middleware (/api)
        ↓
    Flask Backend (port 8010)
        ↓
    API Routes (/api/message, /api/echo)
```

**Data Flow:**
1. Browser requests `http://localhost`
2. Nginx forwards to Angular SSR on port 4000
3. Express server renders page + injects API response
4. Express proxy intercepts `/api/*` → forwards to Flask
5. Angular `ngOnInit` makes browser-side API calls
6. Browser requests `/api/message` → Express proxy → Flask

---

## 🔧 Key Environment Variables

### Frontend (.env or ecosystem.config.js)
```
PORT=4000
NODE_ENV=production
NODE_OPTIONS=--max-old-space-size=1024
```

### Backend (.env)
```
PORT=8010
FLASK_ENV=production
```

---

## 💾 File Changes Summary

| File | Change | Reason |
|------|--------|--------|
| `app.component.ts` | Moved API to `ngOnInit()`, added `isPlatformBrowser` | Prevent SSR API calls |
| `environment.ts` | Changed URL to `/api` | Relative URL works in SSR |
| `environment.prod.ts` | Already has `/api` | No change needed |
| `ecosystem.config.js` | Added memory limits and Node options | Prevent heap crashes |
| `server.ts` | Added error handler to proxy | Better error handling |
| `app.py` | Enhanced CORS + error handling | SSR compatibility |

---

## 🐛 Troubleshooting

### Issue: Memory still crashing
**Solution:** Increase `max-old-space-size` further or reduce payload sizes

### Issue: API returns 404
**Solution:** Check Flask is running on port 8010 and CORS is enabled

### Issue: Blank page in browser
**Solution:** Check browser console for errors, verify SSR renders correctly

### Issue: SSR takes too long to render
**Solution:** Reduce number of API calls in component initialization, use preloading strategies

### Issue: PORT already in use
```bash
lsof -i :4000  # Find process on port 4000
kill -9 <PID>  # Kill process
```

---

## 📝 Production Deployment Steps

1. Build frontend: `npm run build:ssr`
2. Test locally first
3. Update PM2 configs with correct paths
4. Start with: `pm2 start ecosystem.config.js`
5. Verify: `pm2 logs`
6. Configure Nginx proxy
7. Test full stack: `curl http://localhost/api/message`
