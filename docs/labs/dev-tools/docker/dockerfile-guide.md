# Dockerfile Guide

## Overview
A Dockerfile is a text file that contains a series of instructions to build a Docker image. It's the foundation of containerized applications.

## Basic Structure
```dockerfile
FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE 3000
CMD ["npm", "start"]
```

## Common Instructions
- **FROM**: Base image
- **WORKDIR**: Set working directory
- **COPY**: Copy files from host to container
- **RUN**: Execute commands
- **EXPOSE**: Document port exposure
- **CMD**: Default command to run

## Best Practices
- Use specific base image tags
- Minimize layers
- Use .dockerignore
- Run as non-root user

---

## Next Article

[:octicons-arrow-right-24: Docker Compose](../docker/docker-compose-guide.md){ .md-button .md-button--primary }

Learn how to define and run multi-container Docker applications.
