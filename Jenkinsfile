pipeline {
    agent any

    environment {
        PM2_HOME = "/var/lib/jenkins/.pm2"
    }

    stages {

        stage('Stop Previous Processes') {
            steps {
                sh '''
                    pm2 delete all || true

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
                        python3 -m venv venv
                        ./venv/bin/pip install -r requirements.txt --quiet

                        pm2 start ecosystem.config.js

                        sleep 3
                        pm2 list | grep flask-backend || (echo "Backend failed" && exit 1)
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

                        mkdir -p logs
                        chmod -R 755 logs

                        pm2 start ecosystem.config.js

                        sleep 5
                        pm2 list | grep angular-ssr || (echo "Frontend failed" && exit 1)
                    '''
                }
            }
        }

        stage('Configure Nginx') {
            steps {
                sh '''
                    sudo rm -f /etc/nginx/sites-enabled/fullstack-project
                    sudo ln -sf /home/alite-148/Task/fullstack-project/nginx.conf /etc/nginx/sites-enabled/fullstack-project

                    sudo nginx -t || (echo "Nginx config failed" && exit 1)
                    sudo systemctl reload nginx || (echo "Nginx reload failed" && exit 1)
                '''
            }
        }

        stage('Health Checks') {
            steps {
                sh '''
                    sleep 5

                    curl -f http://localhost/api/message || (echo "Backend failed" && exit 1)
                    curl -f http://localhost/ || (echo "Frontend failed" && exit 1)

                    pm2 list
                '''
            }
        }
    }
}