pipeline {
    agent any

    stages {

        stage('Git Checkout') {
            steps {
                echo "Step 1: Getting latest code..."
                checkout scm
            }
        }

        stage('Stop Previous PM2') {
            steps {
                sh 'pm2 delete all || true'
            }
        }

        stage('Deploy Backend') {
            steps {
                dir("backend") {
                    sh '''
                        python3 -m venv venv
                        ./venv/bin/pip install -r requirements.txt

                        pm2 delete flask-backend || true
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
                        npm install
                        npm run build

                        if [ ! -f dist/frontend/server/server.mjs ]; then
                            echo "SSR build failed"
                            exit 1
                        fi

                        pm2 delete angular-ssr || true
                        pm2 start ecosystem.config.js

                        pm2 save
                    '''
                }
            }
        }

        stage('Configure Nginx') {
            steps {
                sh '''
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
                    sleep 5

                    curl -f http://localhost/api/message || exit 1
                    curl -f http://localhost/ || exit 1

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