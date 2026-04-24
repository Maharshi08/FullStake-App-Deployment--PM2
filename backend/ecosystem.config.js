module.exports = {
  apps: [
    {
      name: "flask-backend",
      script: "venv/bin/gunicorn",
      args: "app:app -b 0.0.0.0:8010",
      cwd: "/home/alite-148/Task/fullstack-project/backend",
      interpreter: "none",
      env: {
        PYTHONUNBUFFERED: "1",
        FLASK_ENV: "production"
      }
    }
  ]
};