#!/bin/bash

# Nginx management script for Full Stack Project

PROJECT_ROOT="/home/alite-148/Task/fullstack-project"
NGINX_CONF="$PROJECT_ROOT/nginx.conf"

if [ "$1" = "start" ]; then
    echo "Starting Nginx with custom config..."
    sudo nginx -c $NGINX_CONF
    echo "Nginx started on port 80"
    echo "Visit: http://localhost"

elif [ "$1" = "stop" ]; then
    echo "Stopping Nginx..."
    sudo nginx -s stop
    echo "Nginx stopped"

elif [ "$1" = "restart" ]; then
    echo "Restarting Nginx..."
    sudo nginx -s stop
    sleep 1
    sudo nginx -c $NGINX_CONF
    echo "Nginx restarted on port 80"

elif [ "$1" = "test" ]; then
    echo "Testing Nginx configuration..."
    sudo nginx -t -c $NGINX_CONF

elif [ "$1" = "status" ]; then
    echo "Nginx status:"
    ps aux | grep nginx | grep -v grep

else
    echo "Usage: ./scripts/nginx.sh [start|stop|restart|test|status]"
    echo ""
    echo "Commands:"
    echo "  start   - Start Nginx on port 80"
    echo "  stop    - Stop Nginx"
    echo "  restart - Restart Nginx"
    echo "  test    - Test configuration syntax"
    echo "  status  - Show Nginx processes"
fi
