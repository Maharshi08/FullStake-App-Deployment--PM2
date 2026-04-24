module.exports = {
  apps: [
    {
      name: "angular-ssr",
      script: "dist/frontend/server/server.mjs",
      cwd: "/home/alite-148/Task/fullstack-project/frontend",
      exec_mode: "fork",
      env: {
        PORT: 4000,
        NODE_ENV: "production",
        NODE_OPTIONS: "--max-old-space-size=1024"
      },
      autorestart: true,
      max_memory_restart: "800M",
      error_file: "./logs/error.log",
      out_file: "./logs/out.log",
      log_date_format: "YYYY-MM-DD HH:mm:ss"
    }
  ]
};