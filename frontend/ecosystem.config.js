module.exports = {
  apps: [
    {
      name: "angular-ssr",
      script: "./dist/frontend/server/server.mjs",
      cwd: "/home/alite-148/Task/fullstack-project/frontend",
      env: {
        PORT: 4000,
        NODE_ENV: "production",
        NODE_OPTIONS: "--max-old-space-size=1024"  // ✅ FIX: Increase Node heap to 1GB
      },
      autorestart: true,
      max_memory_restart: "800M",  // ✅ FIX: Restart if memory exceeds 800MB
      error_file: "./logs/error.log",
      out_file: "./logs/out.log",
      log_date_format: "YYYY-MM-DD HH:mm:ss"
    }
  ]
};
