# Zynthio AI Chat App — CV & Portfolio Document

**Project name:** Zynthio (AI Chat Application)  
**Type:** Personal / Portfolio — Full-Stack  
**Author:** Amit Gautam *(update with your details)*

---

## 1. One-line summary (CV headline)

Full-stack AI chat platform with **Flutter** mobile app, **Laravel 13** REST API, **React** admin back office, and **Google Gemini** integration — including auth, chat history, analytics, and release Android APK.

---

## 2. Projects section (copy for resume)

**Zynthio — AI Chat Application** | Personal Project  
*Flutter · Laravel · React · Google Gemini API · Firebase*

- Built a **full-stack AI chat platform** with a cross-platform **Flutter** mobile app, **Laravel 13** REST API, and **React** back-office admin panel.
- Integrated **Google Gemini API** for conversational AI with persistent chat history, usage logging, and error tracking.
- Implemented authentication via **Laravel Sanctum**, email/password login, **Firebase Auth**, and **Google Sign-In** (OTP-ready architecture).
- Designed a **ChatGPT-style** mobile UI: dark/light theme, conversation sidebar, markdown AI responses, voice input, and image attachments.
- Developed an **admin dashboard** for user management, chat/message inspection, AI usage analytics, and secure encrypted IDs in admin APIs.
- Organized codebase with separated **storefront**, **back office**, and **mobile API** routes; shipped **Android release APK** (`app-release.apk`).

**Role:** Full-Stack Developer (Solo Project)  
**Tech stack:** Flutter, Dart, Laravel 13, PHP 8.3, React, JavaScript, REST API, Sanctum, SQLite, Gemini API, Firebase, Vite, Tailwind CSS, Provider, Git

---

## 3. Short version (space-limited CV)

**Zynthio AI Chat App** — Flutter + Laravel 13 + React admin + Gemini API; auth, chat history, admin analytics, Android release build.

---

## 4. LinkedIn / portfolio (paragraph)

**Zynthio — AI-Powered Chat Application**  
Full-Stack Developer | Personal Project

End-to-end product combining a mobile chat client for end users and a web-based back office for administrators. The Flutter app consumes a REST API secured with Laravel Sanctum; admins monitor users, conversations, Gemini API usage, and error logs through a React dashboard. The backend follows a modular structure (storefront vs admin vs mobile API) with throttled endpoints and encrypted resource identifiers for admin detail views.

**Deliverables:** Flutter release APK, Laravel API with migrations/seeders, React admin panel, Gemini service integration, Firebase/Google auth integration points.

---

## 5. Technical architecture

```
AI-Chat-App/
├── flutter_app/          # Mobile app (Android/iOS)
├── backend/              # Laravel API + web shells
│   ├── app/Http/Controllers/
│   │   ├── Api/          # Mobile → /api/*
│   │   └── Admin/        # Back office → /api/admin/*
│   ├── routes/
│   │   ├── web.php
│   │   ├── admin/        # web + api routes
│   │   └── api/          # mobile routes
│   └── resources/
│       ├── js/Pages/Admin/       # Back office React
│       ├── js/Pages/Storefront/  # Public website React
│       └── views/admin|storefront/
└── docs/
```

| Layer | URL | Technology |
|-------|-----|------------|
| Storefront (users) | `/` | React + Blade |
| Back office (admin) | `/admin` | React + Blade |
| Mobile API | `/api/*` | Laravel + Sanctum |
| Admin API | `/api/admin/*` | Laravel + Sanctum |

Detailed flow: `backend/docs/ARCHITECTURE.md`

---

## 6. Key features (for interviews)

### Mobile (Flutter)
- Register / login / profile
- AI chat with Gemini (streaming-style UX, typing indicator)
- Chat list: create, open, delete (swipe + menu)
- Dark / light theme
- Markdown rendering for AI messages
- Image attach (gallery / camera)
- Voice input (speech-to-text) & TTS hooks
- Connectivity-aware error messages
- Release APK build

### Backend (Laravel)
- REST API for mobile (`Auth`, `Chat`, `Profile`)
- Admin API: stats, users, chats, AI usage logs, error logs
- Gemini service abstraction
- SQLite (default) / MySQL ready
- Rate limiting on auth & chat endpoints
- Admin ID encryption for detail URLs (`AdminId` helper)

