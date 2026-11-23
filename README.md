# Xray + Cloudflare Tunnel on Railway

Chạy **Xray VLESS over WebSocket** và expose ra ngoài qua **Cloudflare Quick Tunnel** (không cần domain, không cần tài khoản Cloudflare).

## Deploy lên Railway

1. Fork / import repo này lên GitHub
2. Vào [railway.app](https://railway.app) → **New Project** → **Deploy from GitHub repo**
3. Chọn repo này → Railway tự detect `Dockerfile` và `railway.toml` → build & deploy tự động
4. Xem **Logs** trong Railway dashboard để lấy địa chỉ Cloudflare:

```
================================================
  ✅ CLOUDFLARE URL: https://xxxx.trycloudflare.com
================================================
```

## Cấu hình VLESS client

| Trường        | Giá trị                              |
|---------------|--------------------------------------|
| **Address**   | `xxxx.trycloudflare.com`             |
| **Port**      | `443`                                |
| **UUID**      | `d342d11e-d424-4583-b36e-524ab1f0afa4` |
| **Flow**      | _(để trống)_                         |
| **Network**   | `ws`                                 |
| **Path**      | `/`                                  |
| **TLS**       | `tls`                                |
| **SNI**       | `xxxx.trycloudflare.com`             |

## Cấu trúc repo

```
.
├── Dockerfile       # Build image: Xray + cloudflared
├── entrypoint.sh    # Start Xray → Start cloudflared → in URL ra log
├── railway.toml     # Railway build & deploy config
└── .gitignore
```

## Lưu ý

- URL Cloudflare thay đổi mỗi lần restart — đây là **Quick Tunnel** (miễn phí, tạm thời).
- Để có URL cố định, dùng Cloudflare Named Tunnel với token riêng.
- UUID trong config là mặc định — nên đổi thành UUID riêng của bạn trước khi dùng thật.
