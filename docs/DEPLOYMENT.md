# AWS Deployment Guide

Detailed steps for all three assignment deployments.

---

## Prerequisites

- AWS account ([Free Tier](https://aws.amazon.com/free))
- AWS CLI configured (`aws configure`)
- Docker installed (for Task 3 and local testing)
- EC2 key pair (`.pem`) for SSH

---

## Task 1 — Single EC2 instance

Both Flask and Express run on **one** Ubuntu EC2 instance.

### 1. Launch EC2

- AMI: **Ubuntu 22.04 LTS**
- Instance type: `t2.micro` (free tier)
- Security group inbound:
  - SSH `22` — your IP
  - Custom TCP `3000` — `0.0.0.0/0`
  - Custom TCP `5000` — `0.0.0.0/0` (optional, for direct API test)

### 2. SSH and run setup

```bash
ssh -i aws-devops-key.pem ubuntu@<EC2_PUBLIC_IP>
```

Clone the repo and run:

```bash
bash scripts/ec2-single-setup.sh
```

Or manually:

```bash
sudo apt update && sudo apt install -y python3 python3-pip python3-venv git nodejs npm
git clone https://github.com/balvindersingh07/aws-devops-project.git
cd aws-devops-project/backend
python3 -m venv venv && source venv/bin/activate
pip install -r requirements.txt
nohup python app.py > backend.log 2>&1 &

cd ../frontend
npm install
export BACKEND_URL=http://127.0.0.1:5000
nohup node server.js > frontend.log 2>&1 &
```

### 3. Verify

- Backend: `http://<EC2_IP>:5000/` → `Flask Backend Running`
- App: `http://<EC2_IP>:3000/` → submit form → success message

### 4. Screenshots

Save to `docs/screenshots/1-single-ec2/` (see folder README).

---

## Task 2 — Separate EC2 instances

### Backend instance

1. Launch EC2 (Ubuntu, `t2.micro`).
2. Security group: SSH `22`, Custom TCP `5000` from **frontend security group** or `0.0.0.0/0` for lab.
3. Deploy backend only:

```bash
cd aws-devops-project/backend
python3 -m venv venv && source venv/bin/activate
pip install -r requirements.txt
nohup python app.py > backend.log 2>&1 &
```

Note **backend public IP**.

### Frontend instance

1. Launch second EC2.
2. Security group: SSH `22`, Custom TCP `3000` — `0.0.0.0/0`.
3. Deploy frontend with backend URL:

```bash
cd aws-devops-project/frontend
npm install
export BACKEND_URL=http://<BACKEND_PUBLIC_IP>:5000
nohup node server.js > frontend.log 2>&1 &
```

### Verify

- `http://<BACKEND_IP>:5000/`
- `http://<FRONTEND_IP>:3000/` — form submit must reach backend

### Screenshots

Save to `docs/screenshots/2-separate-ec2/`.

---

## Task 3 — Docker + ECR + ECS + VPC

### 1. Build and push images to ECR

```bash
aws ecr create-repository --repository-name aws-devops-backend
aws ecr create-repository --repository-name aws-devops-frontend

# Login
aws ecr get-login-password --region <REGION> | docker login --username AWS --password-stdin <ACCOUNT_ID>.dkr.ecr.<REGION>.amazonaws.com

# Build & push backend
cd backend
docker build -t aws-devops-backend .
docker tag aws-devops-backend:latest <ACCOUNT_ID>.dkr.ecr.<REGION>.amazonaws.com/aws-devops-backend:latest
docker push <ACCOUNT_ID>.dkr.ecr.<REGION>.amazonaws.com/aws-devops-backend:latest

# Build & push frontend
cd ../frontend
docker build -t aws-devops-frontend .
docker tag aws-devops-frontend:latest <ACCOUNT_ID>.dkr.ecr.<REGION>.amazonaws.com/aws-devops-frontend:latest
docker push <ACCOUNT_ID>.dkr.ecr.<REGION>.amazonaws.com/aws-devops-frontend:latest
```

### 2. VPC and networking

- Use default VPC or create VPC with **public subnets** in two AZs.
- Create **security groups**:
  - ALB SG: inbound `80`/`3000` from internet
  - ECS tasks SG: allow traffic from ALB; backend port `5000` from frontend task SG

### 3. ECS

1. Create cluster (Fargate).
2. Create **task definition** for backend (port 5000, ECR image).
3. Create **task definition** for frontend (port 3000, env `BACKEND_URL=http://<backend-service-discovery-or-internal-url>:5000`).
4. Create **services** in the VPC subnets.
5. Create **Application Load Balancer** targeting frontend service (port 3000).

### 4. Verify

Open ALB DNS name in browser and test the form.

### Screenshots

Save to `docs/screenshots/3-docker-ecs-ecr/`:

- ECR repositories with pushed images
- ECS cluster, services, running tasks
- VPC / subnets / security groups
- ALB + target group healthy
- Browser showing successful submission

---

## Stop resources (save cost)

```bash
# EC2: Instance state → Stop instance
# ECS: Update service desired count to 0
# ALB: Delete if only used for this lab
```

Start again only when demoing or taking screenshots.
