import { app } from './server';

const PORT = parseInt(process.env.PORT ?? '3000', 10);

const server = app.listen(PORT, '0.0.0.0', () => {
  console.log(`Server listening on http://0.0.0.0:${PORT}`);
  console.log(`Version: ${process.env.APP_VERSION ?? '1.0.0'} | Env: ${process.env.NODE_ENV ?? 'production'}`);
});

const shutdown = (signal: string): void => {
  console.log(`Received ${signal}. Shutting down gracefully...`);
  server.close(() => {
    console.log('Server closed.');
    process.exit(0);
  });
  setTimeout(() => process.exit(1), 10_000);
};

process.on('SIGTERM', () => shutdown('SIGTERM'));
process.on('SIGINT',  () => shutdown('SIGINT'));
