#!/bin/sh
set -e

echo "[xray] Starting Xray-core..."
./xray run -config config.json > /tmp/xray.log 2>&1 &

echo "[xray] Waiting for Xray to initialise..."
sleep 2

echo "[cloudflared] Starting tunnel → http://localhost:8080"
cloudflared tunnel --no-autoupdate --url http://localhost:8080 2>&1 | \
  awk '
    {
      print $0
      fflush()
    }
    /trycloudflare\.com/ {
      for (i = 1; i <= NF; i++) {
        if ($i ~ /https:\/\/[^ ]*trycloudflare\.com/) {
          print ""
          print "================================================"
          print "  ✅ CLOUDFLARE URL: " $i
          print "================================================"
          print ""
          fflush()
        }
      }
    }
  '
