# DEPLOYMENT CHECKLIST - SakshamMatch

## Pre-Deployment Checklist

### Environment Variables
- [ ] Create .env file for backend
- [ ] Set DATABASE_URL (PostgreSQL connection string)
- [ ] Set REDIS_URL (Redis connection string)
- [ ] Set JWT_SECRET (random 32-character string)
- [ ] Set AWS_ACCESS_KEY (for S3)
- [ ] Set AWS_SECRET_KEY (for S3)
- [ ] Set AWS_S3_BUCKET (bucket name)
- [ ] Never commit .env to GitHub

### Database
- [ ] Create Supabase/Neon account
- [ ] Create new PostgreSQL database
- [ ] Get connection string
- [ ] Run migrations: `alembic upgrade head`
- [ ] Verify tables created
- [ ] Insert seed data (optional)

### Redis
- [ ] Create Redis Cloud account (free tier)
- [ ] Get Redis connection URL
- [ ] Test connection

### File Storage
- [ ] Create AWS account (free tier)
- [ ] Create S3 bucket
- [ ] Get access keys
- [ ] Configure CORS for S3
- [ ] Test file upload

---

## Frontend Deployment (Vercel)

### Step 1: Connect GitHub
- [ ] Go to vercel.com
- [ ] Sign in with GitHub
- [ ] Click "Add New Project"
- [ ] Select your GitHub repo
- [ ] Select `frontend/` folder as root

### Step 2: Configure Build
- [ ] Build Command: `npm run build`
- [ ] Output Directory: `.next`
- [ ] Install Command: `npm install`

### Step 3: Environment Variables
- [ ] NEXT_PUBLIC_API_URL (backend URL)
- [ ] NEXT_PUBLIC_APP_NAME (SakshamMatch)

### Step 4: Deploy
- [ ] Click "Deploy"
- [ ] Wait for build to complete
- [ ] Get deployment URL (e.g., sakshammatch.vercel.app)
- [ ] Test in browser

### Step 5: Custom Domain (Optional)
- [ ] Buy domain (e.g., sakshammatch.in)
- [ ] Configure DNS (CNAME to Vercel)
- [ ] Add SSL (auto-provided)

---

## Backend Deployment (Render)

### Step 1: Connect GitHub
- [ ] Go to render.com
- [ ] Sign in with GitHub
- [ ] Click "New +" → "Web Service"
- [ ] Select your GitHub repo
- [ ] Select `backend/` folder as root

### Step 2: Configure Build
- [ ] Build Command: `pip install -r requirements.txt`
- [ ] Start Command: `uvicorn main:app --host 0.0.0.0 --port $PORT`

### Step 3: Environment Variables
- [ ] DATABASE_URL
- [ ] REDIS_URL
- [ ] JWT_SECRET
- [ ] AWS_ACCESS_KEY
- [ ] AWS_SECRET_KEY
- [ ] AWS_S3_BUCKET

### Step 4: Deploy
- [ ] Click "Create Web Service"
- [ ] Wait for build to complete
- [ ] Get deployment URL (e.g., sakshammatch.onrender.com)
- [ ] Test API at `/docs` (Swagger)

---

## Database Deployment (Supabase)

### Step 1: Create Database
- [ ] Go to supabase.com
- [ ] Sign up/sign in
- [ ] Click "New Project"
- [ ] Enter project name
- [ ] Set database password
- [ ] Choose region (closest to you)

### Step 2: Get Connection String
- [ ] Go to Settings → Database
- [ ] Copy connection string (URI mode)
- [ ] Add to backend .env as DATABASE_URL

### Step 3: Run Migrations
- [ ] Connect to database via psql or pgAdmin
- [ ] Run: `alembic upgrade head`
- [ ] Verify tables created

---

## Testing Deployment

### Frontend
- [ ] Open deployed URL
- [ ] Test landing page
- [ ] Test onboarding form
- [ ] Test results page
- [ ] Test document checklist
- [ ] Test on mobile device
- [ ] Test offline functionality (PWA)

### Backend
- [ ] Open Swagger docs (/docs)
- [ ] Test /api/auth/register
- [ ] Test /api/auth/login
- [ ] Test /api/profile
- [ ] Test /api/match
- [ ] Test /api/documents/checklist
- [ ] Test /api/analytics/overview

### Database
- [ ] Verify users table
- [ ] Verify profiles table
- [ ] Verify schemes table
- [ ] Verify applications table
- [ ] Test CRUD operations

### Integration
- [ ] Test frontend → backend connection
- [ ] Test backend → database connection
- [ ] Test file uploads to S3
- [ ] Test Redis caching

---

## Post-Deployment

### Monitoring
- [ ] Set up error tracking (Sentry - free tier)
- [ ] Set up uptime monitoring (UptimeRobot - free tier)
- [ ] Monitor database usage (Supabase dashboard)
- [ ] Monitor API response times

### Security
- [ ] Enable HTTPS (auto on Vercel/Render)
- [ ] Set up rate limiting
- [ ] Enable CORS properly
- [ ] Review security headers

### Backup
- [ ] Set up automatic database backups (Supabase auto-backups)
- [ ] Export database schema weekly
- [ ] Backup S3 files (AWS lifecycle policies)

---

## Troubleshooting

### Frontend Issues
- **Build fails:** Check Node.js version (use 18+)
- **API calls fail:** Check NEXT_PUBLIC_API_URL
- **PWA not working:** Check manifest.json and service worker

### Backend Issues
- **Database connection fails:** Check DATABASE_URL format
- **Redis connection fails:** Check REDIS_URL format
- **API slow:** Check database indexes, add caching

### Database Issues
- **Tables not created:** Run `alembic upgrade head`
- **Foreign key errors:** Check table creation order
- **Slow queries:** Add indexes on frequently queried fields

---

## Rollback Plan

If deployment fails:
1. Revert to previous working version
2. Check error logs (Vercel/Render dashboard)
3. Fix issues locally
4. Redeploy

---

**Deployment Complete!** ✅

Test thoroughly before submitting to SIH26092.
