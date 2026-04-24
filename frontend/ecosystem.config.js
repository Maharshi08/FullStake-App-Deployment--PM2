module.exports = {
  apps: [
    {
      name: "angular-ssr",
      script: "./dist/frontend/server/server.mjs",
      cwd: __dirname,

      autorestart: true,
      max_restarts: 5,
      min_uptime: "10s",
      restart_delay: 5000,

      error_file: "/var/lib/jenkins/.pm2/logs/angular-error.log",
      out_file: "/var/lib/jenkins/.pm2/logs/angular-out.log",

      env: {
        PORT: 4000,
        NODE_ENV: "production"
      }
    }
  ]
};