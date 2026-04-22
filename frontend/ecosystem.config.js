module.exports = {
  apps: [
    {
      name: "angular-ssr",

      script: "dist/frontend/server/server.mjs",

      env: {
        PORT: 4000,
        NODE_ENV: "production"
      },

      autorestart: true
    }
  ]
};