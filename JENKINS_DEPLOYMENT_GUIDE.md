# Jenkins Deployment - Beginner's Guide

## What is Jenkins?
Jenkins is a tool that automatically runs your deployment script whenever you push code to GitHub.

---

## The 3 Problems We Fixed

### Problem 1: Git Permission Error
**Error Message**: `error: cannot open '.git/FETCH_HEAD': Permission denied`

**Why it happened**: Jenkins runs as a different user than you, so it can't access your `.git` folder.

**How we fixed it**: Added this line to disable file permission checks:
```bash
git config core.filemode false
```

---

### Problem 2: Backend Won't Start
**Why it happened**: 
- Virtual environment (venv) wasn't activated when PM2 tried to start the backend
- PM2 couldn't find gunicorn because venv wasn't active
- It worked locally because you manually activate venv first

**How we fixed it**:
```bash
source venv/bin/activate    # Activate venv FIRST
pip install -r requirements.txt  # Install packages
pm2 start ecosystem.config.js    # THEN start PM2
```

**Result**: Frontend works + Backend works ✅

---

### Problem 3: Hardcoded Paths Break
**Why it happened**: 
- Old config used `/home/alite-148/...` paths
- Jenkins runs as different user, these paths don't exist

**How we fixed it**:
```javascript
// Old (doesn't work)
cwd: "/home/alite-148/Task/fullstack-project/backend"

// New (works everywhere)
cwd: __dirname  // Uses current folder location
```

---

## How to Set Up Jenkins

### Step 1: Create a New Job
1. Open Jenkins UI: `http://your-jenkins-server:8080`
2. Click **"Create a job"**
3. Enter job name: `fullstack-deploy`
4. Select **"Pipeline"**
5. Click **OK**

### Step 2: Configure the Job
1. Under **Pipeline**, select **"Pipeline script from SCM"**
2. Choose **Git** as SCM
3. Enter Repository URL: `https://github.com/Maharshi08/FullStake-App-Deployment--PM2.git`
4. Leave Branch as `*/master`
5. Click **Save**

That's it! Jenkins will automatically use the `Jenkinsfile` from your repo.

---

## The Jenkinsfile Explained (Simple Version)

```groovy
pipeline {
    agent any    // Run on any available machine
    
    stages {     // These are the steps
        
        stage('Git Checkout') {
            steps {
                echo "Getting latest code from GitHub..."
                checkout scm                    // Download code
                sh 'git config core.filemode false'  // Fix permissions
            }
        }
        
        stage('Deploy') {
            steps {
                echo "Running deployment script..."
                sh 'chmod +x ./scripts/deploy.sh'  // Make executable
                sh './scripts/deploy.sh'           // Run it
            }
        }
        
        stage('Check Services') {
            steps {
                echo "Checking if services are running..."
                sh '''
                    sleep 5
                    pm2 list              // Show running services
                '''
            }
        }
    }
    
    post {        // After everything
        success {
            echo "✅ SUCCESS! Deployment completed!"
        }
        failure {
            echo "❌ FAILED! Check the logs above"
        }
    }
}
```

---

## How to Run a Build

### Option 1: Automatic (Recommended)
- Jenkins automatically builds when you push to GitHub
- Just push code: `git push origin master`
- Jenkins will trigger automatically

### Option 2: Manual
1. Open your Jenkins job
2. Click **"Build Now"** button
3. Watch the console output

---

## Checking the Build Results

### Success ✅
```
Step 1: Getting the latest code from GitHub...
Step 2: Running deployment script...
Step 3: Checking if services are running...
✅ SUCCESS! Deployment completed!
```

### Failure ❌
```
ERROR: Failed to install requirements
❌ FAILED! Check the logs above
```

**If failed**: Click **"Console Output"** to see error details

---

## Troubleshooting

### Backend not starting?
1. Click on failed build
2. Click **"Console Output"**
3. Look for error messages
4. Common issue: Check if port 8010 is already in use

### Git permission error?
Already fixed! The line `git config core.filemode false` handles this.

### Still having issues?

**Check manually on your server**:
```bash
cd /var/lib/jenkins/workspace/fullstack-deploy
./scripts/deploy.sh
pm2 list
```

---

## What Each File Does

### `scripts/deploy.sh`
Main script that:
1. Activates Python venv
2. Installs backend packages
3. Starts backend with PM2
4. Installs frontend packages
5. Builds and starts frontend

### `backend/ecosystem.config.js`
Configuration for running backend with PM2

### `frontend/ecosystem.config.js`
Configuration for running frontend with PM2

### `Jenkinsfile`
Instructions for Jenkins on what to do

---

## Testing Locally First (Recommended)

Before pushing to GitHub, test on your local machine:

```bash
cd /home/alite-148/Task/fullstack-project

# Run the deployment script
./scripts/deploy.sh

# Check if both services started
pm2 list

# Test backend
curl http://127.0.0.1:8010/api/message

# Test frontend
curl http://localhost:4000
```

If this works locally, it will work in Jenkins! ✅

---

## Simple Checklist

- ✅ Jenkinsfile created
- ✅ deploy.sh fixed
- ✅ ecosystem.config.js files updated
- ✅ Git pushed to GitHub
- ✅ Jenkins job created
- ✅ First build triggered

**Status**: Ready to deploy! 🚀

---

## Questions?

**Q: What if I don't want automatic builds?**
A: Just remove the GitHub webhook. Then only manual builds will trigger.

**Q: Can I rollback if deployment fails?**
A: Yes! You can checkout a previous Git commit in Jenkins.

**Q: What are the console logs?**
A: All the output from each step. Use them to debug if something fails.

---

**That's it! Keep it simple.** 😊

