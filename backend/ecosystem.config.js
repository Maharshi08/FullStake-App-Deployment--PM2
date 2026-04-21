module.exports = {
  apps: [
    {
      name: "flask-backend",

      script: "gunicorn",

      args: "-w 2 -b 127.0.0.1:8010 app:app",

      interpreter: "./venv/bin/python",

      env_production: {
        PORT: 8010,
        FLASK_ENV: "production"
      },

      autorestart: true
    }
  ]
};