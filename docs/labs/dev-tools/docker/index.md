# Docker

## Overview
Docker is a containerization platform that enables developers to package applications and their dependencies into lightweight, portable containers. This ensures consistent deployment across different environments.

## Topics Covered
- Container fundamentals and concepts
- Docker installation and setup
- Building and managing images
- Container orchestration and networking
- Best practices for production deployment
- Integration with development workflows

## Getting Started

Docker revolutionizes how we build, ship, and run applications by providing a consistent environment from development to production.

### Key Features
- **Containerization**: Package applications with all dependencies
- **Portability**: Run anywhere Docker is supported
- **Scalability**: Easy horizontal scaling
- **Isolation**: Secure, isolated environments
- **Efficiency**: Lightweight compared to virtual machines

---

## Installation and Setup

### Prerequisites
- **Operating System**: Windows, macOS, or Linux
- **Hardware**: 4GB RAM minimum, 8GB recommended
- **Disk Space**: 2GB for Docker Desktop

### Installation Steps

1. **Download Docker Desktop**
   - Visit [docker.com](https://www.docker.com/products/docker-desktop)
   - Download for your operating system
   - Follow installation wizard

2. **Verify Installation**
   ```bash
   docker --version
   docker-compose --version
   ```

3. **Test with Hello World**
   ```bash
   docker run hello-world
   ```

---

## Basic Docker Concepts

### Images vs Containers
- **Image**: Template for creating containers (like a class in programming)
- **Container**: Running instance of an image (like an object)

### Dockerfile
A text file containing instructions to build a Docker image:

```dockerfile
FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE 3000
CMD ["npm", "start"]
```

### Docker Commands

```bash
# Build an image
docker build -t my-app .

# Run a container
docker run -p 3000:3000 my-app

# List containers
docker ps

# List images
docker images

# Stop a container
docker stop <container-id>

# Remove a container
docker rm <container-id>
```

---

## Common Use Cases

### Web Application Development
```bash
# Run a web app
docker run -d -p 80:80 nginx

# Run with environment variables
docker run -e NODE_ENV=production my-app
```

### Database Services
```bash
# Run PostgreSQL
docker run -d \
  --name postgres \
  -e POSTGRES_PASSWORD=mypassword \
  -p 5432:5432 \
  postgres:13

# Run Redis
docker run -d \
  --name redis \
  -p 6379:6379 \
  redis:alpine
```

### Development Environment
```bash
# Run with volume mounting
docker run -v $(pwd):/app -w /app node:18 npm install
```

---

## Docker Compose

Docker Compose allows you to define multi-container applications:

```yaml
version: '3.8'
services:
  web:
    build: .
    ports:
      - "3000:3000"
    depends_on:
      - db
  db:
    image: postgres:13
    environment:
      POSTGRES_PASSWORD: mypassword
    volumes:
      - postgres_data:/var/lib/postgresql/data

volumes:
  postgres_data:
```

Run with:
```bash
docker-compose up -d
```

---

## Best Practices

### Security
- Use official base images
- Run containers as non-root user
- Keep images updated
- Scan for vulnerabilities

### Performance
- Use multi-stage builds
- Minimize image layers
- Use .dockerignore
- Optimize caching

### Development
- Use volumes for development
- Implement health checks
- Use environment variables
- Document your Dockerfile

---

## Troubleshooting

### Common Issues
- **Port conflicts**: Check if ports are already in use
- **Permission issues**: Ensure proper file permissions
- **Memory issues**: Increase Docker memory allocation
- **Network issues**: Check Docker network configuration

### Useful Commands
```bash
# View logs
docker logs <container-id>

# Execute commands in running container
docker exec -it <container-id> /bin/bash

# Inspect container
docker inspect <container-id>

# Clean up unused resources
docker system prune
```

---

## Next Steps

Once you're comfortable with Docker basics, explore:
- Kubernetes for orchestration
- Docker Swarm for clustering
- CI/CD integration
- Production deployment strategies

---

## Next Article

[:octicons-arrow-right-24: Kubernetes](../kubernetes/kubernetes.md){ .md-button .md-button--primary }

Learn how to orchestrate containers at scale with Kubernetes for production-grade container management.
