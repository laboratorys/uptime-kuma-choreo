FROM docker.io/louislam/uptime-kuma:1.23.13-debian@sha256:96510915e6be539b76bcba2e6873591c67aca8a6075ff09f5b4723ae47f333fc AS app-donor

FROM docker.io/library/node:20.17.0-bookworm-slim@sha256:ee799af8710c0c414361d0c71f53a501cfc7bd6081336ae4fdcc223688a1e213

RUN addgroup -g 10014 choreo && \
    adduser  --disabled-password  --no-create-home --uid 10014 --ingroup choreo choreouser

ARG UID=10014
ARG GID=10014

# renovate: datasource=pypi depName=apprise versioning=pep440
ARG APPRISE_VERSION=1.9.0

# renovate: datasource=github-releases depName=cloudflare/cloudflared
ARG CLOUDFLARED_VERSION=2024.8.3

COPY --from=app-donor /home/app /home/10014/app


ENV HOME=/app
WORKDIR /app
USER 10014
EXPOSE 3001
VOLUME ["/home/10014/app/data"]
CMD ["/usr/bin/dumb-init", "--", "node", "server/server.js"]
