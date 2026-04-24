// Jenkins Pipeline with Nginx Reverse Proxy

pipeline {
    agent any
    
    environment {
        PROJECT_DIR = '/home/alite-148/Task/fullstack-project'
    }
    
    stages {
        stage('Git Checkout') {
            steps {
                echo "Step 1: Getting the latest code from GitHub..."
                checkout scm
                sh 'git config core.filemode false'
            }
        }
        
        stage('Stop Previous PM2') {
            steps {
                echo "Step 2: Stopping previous PM2 processes..."
                sh 'pm2 kill || true'
            }
        }
        
        stage('Deploy Backend') {
            steps {
                echo "Step 3: Deploying Flask Backend..."
                dir("${PROJECT_DIR}/backend") {
                    sh '''
                        source venv/bin/activate
                        pip install -r requirements.txt --quiet
                        pm2 start ecosystem.config.js
                    '''
                }
            }
        }
        
        stage('Deploy Frontend') {
            steps {
                echo "Step 4: Deploying Angular SSR Frontend..."
                dir("${PROJECT_DIR}/frontend") {
                    sh '''
                        npm install
                        npm run build
                        pm2 start ecosystem.config.js
                    '''
                }
            }
        }
        
        stage('Configure Nginx') {
            steps {
                echo "Step 5: Configuring Nginx reverse proxy..."
                sh '''
                    # Remove old symlink if exists
                    sudo rm -f /etc/nginx/sites-enabled/fullstack-project
                    # Create new symlink
                    sudo ln -s /home/alite-148/Task/fullstack-project/nginx.conf /etc/nginx/sites-enabled/fullstack-project
                    # Test and reload nginx
                    sudo nginx -t
                    sudo systemctl reload nginx
                '''
            }
        }
        
        stage('Health Checks') {
            steps {
                echo "Step 6: Running health checks..."
                sh '''
                    sleep 5
                    echo "=== Backend API Test (via nginx) ==="
                    curl -s http://localhost/api/message
                    echo ""
                    echo "=== Frontend Test (via nginx) ==="
                    curl -s http://localhost/ | head -5
                    echo ""
                    echo "=== PM2 Status ==="
                    pm2 list
                '''
            }
        }
    }
    
    post {
        success {
            echo "✅ SUCCESS! Deployment completed via nginx!"
        }
        failure {
            echo "❌ FAILED! Check the logs above"
            sh 'pm2 logs --lines 50'
        }
    }
}
