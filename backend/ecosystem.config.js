module.exports = {
  apps: [
    {
      name: "flask-backend",

      script: "gunicorn",

      args: "-w 2 -b 0.0.0.0:8010 app:app",

      interpreter: "./venv/bin/python",

      env: {
        FLASK_ENV: "development",
        PORT: 8010
      },

      watch: ["."],
      ignore_watch: ["venv", "__pycache__", "*.log"],

      env_production: {
        FLASK_ENV: "production",
        PORT: 8010
      }
    }
  ]
};
