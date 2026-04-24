pipeline {
    agent any

    stages {

        stage('Git Checkout') {
            steps {
                echo "Step 1: Getting latest code..."
                checkout scm
            }
        }

        stage('Stop Previous Processes') {
            steps {
                echo "Step 2: Cleaning old processes and ports..."
                sh '''
                    pm2 kill || true

                    # Kill ports to avoid loop issue
                    fuser -k 8010/tcp || true
                    fuser -k 4000/tcp || true

                    sleep 2
                '''
            }
        }

        stage('Deploy Backend') {
            steps {
                dir("backend") {
                    sh '''
                        echo "Step 3: Deploying Backend..."

                        python3 -m venv venv
                        ./venv/bin/pip install -r requirements.txt --quiet

                        pm2 start ecosystem.config.js

                        pm2 save
                        pm2 list
                    '''
                }
            }
        }

        stage('Deploy Frontend') {
            steps {
                dir("frontend") {
                    sh '''
                        echo "Step 4: Deploying Frontend..."

                        npm install
                        npm run build

                        # Fail fast if SSR build missing
                        if [ ! -f dist/frontend/server/server.mjs ]; then
                            echo "SSR build failed"
                            exit 1
                        fi

                        pm2 start ecosystem.config.js

                        pm2 save
                    '''
                }
            }
        }

        stage('Configure Nginx') {
            steps {
                echo "Step 5: Configuring Nginx..."
                sh '''
                    # Requires NOPASSWD sudo setup
                    sudo rm -f /etc/nginx/sites-enabled/fullstack-project
                    sudo ln -sf /home/alite-148/Task/fullstack-project/nginx.conf /etc/nginx/sites-enabled/fullstack-project

                    sudo nginx -t
                    sudo systemctl reload nginx
                '''
            }
        }

        stage('Health Checks') {
            steps {
                sh '''
                    echo "Step 6: Running health checks..."
                    sleep 5

                    echo "Backend check:"
                    curl -f http://localhost/api/message || exit 1

                    echo "Frontend check:"
                    curl -f http://localhost/ || exit 1

                    echo "PM2 Status:"
                    pm2 list
                '''
            }
        }
    }

    post {
        success {
            echo "Deployment successful"
        }
        failure {
            echo "Deployment failed"
            sh 'pm2 logs --lines 50'
        }
    }
}