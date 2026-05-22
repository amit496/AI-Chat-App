# Architecture — kya kahan se aata hai

## 3 alag cheezein (confusion mat karo)

| # | Kya hai | Kaun use karta hai | URL |
|---|---------|-------------------|-----|
| 1 | **Storefront** | Public website (future web app) | `/` |
| 2 | **Back office** | Admin panel (dashboard, users, logs) | `/admin` |
| 3 | **Mobile API** | Flutter app | `/api/*` |

Flutter app **alag folder** hai: `flutter_app/` — yahan React nahi hai.

---

## Storefront (user website)

```
Browser → GET /
    → routes/web.php
    → view: resources/views/storefront/home.blade.php
    → layout: resources/views/storefront/layouts/app.blade.php
    → Vite: resources/js/storefront.jsx
    → React: resources/js/Pages/Storefront/Home.jsx
```

**API use nahi karta** (abhi sirf welcome page).

---

## Back office (admin)

```
Browser → GET /admin
    → routes/admin/web.php
    → view: resources/views/admin/app.blade.php
    → layout: resources/views/admin/layouts/backoffice.blade.php
    → Vite: resources/js/admin.jsx
    → React: resources/js/Pages/Admin/App.jsx
```

### Admin React pages (file → screen)

| File | Screen |
|------|--------|
| `Pages/Admin/Login.jsx` | Login form |
| `Pages/Admin/BackOffice.jsx` | Data load + routing |
| `Layouts/Admin/BackOfficeLayout.jsx` | Sidebar + top bar |
| `Pages/Admin/Dashboard/Overview.jsx` | Dashboard stats |
| `Pages/Admin/Users/List.jsx` | Users table |
| `Pages/Admin/Users/Show.jsx` | One user + chats |
| `Pages/Admin/Chats/Show.jsx` | Chat messages |
| `Pages/Admin/AiUsage/List.jsx` | AI logs table |
| `Pages/Admin/AiUsage/Show.jsx` | One AI log |
| `Pages/Admin/Errors/List.jsx` | Errors table |
| `Pages/Admin/Errors/Show.jsx` | One error |

### Admin API (data)

```
React → fetch /api/admin/*
    → routes/admin/api.php
    → app/Http/Controllers/Admin/*
    → database
```

| API | Controller |
|-----|------------|
| `/api/admin/login` | AuthController |
| `/api/admin/stats` | DashboardController |
| `/api/admin/users` | UserController |
| `/api/admin/chats/{id}` | ChatController |

---

## Mobile (Flutter)

```
Flutter → /api/register, /api/login, /api/send-message, …
    → routes/api/app.php
    → app/Http/Controllers/Api/*
```

---

## Folder map (ek nazar mein)

```
backend/
├── routes/
│   ├── web.php              → storefront /
│   ├── admin/web.php        → back office /admin
│   ├── admin/api.php        → back office API
│   └── api/app.php          → Flutter API
├── resources/
│   ├── views/
│   │   ├── admin/           ← BACK OFFICE Blade only
│   │   └── storefront/      ← USER website Blade only
│   └── js/
│       ├── admin.jsx          → entry back office
│       ├── storefront.jsx     → entry storefront
│       ├── Pages/Admin/       ← back office screens
│       ├── Pages/Storefront/  ← user website screens
│       ├── Layouts/Admin/     ← admin sidebar shell
│       └── Components/Admin/  ← shared admin UI
└── app/Http/Controllers/
    ├── Admin/               ← back office API logic
    └── Api/                 ← mobile API logic
```