### Back office (React)
- Admin login / logout
- Dashboard with metrics
- Users list & user detail (with chats)
- Chat detail (full message history)
- AI usage & error log viewers
- Professional sidebar layout (ChatGPT-inspired admin theme)

---

## 7. API overview (talking points)

**Mobile (`/api`):**
- `POST /register`, `POST /login`, `POST /logout`
- `POST /auth/firebase-sync`
- `GET /profile`, `POST /update-profile`
- `POST /send-message`, `GET /chat-history`, `GET /chats/{id}`
- `DELETE /delete-chat/{id}`, `DELETE /clear-chat-history`

**Admin (`/api/admin`):**
- `POST /login`, `POST /logout`
- `GET /stats`, `GET /users`, `GET /users/{encryptedId}`
- `GET /chats/{encryptedId}`, `GET /ai-usage`, `GET /errors`

---

## 8. Tech stack (skills section)

**Languages:** Dart, PHP, JavaScript  
**Frameworks:** Flutter, Laravel 13, React 19  
**APIs & services:** REST, Google Gemini API, Firebase Auth, Google Sign-In  
**Database:** SQLite, MySQL (configurable)  
**Auth:** Laravel Sanctum, Firebase  
**Frontend tooling:** Vite, Tailwind CSS 4  
**Mobile:** Provider (state), image_picker, speech_to_text, flutter_markdown  
**DevOps / tools:** Git, Composer, npm, Gradle, Android APK release build  

---

## 9. Setup (demo for interviewer)

```bash
# Backend + admin
cd backend
cp .env.example .env   # add GEMINI_API_KEY
composer install
php artisan key:generate
php artisan migrate --seed
npm install && npm run build
php artisan serve

# Admin: http://127.0.0.1:8000/admin
# Login: admin@zynthio.test / password

# Flutter
cd flutter_app
flutter pub get
flutter run
# Emulator API: http://10.0.2.2:8000/api
```

**Release APK path:**  
`flutter_app/build/app/outputs/flutter-apk/app-release.apk`

---

## 10. Interview Q&A (quick answers)

**What did you build?**  
A complete AI chat product: mobile app for users, Laravel API, and admin panel for monitoring users and AI usage.

**Why Laravel + Flutter?**  
Laravel for fast, secure API and admin ecosystem; Flutter for one codebase on Android and iOS with native-feel UI.

**How does AI work?**  
User message → Laravel `ChatController` → `GeminiService` → response saved in DB → returned to app; usage logged in `ai_usage_logs`.

**How is admin secured?**  
Separate `admins` table, Sanctum tokens, `EnsureAdmin` middleware, admin-only routes under `/api/admin`.

**Biggest challenge?**  
Full-stack integration: API base URL per environment, auth token flow, ChatGPT-like UX, and clear separation of storefront vs back office code.

---

## 11. Links to add on CV *(fill in)*

| Item | Your link |
|------|-----------|
| GitHub repository | `https://github.com/YOUR_USERNAME/AI-Chat-App` |
| Live admin (if deployed) | `https://YOUR_DOMAIN/admin` |
| Live API | `https://YOUR_DOMAIN/api` |
| Portfolio / LinkedIn | `https://linkedin.com/in/YOUR_PROFILE` |

---

## 12. Honesty checklist

- [ ] Role matches what you actually did (solo / team / internship)
- [ ] Only list technologies you can explain in interview
- [ ] Add GitHub or demo link if available
- [ ] Do not claim user counts or revenue unless real
- [ ] Update dates (e.g. `Jan 2025 – Mar 2026`)

---

## 13. Optional bullets by focus

**Flutter-focused CV:**  
Emphasize sections 6 (Mobile), 7 (mobile API), release APK, Provider, themes, markdown, image/voice.

**Backend-focused CV:**  
Emphasize Laravel 13, Sanctum, Gemini service, migrations, admin API, rate limiting, `AdminId` encryption.

**Full-stack CV:**  
Use section 2 as-is — balanced bullets across mobile, API, and admin.

---

*Document generated for portfolio use. Keep this file updated when you add deployment URLs or new features.*
