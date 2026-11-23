FROM debian:bookworm-slim

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        unzip wget curl ca-certificates && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Download Xray-core
RUN wget -q https://github.com/XTLS/Xray-core/releases/download/v1.8.24/Xray-linux-64.zip && \
    unzip -o Xray-linux-64.zip && \
    chmod +x xray && \
    rm Xray-linux-64.zip

# Write Xray config
RUN echo "eyJsb2ciOnsibG9nbGV2ZWwiOiJ3YXJuaW5nIn0sImluYm91bmRzIjpbeyJwb3J0Ijo4MDgwLCJwcm90b2NvbCI6InZsZXNzIiwic2V0dGluZ3MiOnsiY2xpZW50cyI6W3siaWQiOiJkMzQyZDExZS1kNDI0LTQ1ODMtYjM2ZS01MjRhYjFmMGFmYTQifV0sImRlY3J5cHRpb24iOiJub25lIn0sInN0cmVhbVNldHRpbmdzIjp7Im5ldHdvcmsiOiJ3cyIsInNlY3VyaXR5Ijoibm9uZSIsIndzU2V0dGluZ3MiOnsicGF0aCI6Ii8ifX19XSwib3V0Ym91bmRzIjpbeyJwcm90b2NvbCI6ImZyZWVkb20ifV19" \
    | base64 -d > config.json

# Download cloudflared
RUN wget -q https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 \
        -O /usr/local/bin/cloudflared && \
    chmod +x /usr/local/bin/cloudflared

COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

# Railway assigns PORT env var — Xray listens on 8080 internally,
# cloudflared tunnels it out, so we don't need to expose a real port.
EXPOSE 8080

ENTRYPOINT ["/app/entrypoint.sh"]
