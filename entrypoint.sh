#!/bin/sh
set -e

# ── Xray: chạy ngầm, log ra file ─────────────────────────────────────────────
./xray run -config config.json > /tmp/xray.log 2>&1 &
sleep 2

# ── Cloudflared: chỉ in URL, bỏ hết log thừa ─────────────────────────────────
cloudflared tunnel --no-autoupdate --url http://localhost:8080 2>&1 | \
  awk '
    /https:\/\/[^ ]*trycloudflare\.com/ {
      for (i = 1; i <= NF; i++) {
        if ($i ~ /https:\/\/[^ ]*trycloudflare\.com/) {
          print "================================================"
          print "  CLOUDFLARE URL: " $i
          print "================================================"
          fflush()
        }
      }
    }

    # Chỉ in các lỗi thực sự (ERR), bỏ INF/WRN
    /^[0-9T:Z]+ ERR / {
      print "[ERROR]", $0
      fflush()
    }
  '
