
FROM node:22-alpine3.20 AS dev-deps
WORKDIR /app
COPY package.json package.json
RUN yarn install --frozen-lockfile --network-timeout 600000


FROM node:22-alpine3.20 AS builder
WORKDIR /app
COPY --from=dev-deps /app/node_modules ./node_modules
COPY . .
# RUN yarn test
RUN yarn build

FROM node:22-alpine3.20 AS prod-deps
WORKDIR /app
COPY package.json package.json
RUN yarn install --prod --frozen-lockfile --network-timeout 600000


FROM node:22-alpine3.20 AS prod
EXPOSE 3000
WORKDIR /app
ARG APP_VERSION
ENV APP_VERSION={$APP_VERSION}
COPY --from=prod-deps /app/node_modules ./node_modules
COPY --from=builder /app/dist ./dist

CMD [ "node","dist/main.js"]









