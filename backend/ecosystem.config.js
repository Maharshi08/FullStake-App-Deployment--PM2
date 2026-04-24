module.exports = {
  apps: [
    {
      name: "flask-backend",
      script: "./start.sh",
      interpreter: "bash",

      autorestart: true,
      max_restarts: 5,        //  LIMIT LOOP
      min_uptime: "10s",      // must run 10s or restart counts
      restart_delay: 5000,    // wait before restart

      error_file: "/var/lib/jenkins/.pm2/logs/flask-error.log",
      out_file: "/var/lib/jenkins/.pm2/logs/flask-out.log",

      env: {
        PYTHONUNBUFFERED: "1",
        FLASK_ENV: "production"
      }
    }
  ]
};