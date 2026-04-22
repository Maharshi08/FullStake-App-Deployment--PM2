module.exports = {
  apps: [
    {
      name: "flask-backend",

      script: "./venv/bin/gunicorn",  

      args: "-w 2 -b 127.0.0.1:8010 app:app",

      cwd: "/home/alite-148/Task/fullstack-project/backend",

      interpreter: "none",   

      autorestart: true
    }
  ]
};
