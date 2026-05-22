# Backend

## Routes (like zcart-react)

```
routes/
├── web.php           → storefront home + includes admin/web.php
├── admin/
│   ├── web.php       → GET /admin
│   └── api.php       → /api/admin/*
└── api/
    └── app.php       → /api/* (Flutter)
```

## Resources

```
resources/
├── js/Pages/Admin/       Back office React
├── js/Pages/Storefront/  User website React
├── views/admin/          Admin Blade shell
└── views/storefront/     Storefront Blade
```

## Controllers

```
app/Http/Controllers/Admin/
app/Http/Controllers/Api/
```
