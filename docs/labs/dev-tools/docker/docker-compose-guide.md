# Docker Compose Guide

## Overview
Docker Compose is a tool for defining and running multi-container Docker applications. It uses YAML files to configure application services.

## Basic Structure
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
```

## Key Features
- **Multi-container**: Define multiple services
- **Networking**: Automatic service discovery
- **Volumes**: Persistent data storage
- **Environment**: Variable configuration

## Common Commands
```bash
docker-compose up -d
docker-compose down
docker-compose logs
docker-compose ps
```

---

## Next Article

[:octicons-arrow-right-24: Docker Overview](../docker/index.md){ .md-button .md-button--primary }

Return to the main Docker overview for more comprehensive guides.
