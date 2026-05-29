# AWS DevOps Project — Flask + Express

Full-stack app with a **Flask** backend and **Express (EJS)** frontend, deployed on AWS using three approaches required for submission.

| Component | Stack | Port |
|-----------|-------|------|
| Backend | Flask + Flask-CORS | `5000` |
| Frontend | Express + EJS + Axios | `3000` |

---

## Submission (for evaluator / chat)

Copy this block when submitting (replace URLs with your live endpoints):

```
GitHub Repository: https://github.com/balvindersingh07/aws-devops-project

Deployed Application URLs:
1. Single EC2:        http://YOUR_SINGLE_EC2_PUBLIC_IP:3000
2. Separate EC2:      http://YOUR_FRONTEND_EC2_PUBLIC_IP:3000
   (Backend API):    http://YOUR_BACKEND_EC2_PUBLIC_IP:5000
3. Docker (ECS):      http://YOUR_ALB_OR_SERVICE_URL

Screenshots: See docs/screenshots/ in the repository
```

> **Cost tip:** Stop EC2 instances and scale ECS services to `0` when not demoing. Start them only when recording screenshots or showing the live app.

---

## AWS Free Tier

If you are new to AWS, create an account and use the **one-year free tier** (limited resources at no cost). Details: [AWS Free Tier](https://aws.amazon.com/free).

---

## Project structure

```
aws-devops-project/
├── backend/
│   ├── app.py
│   ├── requirements.txt
│   └── Dockerfile
├── frontend/
│   ├── server.js
│   ├── views/index.ejs
│   ├── public/styles.css
│   ├── Dockerfile
│   └── .env.example
├── docker-compose.yml
├── docs/
│   ├── DEPLOYMENT.md
│   └── screenshots/
│       ├── 1-single-ec2/
│       ├── 2-separate-ec2/
│       └── 3-docker-ecs-ecr/
└── scripts/
    ├── ec2-single-setup.sh
    └── ec2-setup.sh
```

---

## Local development

**Backend**

```bash
cd backend
python -m venv venv
# Windows: venv\Scripts\activate
pip install -r requirements.txt
python app.py
```

**Frontend** (new terminal)

```bash
cd frontend
npm install
# Optional: copy .env.example to .env
npm start
# Or: node server.js
```

Open `http://localhost:3000`, submit the form, and confirm the Flask response.

**Docker (local)**

```bash
docker compose up --build
```

---

## AWS deployments (summary)

| # | Requirement | Approach |
|---|-------------|----------|
| 1 | Single EC2 | Both apps on one instance; `BACKEND_URL=http://127.0.0.1:5000` |
| 2 | Separate EC2 | Backend instance + frontend instance; frontend uses `BACKEND_URL=http://<backend-public-ip>:5000` |
| 3 | Docker on AWS | Build images → **ECR** → **ECS** (Fargate/EC2) in a **VPC** with ALB |

Step-by-step commands: **[docs/DEPLOYMENT.md](docs/DEPLOYMENT.md)**

---

## Screenshots

Proof of each deployment lives under **`docs/screenshots/`**:

| Folder | What to capture |
|--------|-----------------|
| [1-single-ec2](docs/screenshots/1-single-ec2/) | EC2 console, security group, SSH/session, both services running, browser form success |
| [2-separate-ec2](docs/screenshots/2-separate-ec2/) | Two EC2 instances, backend `:5000`, frontend with `BACKEND_URL`, form success |
| [3-docker-ecs-ecr](docs/screenshots/3-docker-ecs-ecr/) | ECR repos, task definitions, ECS cluster/service, VPC/subnets, ALB, running app |

Add your `.png` / `.jpg` files to these folders, then commit and push.

---

## Environment variables

| Variable | Used by | Description |
|----------|---------|-------------|
| `BACKEND_URL` | Frontend | Flask base URL (default `http://127.0.0.1:5000`) |

---

## Security groups (reference)

| Service | Port | Source |
|---------|------|--------|
| Frontend | 3000 | `0.0.0.0/0` (demo) or your IP |
| Backend | 5000 | Frontend SG (separate EC2) or same instance |
| SSH | 22 | Your IP only |

Restrict `0.0.0.0/0` in production; fine for lab demos.

---

## Author

**Balvinder Singh Soni** — [GitHub](https://github.com/balvindersingh07/aws-devops-project)
