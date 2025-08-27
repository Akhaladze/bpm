# Creatio BPM 8.2.3 — Deployment Guide

This repository contains an enterprise-ready deployment of **Creatio Sales Enterprise 8.2.3** with optional **NGINX, Keycloak SSO, Elasticsearch, and ML/AI service**.  
Infra: Docker Compose, Redis, PostgreSQL, NGINX; optional: Keycloak, ELK, Prometheus/Grafana, ML API.

## Quick Start

```bash
chmod +x build.sh
./build.sh up


```mermaid
sequenceDiagram
    participant U as User (Browser)
    participant N as NGINX (Reverse Proxy)
    participant K as Keycloak (OIDC)
    participant C as Creatio BPM

    U->>N: GET /app
    N-->>U: 302 Redirect to Keycloak /authorize
    U->>K: Login (username/password, MFA if enabled)
    K-->>U: Auth Code (OIDC)
    U->>N: /callback?code=...
    N->>K: Exchange code for tokens
    K-->>N: id_token + access_token (JWT)
    N->>C: Forward request + JWT (Authorization: Bearer ...)
    C-->>N: 200 OK (HTML/JSON)
    N-->>U: 200 OK (content)
