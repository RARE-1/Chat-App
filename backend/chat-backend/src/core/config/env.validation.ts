type EnvConfig = Record<string, unknown>;

const allowedNodeEnvs = ['development', 'test', 'production'] as const;

export function validateEnvironment(config: EnvConfig) {
  const errors: string[] = [];
  const nodeEnv =
    typeof config.NODE_ENV === 'string' ? config.NODE_ENV : 'development';
  const port = Number(config.PORT ?? 3000);

  if (!allowedNodeEnvs.includes(nodeEnv as (typeof allowedNodeEnvs)[number])) {
    errors.push('NODE_ENV must be development, test, or production.');
  }

  if (Number.isNaN(port) || port <= 0) {
    errors.push('PORT must be a positive number.');
  }

  if (errors.length > 0) {
    throw new Error(`Environment validation failed: ${errors.join(' ')}`);
  }

  return config;
}
