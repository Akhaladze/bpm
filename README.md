# Creatio BPM 8.2.3 — Deployment Guide

This repository contains an enterprise-ready deployment of **Creatio Sales Enterprise 8.2.3**

## Quick Start

```bash
chmod +x build.sh
./build.sh up
```

## 📊 Architecture Diagrams

### 1. System Architecture

```mermaid
flowchart TB
    %% Clients
    user[User / Browser]
    mobile[Mobile Client]
    api[3rd-party Service]

    %% Edge & Security
    subgraph Edge["Ingress & Security"]
      nginx[NGINX Reverse Proxy<br/>TLS termination, WAF, rate limit]
      keycloak[Keycloak<br/>SSO / OIDC]
    end

    %% Application
    subgraph App["Application Layer"]
      creatio[Creatio BPM 8.2.3]
      redis[(Redis Cache)]
    end

    %% Data & Search
    subgraph Data["Data Stores & Search"]
      pg[(PostgreSQL)]
      es[(Elasticsearch)]
    end

    %% AI/ML
    subgraph ML["ML / AI Services"]
      mlapi[ML API<br/>Python & FastAPI]
      models[(Models / Artifacts)]
    end

    %% Observability
    subgraph Obs["Observability"]
      logstash[Logstash]
      kibana[Kibana]
      prom[Prometheus]
      grafana[Grafana]
    end

    %% Flows
    user -->|HTTPS| nginx
    mobile -->|HTTPS| nginx
    api -->|API| nginx

    nginx -->|OIDC redirect| keycloak
    keycloak -->|JWT / OIDC tokens| nginx

    nginx --> creatio
    creatio --> redis
    creatio --> pg
    creatio -->|Search API| es

    creatio <-->|Inference API| mlapi
    mlapi --> models

    %% Logs & Metrics
    nginx -->|Access / App logs| logstash --> es
    creatio -->|App logs| logstash
    mlapi -->|Service logs| logstash
    es --> kibana

    prom -->|scrape| creatio
    prom -->|scrape| mlapi
    prom -->|dashboards| grafana

```

### 2. Authentication Flow (OIDC)

```mermaid

sequenceDiagram
    participant U as User
    participant N as NGINX
    participant K as Keycloak
    participant C as Creatio

    U->>N: Request /app
    N-->>U: Redirect to Keycloak
    U->>K: Login credentials
    K-->>U: Auth code
    U->>N: Callback with code
    N->>K: Exchange code for tokens
    K-->>N: JWT tokens
    N->>C: Forward request + token
    C-->>N: Response
    N-->>U: Content
```

### 3. CI/CD Pipeline

```mermaid

flowchart LR
    dev[Developer] --> gh[GitHub Repo]
    gh --> actions[CI Pipeline]
    actions --> build[Docker Build]
    build --> registry[(Registry)]
    registry --> deploy[Deploy with Compose]
    deploy --> creatio[Creatio BPM Stack]
```

### 4. Analytics & ML Flow

```mermaid

flowchart TB
    creatio[Creatio BPM]
    pg[(PostgreSQL)]
    redis[(Redis Cache)]
    logs[Logs/Events]
    es[(Elasticsearch)]
    kib[Kibana]
    ml[ML/AI Service]

    creatio --> pg
    creatio --> redis
    creatio --> logs --> es --> kib
    es --> ml
    ml --> creatio

```
