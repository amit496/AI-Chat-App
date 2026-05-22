# Zynthio AI Chat App

Laravel backend structure (same pattern as zcart-react):

```
backend/
├── app/Http/Controllers/
│   ├── Admin/              # Back office API logic
│   └── Api/                # Mobile app API logic
├── routes/
│   ├── web.php             # Storefront pages
│   ├── admin/
│   │   ├── web.php         # /admin page
│   │   └── api.php         # /api/admin/*
│   └── api/
│       └── app.php         # /api/* (Flutter)
├── resources/
│   ├── js/
│   │   ├── admin.jsx       # Admin entry
│   │   ├── storefront.jsx  # Website entry
│   │   └── Pages/
│   │       ├── Admin/      # Back office React
│   │       └── Storefront/ # User website React
│   ├── css/
│   │   ├── admin.css
│   │   └── storefront.css
│   └── views/
│       ├── admin/
│       └── storefront/
└── database/

flutter_app/                # Mobile app
```

## URLs

| Area | URL |
|------|-----|
| Storefront | http://127.0.0.1:8000/ |
| Back office | http://127.0.0.1:8000/admin |
| Mobile API | http://127.0.0.1:8000/api |
| Admin API | http://127.0.0.1:8000/api/admin |

## Run

```bash
cd backend
composer install && cp .env.example .env
php artisan key:generate && php artisan migrate --seed
npm install && npm run build
php artisan serve
```

Admin: `admin@zynthio.test` / `password`
