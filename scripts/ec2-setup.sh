#!/bin/bash
# Usage:
#   Backend:  ROLE=backend bash ec2-setup.sh
#   Frontend: ROLE=frontend BACKEND_URL=http://<BACKEND_IP>:5000 bash ec2-setup.sh
set -e

REPO_URL="${REPO_URL:-https://github.com/balvindersingh07/aws-devops-project.git}"
ROLE="${ROLE:-backend}"

sudo apt update
sudo apt install -y python3 python3-pip python3-venv git nodejs npm

cd ~
git clone "$REPO_URL" aws-devops-project || (cd aws-devops-project && git pull)

if [ "$ROLE" = "backend" ]; then
  cd aws-devops-project/backend
  python3 -m venv venv
  source venv/bin/activate
  pip install -r requirements.txt
  nohup python app.py > ~/backend.log 2>&1 &
  echo "Backend started on port 5000"
elif [ "$ROLE" = "frontend" ]; then
  if [ -z "$BACKEND_URL" ]; then
    echo "Set BACKEND_URL=http://<BACKEND_PUBLIC_IP>:5000"
    exit 1
  fi
  cd aws-devops-project/frontend
  npm install
  export BACKEND_URL
  nohup node server.js > ~/frontend.log 2>&1 &
  echo "Frontend started on port 3000 (backend: $BACKEND_URL)"
else
  echo "ROLE must be backend or frontend"
  exit 1
fi
