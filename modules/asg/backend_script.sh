#!/usr/bin/env bash
set -euo pipefail

exec > >(tee /var/log/backend_user_data.log|logger -t user-data -s 2>/dev/console) 2>&1

BACKEND_PORT="${BACKEND_PORT:-8080}"
APP_DIR="/opt/backend-app"
PY_BIN="/usr/bin/python3"

yum clean all -y || true
yum update -y || true
yum install -y python3 python3-pip

mkdir -p "${APP_DIR}"
cat > "${APP_DIR}/app.py" <<'PYAPP'
from flask import Flask, jsonify
import os

app = Flask(__name__)

@app.get("/")
def root():
    return jsonify(message="Hello from Backend!", status="ok")

@app.get("/health")
def health():
    return "OK", 200

if __name__ == "__main__":
    port = int(os.environ.get("BACKEND_PORT", "8080"))
    app.run(host="0.0.0.0", port=port)
PYAPP

pip3 install --no-cache-dir flask

cat > /etc/systemd/system/backend.service <<EOF
[Unit]
Description=Simple Flask Backend
After=network.target

[Service]
Environment=BACKEND_PORT=${BACKEND_PORT}
WorkingDirectory=${APP_DIR}
ExecStart=${PY_BIN} ${APP_DIR}/app.py
Restart=always
RestartSec=3

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable backend.service
systemctl start backend.service

echo "Backend setup complete on port ${BACKEND_PORT}"

