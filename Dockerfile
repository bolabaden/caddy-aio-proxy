FROM caddy:builder AS builder

ENV GOPROXY=direct
ENV GOSUMDB=off

# Build caddy with all modules using direct git access
RUN xcaddy build \
    --with github.com/caddy-dns/cloudflare \
    --with github.com/lucaslorentz/caddy-docker-proxy/v2 \
    --with github.com/hslatman/caddy-crowdsec-bouncer/http \
    --with github.com/hslatman/caddy-crowdsec-bouncer/layer4 \
    --with github.com/greenpau/caddy-security \
    --with github.com/RussellLuo/caddy-ext/ratelimit \
    --with github.com/tailscale/caddy-tailscale \
    --with github.com/WingLim/caddy-webhook \
    --with github.com/porech/caddy-maxmind-geolocation && \
    go clean -modcache

FROM caddy:alpine
COPY --from=builder /usr/bin/caddy /usr/bin/caddy

CMD ["caddy", "docker-proxy"]
