module.exports = {
  apps: [
    {
      name: "flask-dev",
      script: "app.py",
      interpreter: "./venv/bin/python",
      
      env: {
        FLASK_ENV: "development",
        PORT: 5000
      },

      watch: ["."],
      ignore_watch: ["venv", "__pycache__", "*.log"]
    }
  ]
};
