FROM node:16-alpine AS builder

WORKDIR /app

COPY package* .

RUN npm ci

COPY . .

RUN npm run build


FROM node:16-alpine

WORKDIR /app

ENV NODE_ENV=production

COPY package* .

RUN npm ci --omit=dev

COPY --from=builder /app/dist .

CMD ["node", "index.js"]

