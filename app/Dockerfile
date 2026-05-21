# ── Stage 1: builder ──────────────────────────────────────────────────────────
# Installs all deps (including devDeps for tsc), compiles TypeScript,
# then prunes down to production-only node_modules.
FROM node:22-alpine AS builder

WORKDIR /app
COPY package*.json tsconfig.json ./
COPY src/ ./src/
RUN npm ci && npm run build && npm prune --omit=dev

# ── Stage 2: runtime ──────────────────────────────────────────────────────────
# Minimal image — only compiled JS and production node_modules.
FROM node:22-alpine AS runtime

RUN addgroup -S appgroup && adduser -S appuser -G appgroup

WORKDIR /app

COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/dist        ./dist
COPY package.json ./

USER appuser

EXPOSE 3000

HEALTHCHECK --interval=15s --timeout=5s --start-period=5s --retries=3 \
  CMD wget -qO- http://localhost:3000/health || exit 1

LABEL org.opencontainers.image.title="azure-web-app"
LABEL org.opencontainers.image.description="Minimal Hello World — Azure AKS demo"
LABEL org.opencontainers.image.source="https://github.com/manjeetops/azure-web-app.git"

ARG APP_VERSION=1.0.0

ENV NODE_ENV=production \
    PORT=3000 \
    APP_VERSION=${APP_VERSION}

CMD ["node", "dist/index.js"]
