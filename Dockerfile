FROM node:16-alpine AS builder

WORKDIR /app

COPY package* .

RUN npm ci

COPY . .

RUN npm run build


FROM node:16-alpine

WORKDIR /app

ENV NODE_ENV=production

ENV DOCKERIZE_VERSION v0.6.1

RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz

COPY package* .

RUN npm ci --omit=dev

COPY --from=builder /app/dist .

CMD ["node", "index.js"]

