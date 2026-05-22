# Zynthio — Complete Admin Panel

Admin panel = **Laravel API** + **React (Vite)** + **Blade page**.

## Open admin

```
http://127.0.0.1:8000/admin
```

**Not** `/admin/login` as a separate page — login form is on `/admin`.  
(`/admin/login` redirects to `/admin`.)

API login (JSON only): `POST http://127.0.0.1:8000/api/admin/login`

(Default `php artisan serve` port is **8000**.)

## Login credentials

| Field | Value |
|--------|--------|
| Email | `admin@zynthio.test` |
| Password | `password` |

Create admin (first time):

```bash
cd backend
php artisan db:seed --class=AdminSeeder
```

---

## Features

| Feature | Description |
|---------|-------------|
| **Login** | Sanctum token → `localStorage.admin_token` |
| **Logout** | `POST /api/admin/logout` + clear token |
| **Dashboard** | Stats: users, chats, messages, AI requests, errors |
| **Users list** | All app users + search + chat count |
| **AI usage** | Gemini request logs |
| **Errors** | API error logs |
| **Refresh** | Reload all data |

---

## File structure (poora code)

```
backend/
├── routes/
│   ├── web.php                    → GET /admin (Blade page)
│   └── api.php                    → Admin API routes
├── resources/
│   ├── views/admin.blade.php      → HTML shell
│   ├── js/
│   │   ├── admin.jsx              → React entry
│   │   └── components/AdminApp.jsx → Login + Dashboard UI
│   └── css/app.css                → Admin styles
├── app/
│   ├── Models/Admin.php
│   ├── Http/Middleware/EnsureAdmin.php
│   └── Http/Controllers/Admin/
│       ├── AuthController.php     → login, logout
│       ├── DashboardController.php  → stats
│       ├── UserController.php     → users list
│       └── AnalyticsController.php → AI + errors
└── database/
    ├── migrations/..._create_admins_table.php
    └── seeders/AdminSeeder.php
```

---

## API endpoints

| Method | URL | Auth | Action |
|--------|-----|------|--------|
| POST | `/api/admin/login` | No | Login |
| POST | `/api/admin/logout` | Bearer admin token | Logout |
| GET | `/api/admin/stats` | Admin | Dashboard numbers |
| GET | `/api/admin/users` | Admin | User list (paginated) |
| GET | `/api/admin/ai-usage` | Admin | AI logs |
| GET | `/api/admin/errors` | Admin | Error logs |

Header for protected routes:

```
Authorization: Bearer {admin_token}
```

---

## Database

Users shown in admin come from **`users`** table (Flutter app register).

Default DB: **SQLite** → `backend/database/database.sqlite`

Tables: `users`, `chats`, `messages`, `admins`, `ai_usage_logs`, `error_logs`

---

## Build frontend assets

After changing React/CSS:

```bash
cd backend
npm run build
```

Dev with hot reload:

```bash
npm run dev
```

---

## Main React file

All UI logic is in one file:

**`backend/resources/js/components/AdminApp.jsx`**

- `LoginForm` — email/password
- `Dashboard` — sidebar + tabs
- `DataTable` — reusable table
- `AdminApp` — root (login vs dashboard)

---

## Main API routes (`routes/api.php`)

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

## Troubleshooting

| Problem | Fix |
|---------|-----|
| Login fails | Run `php artisan db:seed --class=AdminSeeder` |
| Blank admin page | Run `npm run build` in `backend/` |
| 403 Unauthorized | Token expired — login again |
| No users in list | Register from Flutter app first |
