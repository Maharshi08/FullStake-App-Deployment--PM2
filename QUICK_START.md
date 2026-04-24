# Quick Start - Jenkins Deployment (Beginner)

## What Was Wrong
1. ❌ Git permission error
2. ❌ Backend wouldn't start (venv not active)
3. ❌ Hardcoded paths broke

## What We Fixed
1. ✅ Git config fixed
2. ✅ Activate venv BEFORE PM2
3. ✅ Use portable paths

---

## How to Deploy to Jenkins (3 Steps)

### Step 1: Push Code
```bash
git add .
git commit -m "Fix Jenkins deployment"
git push origin master
```

### Step 2: Create Jenkins Job
1. Open Jenkins: `http://your-jenkins:8080`
2. Click: New Job
3. Name: `fullstack-deploy`
4. Choose: Pipeline
5. Pipeline → Pipeline script from SCM → Git
6. URL: `https://github.com/Maharshi08/FullStake-App-Deployment--PM2.git`
7. Click Save

### Step 3: Run Build
Jenkins will automatically build when you push! 

Or manually: Click "Build Now"

---

## Check Results

**Console Output** shows:
- Success: ✅ SUCCESS! Deployment completed!
- Failure: ❌ FAILED! Check the logs above

---

## Local Testing (Before Pushing)

```bash
cd /home/alite-148/Task/fullstack-project

# Test the script
./scripts/deploy.sh

# Check services
pm2 list

# Test backend
curl http://127.0.0.1:8010/api/message

# Test frontend  
curl http://localhost:4000
```

If this works → Jenkins will work! ✅

---

## Files Changed
- `scripts/deploy.sh` - Fixed venv activation
- `backend/ecosystem.config.js` - Portable paths
- `frontend/ecosystem.config.js` - Portable paths
- `Jenkinsfile` - New (Jenkins instructions)

---

## Done! 🎉

Questions? Check JENKINS_DEPLOYMENT_GUIDE.md for more details.
