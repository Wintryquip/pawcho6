#Stage 1
FROM scratch AS stage1
ADD alpine-minirootfs-3.21.3-x86_64.tar /

RUN apk add --no-cache nodejs npm

WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .

ARG VERSION=1.0.0
ENV VERSION=${VERSION}

RUN node app.js

# Stage 2
FROM nginx:alpine

COPY --from=stage1 /app/index.html /usr/share/nginx/html/

HEALTHCHECK --interval=30s --timeout=3s \
  CMD curl -f http://localhost/ || exit 1

EXPOSE 80