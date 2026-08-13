# SIMS Backend (NestJS)

NestJS + PostgreSQL backend for the School Information Management System.

## Setup

1. Install PostgreSQL and create a database:
   ```sql
   CREATE USER sims WITH PASSWORD 'sims_password';
   CREATE DATABASE sims OWNER sims;
   ```

2. Install dependencies:
   ```bash
   npm install
   ```

3. Seed the admin user:
   ```bash
   npx ts-node src/seed.ts
   ```

4. Start the server:
   ```bash
   npm run start:dev
   ```

The API will be available at `http://localhost:3000/api`.

## API Endpoints

### Auth
- `POST /api/auth/login` — Login with username/password, returns JWT
- `POST /api/auth/switch-role` — Switch active role (requires JWT)

### Admissions
- `POST /api/admissions/apply` — Public endpoint for admission applications
- `GET /api/admissions` — List all applications (requires JWT)
- `GET /api/admissions/:id` — Get single application (requires JWT)
- `PUT /api/admissions/:id/status` — Update application status (requires JWT)

### Students
- `GET /api/students` — List all students (requires JWT, tenant-scoped)
- `GET /api/students/:id` — Get single student
- `POST /api/students` — Create student
- `PUT /api/students/:id` — Update student
- `DELETE /api/students/:id` — Soft-delete student

### Sync
- `POST /api/sync/push` — Push local changes to server
- `GET /api/sync/pull?table=students&since=2026-01-01` — Pull server changes

## Architecture

- **Auth**: JWT-based with Passport, bcrypt password hashing, multi-role support
- **Tenancy**: All data scoped by `tenantId` from JWT claims
- **Sync**: Push/pull endpoints compatible with the WatermelonDB sync engine
- **ORM**: TypeORM with PostgreSQL, auto-synced schema in development
