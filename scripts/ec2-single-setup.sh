#!/bin/bash
# Run on a fresh Ubuntu EC2 instance (Task 1 — single EC2)
set -e

REPO_URL="${REPO_URL:-https://github.com/balvindersingh07/aws-devops-project.git}"

sudo apt update
sudo apt install -y python3 python3-pip python3-venv git nodejs npm

cd ~
git clone "$REPO_URL" aws-devops-project || (cd aws-devops-project && git pull)
cd aws-devops-project/backend

python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
nohup python app.py > ~/backend.log 2>&1 &

cd ../frontend
npm install
export BACKEND_URL=http://127.0.0.1:5000
nohup node server.js > ~/frontend.log 2>&1 &

echo "Done. Frontend: http://$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4):3000"
