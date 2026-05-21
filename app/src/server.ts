import express, { Request, Response } from 'express';
import client from 'prom-client';

const VERSION = process.env.APP_VERSION ?? '1.0.0';
const ENV     = process.env.NODE_ENV ?? 'production';

const app = express();

const register = new client.Registry();
client.collectDefaultMetrics({ register });

app.use((req, _res, next) => {
  if (req.path === '/metrics') return next();
  console.log(`${new Date().toISOString()} ${req.method} ${req.path}`);
  next();
});

app.get('/', (_req: Request, res: Response) => {
  res.type('text').send(`Hello World from Azure AKS!\nVersion: ${VERSION}\nEnv: ${ENV}\n`);
});

app.get('/health', (_req: Request, res: Response) => {
  res.json({
    status:    'healthy',
    version:   VERSION,
    env:       ENV,
    uptime:    process.uptime(),
    timestamp: new Date().toISOString(),
  });
});

app.get('/metrics', async (_req: Request, res: Response) => {
  res.set('Content-Type', register.contentType);
  res.send(await register.metrics());
});

export { app };
