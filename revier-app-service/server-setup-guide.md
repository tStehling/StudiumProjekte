# Setting Up Supabase in Docker on a Server

This guide will walk you through setting up Supabase in Docker on your server.

## Prerequisites

- A server with Docker and Docker Compose installed
- Domain name (optional, but recommended for production)
- Basic knowledge of Docker and server administration

## Step 1: Create a Project Directory

```bash
# Create a directory for your Supabase project
mkdir -p supabase-server
cd supabase-server

# Create directories for volumes
mkdir -p volumes/db/data
mkdir -p volumes/storage
```

## Step 2: Get the Docker Compose File

You can either clone the official Supabase repository or create the Docker Compose file manually.

### Option 1: Clone the Supabase Repository

```bash
git clone --depth 1 https://github.com/supabase/supabase
cp -r supabase/docker/* .
rm -rf supabase
```

### Option 2: Create Docker Compose File Manually

Create a `docker-compose.yml` file:

```bash
touch docker-compose.yml
```

Then add the following content to the file (this is a simplified version, you may need to adjust it):

```yaml
name: supabase

services:
  studio:
    container_name: supabase-studio
    image: supabase/studio:latest
    restart: unless-stopped
    environment:
      STUDIO_PG_META_URL: http://meta:8080
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD}
      DEFAULT_ORGANIZATION_NAME: ${STUDIO_DEFAULT_ORGANIZATION}
      DEFAULT_PROJECT_NAME: ${STUDIO_DEFAULT_PROJECT}
      SUPABASE_URL: http://kong:8000
      SUPABASE_PUBLIC_URL: ${SUPABASE_PUBLIC_URL}
      SUPABASE_ANON_KEY: ${ANON_KEY}
      SUPABASE_SERVICE_KEY: ${SERVICE_ROLE_KEY}
      AUTH_JWT_SECRET: ${JWT_SECRET}
    ports:
      - "3000:3000"
    depends_on:
      - db
      - kong

  kong:
    container_name: supabase-kong
    image: kong:2.8.1
    restart: unless-stopped
    ports:
      - "8000:8000"
    environment:
      KONG_DATABASE: "off"
      KONG_DECLARATIVE_CONFIG: /var/lib/kong/kong.yml
      KONG_DNS_ORDER: LAST,A,CNAME
      KONG_PLUGINS: request-transformer,cors,key-auth,acl
    volumes:
      - ./volumes/kong:/var/lib/kong

  auth:
    container_name: supabase-auth
    image: supabase/gotrue:latest
    restart: unless-stopped
    environment:
      GOTRUE_API_HOST: 0.0.0.0
      GOTRUE_API_PORT: 9999
      GOTRUE_DB_DRIVER: postgres
      GOTRUE_DB_HOST: db
      GOTRUE_DB_PORT: 5432
      GOTRUE_DB_USER: supabase_auth_admin
      GOTRUE_DB_PASSWORD: ${POSTGRES_PASSWORD}
      GOTRUE_DB_DATABASE: auth
      GOTRUE_SITE_URL: ${SITE_URL}
      GOTRUE_JWT_SECRET: ${JWT_SECRET}
      GOTRUE_JWT_EXP: 3600
      GOTRUE_JWT_DEFAULT_GROUP_NAME: authenticated
    depends_on:
      - db

  rest:
    container_name: supabase-rest
    image: postgrest/postgrest:latest
    restart: unless-stopped
    environment:
      PGRST_DB_URI: postgres://authenticator:${POSTGRES_PASSWORD}@db:5432/postgres
      PGRST_DB_SCHEMA: public
      PGRST_DB_ANON_ROLE: anon
      PGRST_JWT_SECRET: ${JWT_SECRET}
    depends_on:
      - db

  realtime:
    container_name: supabase-realtime
    image: supabase/realtime:latest
    restart: unless-stopped
    environment:
      DB_HOST: db
      DB_PORT: 5432
      DB_NAME: postgres
      DB_USER: supabase_admin
      DB_PASSWORD: ${POSTGRES_PASSWORD}
      PORT: 4000
      JWT_SECRET: ${JWT_SECRET}
    depends_on:
      - db

  storage:
    container_name: supabase-storage
    image: supabase/storage-api:latest
    restart: unless-stopped
    environment:
      ANON_KEY: ${ANON_KEY}
      SERVICE_KEY: ${SERVICE_ROLE_KEY}
      POSTGREST_URL: http://rest:3000
      PGRST_JWT_SECRET: ${JWT_SECRET}
      DATABASE_URL: postgres://supabase_storage_admin:${POSTGRES_PASSWORD}@db:5432/postgres
      FILE_SIZE_LIMIT: 52428800
      STORAGE_BACKEND: file
      FILE_STORAGE_BACKEND_PATH: /var/lib/storage
    volumes:
      - ./volumes/storage:/var/lib/storage
    depends_on:
      - db
      - rest

  meta:
    container_name: supabase-meta
    image: supabase/postgres-meta:latest
    restart: unless-stopped
    environment:
      PG_META_PORT: 8080
      PG_META_DB_HOST: db
      PG_META_DB_PORT: 5432
      PG_META_DB_NAME: postgres
      PG_META_DB_USER: supabase_admin
      PG_META_DB_PASSWORD: ${POSTGRES_PASSWORD}
    depends_on:
      - db

  db:
    container_name: supabase-db
    image: supabase/postgres:latest
    restart: unless-stopped
    environment:
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD}
    ports:
      - "5432:5432"
    volumes:
      - ./volumes/db/data:/var/lib/postgresql/data
      - ./migrations:/docker-entrypoint-initdb.d
```

