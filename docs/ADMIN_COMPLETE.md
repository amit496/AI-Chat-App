# Zynthio Admin Panel — Poora Structure + Code Guide

## Login fix (Invalid credentials)

Terminal mein ye chalao:

```bash
cd backend
php artisan admin:ensure
```

Phir browser: **http://127.0.0.1:8000/admin**

| Email | Password |
|--------|----------|
| `admin@zynthio.test` | `password` |

---

## Sahi URL

| URL | Kaam |
|-----|------|
| `http://127.0.0.1:8000/admin` | Admin panel (login + dashboard) |
| `http://127.0.0.1:8000/api/admin/login` | API only (POST, JSON) |

`/admin/login` → redirect → `/admin`

---

## Poora directory structure

```
AI-Chat-App/
└── backend/                              ← Laravel API + Admin
    ├── app/
    │   ├── Console/Commands/
    │   │   └── EnsureAdminCommand.php      ← php artisan admin:ensure
    │   ├── Http/
    │   │   ├── Controllers/
    │   │   │   ├── Admin/
    │   │   │   │   ├── AuthController.php       ← login, logout
    │   │   │   │   ├── DashboardController.php  ← stats
    │   │   │   │   ├── UserController.php       ← users list
    │   │   │   │   └── AnalyticsController.php  ← AI + errors
    │   │   │   └── Api/
    │   │   │       ├── AuthController.php       ← app user auth
    │   │   │       ├── ChatController.php
    │   │   │       └── ProfileController.php
    │   │   └── Middleware/
    │   │       └── EnsureAdmin.php              ← admin token check
    │   ├── Models/
    │   │   ├── Admin.php
    │   │   ├── User.php
    │   │   ├── Chat.php
    │   │   ├── Message.php
    │   │   ├── AiUsageLog.php
    │   │   └── ErrorLog.php
    │   └── Support/
    │       └── PublicStorageUrl.php
    │
    ├── bootstrap/app.php                   ← API routes + admin middleware
    │
    ├── config/
    │   ├── auth.php
    │   ├── sanctum.php
    │   └── services.php                    ← Gemini config
    │
    ├── database/
    │   ├── database.sqlite                 ← SQLite DB (default)
    │   ├── migrations/
    │   │   ├── ..._create_users_table.php
    │   │   ├── ..._create_admins_table.php
    │   │   ├── ..._create_chats_table.php
    │   │   ├── ..._create_messages_table.php
    │   │   ├── ..._create_ai_usage_logs_table.php
    │   │   └── ..._create_error_logs_table.php
    │   └── seeders/
    │       ├── DatabaseSeeder.php
    │       └── AdminSeeder.php             ← default admin
    │
    ├── public/
    │   ├── index.php
    │   ├── logo.png
    │   └── build/                          ← npm run build output
    │
    ├── resources/
    │   ├── css/
    │   │   └── app.css                     ← Admin UI styles
    │   ├── js/
    │   │   ├── admin.jsx                   ← React entry
    │   │   └── components/
    │   │       └── AdminApp.jsx            ← POORA admin UI (login, dashboard, users)
    │   └── views/
    │       ├── admin.blade.php             ← /admin page shell
    │       └── home.blade.php
    │
    ├── routes/
    │   ├── web.php                         ← GET /admin
    │   └── api.php                         ← /api/admin/*
    │
    ├── .env                                ← DB, GEMINI_API_KEY
    └── package.json                        ← Vite + React
```

---

## Har file ka kaam

### Frontend (React)

| File | Kaam |
|------|------|
| `resources/views/admin.blade.php` | HTML page, `#admin-app` mount |
| `resources/js/admin.jsx` | React start |
| `resources/js/components/AdminApp.jsx` | Login form, sidebar, dashboard, users table, AI logs, errors, logout |
| `resources/css/app.css` | Admin design |

### Backend (Laravel)

| File | Kaam |
|------|------|
| `routes/web.php` | Browser URL `/admin` |
| `routes/api.php` | Admin API routes |
| `AuthController.php` | `POST login`, `POST logout` |
| `DashboardController.php` | `GET stats` |
| `UserController.php` | `GET users` (paginated) |
| `AnalyticsController.php` | `GET ai-usage`, `GET errors` |
| `EnsureAdmin.php` | Sirf Admin token allow |
| `Admin.php` | Admin model + Sanctum tokens |

---

## API routes (`routes/api.php`)

```php
Route::prefix('admin')->group(function () {
    Route::post('/login', [AdminAuthController::class, 'login']);

    Route::middleware(['auth:sanctum', 'admin'])->group(function () {
        Route::post('/logout', [AdminAuthController::class, 'logout']);
        Route::get('/stats', [AdminDashboardController::class, 'stats']);
        Route::get('/users', [AdminUserController::class, 'index']);
        Route::get('/ai-usage', [AdminAnalyticsController::class, 'aiUsage']);
        Route::get('/errors', [AdminAnalyticsController::class, 'errors']);
    });
});
```

---

## Web routes (`routes/web.php`)

```php
Route::get('/admin', fn () => view('admin'));
Route::redirect('/admin/login', '/admin');
```

---

## Setup (pehli baar)

```bash
cd backend
composer install
cp .env.example .env
php artisan key:generate
php artisan migrate
php artisan admin:ensure
npm install
npm run build
php artisan serve
```

Open: **http://127.0.0.1:8000/admin**

---

## Database

Default: **SQLite** → `backend/database/database.sqlite`

| Table | Data |
|--------|------|
| `admins` | Admin login |
| `users` | Flutter app users (admin Users tab) |
| `chats` | Chat threads |
| `messages` | Messages |
| `ai_usage_logs` | Gemini usage |
| `error_logs` | API errors |

MySQL ke liye `.env`:

```env
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_DATABASE=zynthio
DB_USERNAME=root
DB_PASSWORD=
```

Phir: `php artisan migrate && php artisan admin:ensure`

---

## Admin features

1. **Login** — email/password → token
2. **Logout** — API + clear browser storage
3. **Dashboard** — users, chats, messages, AI count
4. **Users** — list + search
5. **AI Usage** — model, tokens, status
6. **Errors** — failed API calls
7. **Refresh** — reload data

---

## Main code file (sabse bada)

Poora React admin UI ek file mein:

**`backend/resources/js/components/AdminApp.jsx`**

Cursor mein ye file kholo — login, dashboard, users, logout sab yahi hai.

---

## Agar login phir fail ho

```bash
php artisan admin:ensure
php artisan config:clear
```

Browser cache clear / incognito window try karo.
