module.exports = {
  apps: [
    {
      name: "flask-backend",
      script: "./start.sh",  // Use wrapper script that activates venv
      cwd: __dirname,
      interpreter: "bash",   // Run with bash
      env: {
        PYTHONUNBUFFERED: "1",
        FLASK_ENV: "production"
      },
      autorestart: true,
      error_file: "./logs/error.log",
      out_file: "./logs/out.log",
      log_date_format: "YYYY-MM-DD HH:mm:ss",
      max_memory_restart: "500M"
    }
  ]
};
