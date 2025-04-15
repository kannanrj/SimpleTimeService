
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
![Screenshot from 2025-04-15 23-49-31](https://github.com/user-attachments/assets/f503610e-504d-40b9-a4e2-440fb3f7e5b6)
![Screenshot from 2025-04-14 23-41-11](https://github.com/user-attachments/assets/206e03fe-2700-4dc1-a1d8-6ac7511bcaf9)


- Deploying a secure, scalable AWS infrastructure (VPC, ECS, ALB) via Terraform.

![Screenshot from 2025-04-15 23-52-56](https://github.com/user-attachments/assets/1fca25f7-68b4-480e-b230-1a9c228f60d9)
![Screenshot from 2025-04-15 23-57-05](https://github.com/user-attachments/assets/89c4ee06-a087-4145-b6cd-44ddb126bb3d)
![Screenshot from 2025-04-15 23-58-56](https://github.com/user-attachments/assets/2eb6b1f4-7d00-4dda-aa5e-7aad3299fb59)



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
