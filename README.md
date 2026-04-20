# Full Stack Project

A full-stack application with Python Flask backend and Angular frontend.

## 🔧 Development vs Production

### **DEVELOPMENT MODE** (Port 5000)
- Auto-reload when you edit code
- Changes reflect immediately
- Use this while coding

### **PRODUCTION MODE** (Port 8010)
- Requires manual deployment
- Changes need to be deployed with `./scripts/deploy.sh`
- Stable, used for production

---

## 🚀 Quick Start

### 1. Setup (One-time only)
```bash
./scripts/setup.sh
```

### 2A. Development (Auto-reload)
```bash
./scripts/dev.sh
```
- Backend runs on http://localhost:5000
- Edit `backend/app.py` and see changes immediately

### 2B. Production (Manual deploy)
```bash
./scripts/build.sh    # Build frontend
./scripts/deploy.sh   # Deploy backend
```
- Backend runs on http://localhost:8010
- Edit `backend/app.py` then run `./scripts/deploy.sh` to update

---

## 📋 Important Differences

| Feature | Dev (Port 5000) | Prod (Port 8010) |
|---------|---|---|
| Port | 5000 | 8010 |
| Auto-reload | ✅ Yes | ❌ No |
| Debug Mode | ✅ Yes | ❌ No |
| Edit & Test | Instant | Manual restart needed |
| When to use | Development | Deployment |

---

## 📁 Project Structure

```
fullstack-project/
├── backend/
│   ├── app.py                    # Flask application
│   ├── config.py                 # Configuration
│   ├── ecosystem.config.js       # Production config
│   ├── ecosystem.dev.js          # Development config
│   └── requirements.txt
│
├── frontend/
│   ├── src/
│   │   └── app/app.component.ts  # Angular app
│   └── dist/                     # Built files
│
└── scripts/
    ├── setup.sh                  # Install dependencies
    ├── dev.sh                    # Run development
    ├── build.sh                  # Build frontend
    └── deploy.sh                 # Deploy production
```

---

## 🔗 API Endpoints

- **GET** `/api/message` → Get a greeting message
- **POST** `/api/echo` → Echo back a message
- **GET** `/` → Serves the Angular frontend

---

## 🛠️ Commands Reference

| Command | Purpose | Port |
|---------|---------|------|
| `./scripts/setup.sh` | Install all dependencies | - |
| `./scripts/dev.sh` | Run in development mode | 5000 |
| `./scripts/build.sh` | Build frontend for production | - |
| `./scripts/deploy.sh` | Deploy backend to production | 8010 |

---

## ⚡ Workflow

### **Development:**
```bash
# Terminal 1: Backend
./scripts/dev.sh

# Terminal 2: Frontend (optional, for dev server)
cd frontend && ng serve
```

### **Production:**
```bash
# Build frontend
./scripts/build.sh

# Deploy backend
./scripts/deploy.sh

# Visit http://localhost:8010
```

---

## 🔄 Making Changes

### **Editing Backend (app.py)**
- In dev mode: Changes appear automatically
- In prod mode: Need to run `./scripts/deploy.sh` after editing

### **Editing Frontend (Angular)**
- In dev mode: Use `ng serve` for live reload
- In prod mode: Run `./scripts/build.sh` then `./scripts/deploy.sh`

---

## 📊 What Happens When You Start

### Development (`./scripts/dev.sh`)
```
app.py → Flask debug server → Port 5000
Auto-reload enabled ✅
Changes detected → Restart automatic
```

### Production (`./scripts/deploy.sh`)
```
app.py → PM2 → Gunicorn → Port 8010
Auto-reload disabled ❌
Changes need manual restart
```