## Step 3: Create Environment Variables

Create a `.env` file with the necessary environment variables:

```bash
touch .env
```

Add the following content to the file:

```
# PostgreSQL
POSTGRES_PASSWORD=your_secure_password
POSTGRES_HOST=db
POSTGRES_PORT=5432
POSTGRES_DB=postgres

# Studio
STUDIO_DEFAULT_ORGANIZATION=Your Organization
STUDIO_DEFAULT_PROJECT=Your Project

# API
SITE_URL=http://localhost:8000
SUPABASE_PUBLIC_URL=http://localhost:8000
API_EXTERNAL_URL=http://localhost:8000

# Auth
GOTRUE_SITE_URL=http://localhost:8000
JWT_SECRET=your_jwt_secret_at_least_32_characters_long
ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoiYW5vbiIsImlhdCI6MTYyNDM4MDYzNCwiZXhwIjoxOTM5OTU2NjM0fQ.SDH7wXuJ0WMRpgvSLIolzqI8wn7XAdl8p5niE8y-PYw
SERVICE_ROLE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoic2VydmljZV9yb2xlIiwiaWF0IjoxNjI0MzgwNjM0LCJleHAiOjE5Mzk5NTY2MzR9.T7PUy1YqGZ9DHDl7JbZ6esiF_vsyv_BUZVkdYnbW8H0
```

Make sure to replace the placeholder values with secure values for your production environment.

## Step 4: Start Supabase

Start the Supabase services:

```bash
docker compose up -d
```

This will start all the Supabase services in detached mode.

## Step 5: Verify the Installation

Check if all services are running:

```bash
docker compose ps
```

You should see all services running without any errors.

## Step 6: Access Supabase Studio

You can now access Supabase Studio at:

- http://your-server-ip:3000

## Step 7: Configure Your Application

Update your application to use your self-hosted Supabase instance:

```javascript
import { createClient } from '@supabase/supabase-js'

const supabase = createClient(
  'http://your-server-ip:8000',
  'your-anon-key'
)
```

## Step 8: Set Up Your Schema

Now you can use the Supabase Studio to set up your database schema or import your existing schema files:

1. Place your migration files in the `migrations` directory
2. Restart the services to apply the migrations:

```bash
docker compose down
docker compose up -d
```

## Production Considerations

For a production environment, consider the following:

1. **Use a domain name**: Configure a domain name with SSL for your Supabase instance
2. **Set up a reverse proxy**: Use Nginx or Traefik to handle SSL termination and routing
3. **Secure your environment variables**: Use a secrets manager instead of a .env file
4. **Set up backups**: Configure regular backups of your database
5. **Monitor your services**: Set up monitoring and alerting for your Supabase services

## Using with Your Revier App Schema

To use your Supabase Docker setup with your Revier App schema:

1. Copy your migration files to the `migrations` directory:

```bash
cp /path/to/revier-app-service/supabase/migrations/* ./migrations/
```

2. Copy your seed file if you have one:

```bash
cp /path/to/revier-app-service/supabase/seed.sql ./migrations/
```

3. Restart the services to apply the migrations:

```bash
docker compose down
docker compose up -d
```

## Troubleshooting

If you encounter issues:

1. Check the logs: `docker compose logs`
2. Check specific service logs: `docker compose logs [service-name]`
3. Ensure all environment variables are set correctly
4. Verify that the ports are not being used by other services

## Updating Supabase

To update Supabase to the latest version:

```bash
docker compose pull
docker compose down
docker compose up -d
```

This will pull the latest images and restart the services. 