const configuration = () => ({
  app: {
    name: 'chat-backend',
    env: process.env.NODE_ENV ?? 'development',
    port: Number(process.env.PORT ?? 3000),
    corsOrigin: process.env.CORS_ORIGIN ?? '*',
  },
  auth: {
    accessTokenSecret:
      process.env.JWT_ACCESS_SECRET ?? 'change-me-access-secret',
    refreshTokenSecret:
      process.env.JWT_REFRESH_SECRET ?? 'change-me-refresh-secret',
    accessTokenTtl: process.env.ACCESS_TOKEN_TTL ?? '15m',
    refreshTokenTtl: process.env.REFRESH_TOKEN_TTL ?? '30d',
  },
  database: {
    url: process.env.DATABASE_URL ?? '',
  },
});

export default configuration;
