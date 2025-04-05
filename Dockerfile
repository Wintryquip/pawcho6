# syntax=docker/dockerfile:1
FROM scratch AS stage1
ADD alpine-minirootfs-3.21.3-x86_64.tar / 

RUN apk add --no-cache nodejs npm git openssh-client
RUN mkdir -p -m 0600 ~/.ssh && ssh-keyscan github.com >> ~/.ssh/known_hosts
RUN --mount=type=ssh \
    mkdir -p /pawcho6 && \
    git clone git@github.com:wintryquip/pawcho6.git /pawcho6

WORKDIR /pawcho6

RUN npm install

COPY . .

RUN node app.js

FROM nginx:alpine

COPY --from=stage1 /pawcho6/index.html /usr/share/nginx/html/

HEALTHCHECK --interval=30s --timeout=3s \
  CMD curl -f http://localhost/ || exit 1

EXPOSE 80
