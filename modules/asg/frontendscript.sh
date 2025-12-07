#!/usr/bin/env bash
set -euo pipefail

exec > >(tee /var/log/frontend_user_data.log|logger -t user-data -s 2>/dev/console) 2>&1

FRONTEND_PORT="${FRONTEND_PORT:-80}"

yum clean all -y || true
yum update -y || true
yum install -y nginx

cat > /usr/share/nginx/html/index.html <<'HTML'
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>3-Tier App Frontend</title>
  <style>
    body{font-family:system-ui,-apple-system,Segoe UI,Roboto,Ubuntu,Cantarell,Noto Sans,sans-serif;margin:0;background:#0b132b;color:#e0e0e0}
    .wrap{max-width:720px;margin:8vh auto;padding:24px}
    .card{background:#1c2541;border-radius:12px;padding:24px;box-shadow:0 8px 20px rgba(0,0,0,.25)}
    h1{margin-top:0}
    button{background:#5bc0be;border:0;padding:10px 16px;border-radius:8px;color:#0b132b;font-weight:700;cursor:pointer}
    code{background:#0b132b;padding:2px 6px;border-radius:6px}
    .muted{opacity:.8}
    pre{background:#0b132b;padding:12px;border-radius:8px;overflow:auto}
  </style>
</head>
<body>
  <div class="wrap">
    <div class="card">
      <h1>Frontend is up ✅</h1>
      <p class="muted">This page is served by Nginx on your frontend ASG instances.</p>
      <p>Backend is reachable inside the VPC via the internal ALB. Once you have its DNS, you can wire the frontend to call it (e.g. via Nginx proxy or JS fetch).</p>
      <p>Try calling backend from an instance with: <code>curl http://INTERNAL_ALB_DNS/health</code></p>
    </div>
  </div>
</body>
</html>
HTML

sed -i 's/listen       80;/listen       '"${FRONTEND_PORT}"';/' /etc/nginx/nginx.conf

systemctl enable nginx
systemctl restart nginx

echo "Frontend setup complete on port ${FRONTEND_PORT}"

