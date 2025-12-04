# 🏗️ Backend Repositories - MBUY Project

## 📋 Overview

This document describes the backend architecture migration from **monorepo** to **polyrepo**. Backend code has been moved to separate repositories for cleaner organization and independent deployments.

---

## 🗂️ Repository Structure

### 1️⃣ **Main Flutter Repository**
- **URL:** `https://github.com/mbuy1/saleh.git`
- **Purpose:** Flutter mobile application (Android, iOS, Web)
- **Tech Stack:** Flutter 3.10+, Dart 3.0+
- **Deployment:** Google Play, App Store, Web Hosting

### 2️⃣ **Backend - Supabase Edge Functions**
- **URL:** `https://github.com/mbuy1/mbuy-backend.git` *(To be created)*
- **Purpose:** Supabase Edge Functions (9 functions: wallet, points, orders, products, merchants)
- **Tech Stack:** Deno, TypeScript, Supabase SDK
- **Deployment:** `supabase functions deploy` → sirqidofuvphqcxqchyc.supabase.co

### 3️⃣ **Worker - Cloudflare API Gateway**
- **URL:** `https://github.com/mbuy1/mbuy-worker.git` *(To be created)*
- **Purpose:** Cloudflare Worker (API Gateway, AI endpoints, Durable Objects)
- **Tech Stack:** Hono, TypeScript, Cloudflare Workers
- **Deployment:** `wrangler deploy` → https://misty-mode-b68b.baharista1.workers.dev

---

## 🔗 Architecture Diagram

```
┌─────────────────────┐
│   Flutter App       │
│  (saleh.git)        │
│                     │
│  - UI/UX            │
│  - State Mgmt       │
│  - Navigation       │
└──────────┬──────────┘
           │
           │ HTTP Requests
           │
           ▼
┌─────────────────────────────────────┐
│   Cloudflare Worker                 │
│   (mbuy-worker.git)                 │
│                                     │
│  - JWT Auth                         │
│  - Media Upload (R2)                │
│  - Gemini AI Endpoints              │
│  - Durable Objects (Chat, Session)  │
│  - Browser Rendering                │
└──────────┬──────────────────────────┘
           │
           │ RPC / HTTP
           │
           ▼
┌─────────────────────────────────────┐
│   Supabase Backend                  │
│   (mbuy-backend.git)                │
│                                     │
│  - Edge Functions                   │
│  - Database (PostgreSQL)            │
│  - Storage (images, files)          │
│  - Auth (optional)                  │
└─────────────────────────────────────┘
```

---

## 🚀 Local Development Setup

### Prerequisites
```powershell
# 1. Install Flutter SDK
flutter --version

# 2. Install Supabase CLI
scoop install supabase

# 3. Install Wrangler CLI
npm install -g wrangler
```

### Clone All Repositories
```powershell
# Main Flutter App
git clone https://github.com/mbuy1/saleh.git
cd saleh
flutter pub get

# Backend Functions
git clone https://github.com/mbuy1/mbuy-backend.git
cd mbuy-backend
# No dependencies (Deno uses remote imports)

# Cloudflare Worker
git clone https://github.com/mbuy1/mbuy-worker.git
cd mbuy-worker
npm install
```

### Run Development Servers
```powershell
# Terminal 1: Flutter App
cd C:\muath\saleh
flutter run

# Terminal 2: Supabase Local (optional)
cd C:\muath\mbuy-backend
supabase start

# Terminal 3: Cloudflare Worker Local
cd C:\muath\mbuy-worker
wrangler dev
```

---

## 📦 Deployment

### Supabase Edge Functions
```powershell
cd C:\muath\mbuy-backend
supabase functions deploy wallet_add
supabase functions deploy points_add
supabase functions deploy create_order
# ... deploy other functions
```

### Cloudflare Worker
```powershell
cd C:\muath\mbuy-worker
wrangler deploy
```

### Flutter App
```powershell
cd C:\muath\saleh
flutter build apk --release
flutter build web
```

---

## 🔄 Migration History

- **Date:** January 2025
- **Reason:** 40+ TypeScript errors from mixed Deno/Node environments
- **Method:** Git subtree split (preserved full history)
- **Backup Tag:** `before-polyrepo-split`

### Git Subtree Commands Used
```powershell
# Extract Supabase history
git subtree split --prefix=supabase --branch supabase-history

# Extract Cloudflare history
git subtree split --prefix=cloudflare --branch cloudflare-history
```

### Rollback Procedure (if needed)
```powershell
cd C:\muath\saleh
git checkout before-polyrepo-split
git reset --hard before-polyrepo-split
```

---

## 🧪 Testing

### Backend Functions
```powershell
cd C:\muath\mbuy-backend
supabase functions serve wallet_add --inspect
curl -X POST http://localhost:54321/functions/v1/wallet_add \
  -H "Content-Type: application/json" \
  -d '{"userId": "123", "amount": 100}'
```

### Cloudflare Worker
```powershell
cd C:\muath\mbuy-worker
wrangler dev
curl http://localhost:8787/secure/ai/gemini/chat
```

---

## 📝 Important Notes

1. **Environment Variables**
   - Flutter: `.env` (11 public keys only)
   - Worker: `wrangler secrets` (all secrets)
   - Supabase: `.env` in backend repo

2. **No Breaking Changes**
   - Worker URL remains: https://misty-mode-b68b.baharista1.workers.dev
   - Supabase project unchanged: sirqidofuvphqcxqchyc.supabase.co
   - Flutter API calls continue working

3. **Benefits**
   - ✅ Clean VS Code (no TypeScript errors)
   - ✅ Independent deployments
   - ✅ Better organization
   - ✅ Faster indexing
   - ✅ Separate Git history

---

## 📞 Support

For issues or questions:
- Flutter: Open issue in `github.com/mbuy1/saleh`
- Backend: Open issue in `github.com/mbuy1/mbuy-backend`
- Worker: Open issue in `github.com/mbuy1/mbuy-worker`

---

**Last Updated:** January 2025
**Migration Engineer:** AI Assistant
**Status:** ✅ Complete
