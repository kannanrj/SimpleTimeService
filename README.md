
### SimpleTimeService

## Overview

`SimpleTimeService` is a Flask-based microservice that responds to `GET /` with a JSON payload:

```json
{
  "timestamp": "<current UTC date and time>",
  "ip": "<visitor's IP address>"
}
```

The project demonstrates:

- Containerizing a microservice with Docker and publishing it to DockerHub.
![image](https://github.com/user-attachments/assets/859ce46a-95c3-41c5-b66f-3c8d29477d58)
![Screenshot from 2025-04-14 23-41-11](https://github.com/user-attachments/assets/eaee9c07-b109-4bc3-94a2-034ce03ad724)

- Deploying a secure, scalable AWS infrastructure (VPC, ECS, ALB) via Terraform.
  ![Screenshot from 2025-04-15 23-52-56](https://github.com/user-attachments/assets/44b15261-daac-4534-9c98-f88dec8cc3c9)
![image](https://github.com/user-attachments/assets/fb6eed39-bb52-456d-ace9-a281f2482877)
![Screenshot from 2025-04-15 23-57-05](https://github.com/user-attachments/assets/17133d21-d801-42e4-af13-c303e161759c)
![image](https://github.com/user-attachments/assets/ffb1573a-9973-4c01-9b33-e9f80b79db44)


## Repository Structure

```
SimpleTimeService/
├── app/
│   ├── app.py              # Flask application
│   ├── requirements.txt    # Python dependencies
│   └── Dockerfile          # Docker configuration
├── terraform/
│   ├── main.tf             # Root Terraform module
│   ├── variables.tf        # Input variables
│   ├── terraform.tfvars    # Variable values
│   ├── outputs.tf          # Output values
│   └── modules/
│       ├── vpc/            # VPC module
│       └── ecs/            # ECS module
├── README.md               # Project documentation
└── .gitignore              # Excludes sensitive files
```

## Prerequisites

- [Docker](https://docs.docker.com/get-docker/)
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)
- [Terraform](https://developer.hashicorp.com/terraform/install)
- [Git](https://git-scm.com/)
- AWS account with programmatic access (Access Key ID and Secret Access Key)

---

## Task 1: Build and Containerize `SimpleTimeService`

### Step 1: Clone the Repository

```bash
git clone <your_repository_url>
cd SimpleTimeService
```

### Step 2: Build Docker Image

```bash
cd app
docker build -t simpletimeservice .
```

### Step 3: Test Locally

```bash
docker run -p 8080:8080 -d --name simpletimeservice simpletimeservice
```

Verify with:

```bash
curl http://localhost:8080/
```

Expected output:

```json
{"timestamp": "2025-04-14T12:34:56.789012", "ip": "127.0.0.1"}
```

### Step 4: Publish to DockerHub

```bash
docker tag simpletimeservice <your_dockerhub_username>/simpletimeservice:latest
docker push <your_dockerhub_username>/simpletimeservice:latest
```

Verify:

```bash
docker pull <your_dockerhub_username>/simpletimeservice:latest
```

> Notes:
> - Runs as a non-root user (`appuser`) for security.
> - Based on `python:3.9-slim` for minimal image size.
> - Extracts client IP from `X-Forwarded-For` (cloud) or `remote_addr` (local).

---

## Task 2: Deploy to AWS ECS

### Step 1: Configure AWS Credentials

```bash
aws configure --profile testinguser
```

Provide:
- Access Key ID
- Secret Access Key
- Region (e.g., `us-east-1`)


### Step 2: Update Terraform Variables

Edit `terraform/terraform.tfvars`:

```hcl
container_image = "<your_dockerhub_username>/simpletimeservice:latest"
```

---

### Step 3: Deploy Infrastructure

```bash
cd terraform
terraform init
terraform plan
terraform apply
```

Type `yes` to confirm. Note the output value for `alb_dns_name`.

---

### Step 4: Verify Deployment

```bash
curl http://<alb_dns_name>/
```

Expected output:

```json
{"timestamp": "2025-04-14T12:34:56.789012", "ip": "<your_public_ip>"}
```

To check your public IP:

```bash
curl ifconfig.me
```

---

### Step 5: Cleanup

To avoid AWS charges

```bash
terraform destroy
```

Type `yes` to confirm.

---
