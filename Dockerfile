# Stage 1: Build the Vue.js application
FROM node:22 AS build-stage
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# Stage 2: Serve the application with Nginx
FROM ghcr.io/nginxinc/nginx-unprivileged:1.27 AS production-stage

COPY --from=build-stage /app/dist /usr/share/nginx/html
COPY --from=build-stage /app/dist/assets/app-config.js /usr/share/nginx/html-template/app-config.template.js
COPY --chmod=+x ./docker-entrypoint.d/*.sh /docker-entrypoint.d/
USER root
RUN chmod a+w /usr/share/nginx/html/assets/ /usr/share/nginx/html/assets/app-config.js
USER 101
