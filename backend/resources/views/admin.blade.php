<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>{{ config('app.name') }} Admin</title>
    <link rel="icon" type="image/png" href="/logo.png">
    <script>window.__BRAND__ = { name: @json(config('app.name')) };</script>
    @vite(['resources/css/app.css', 'resources/js/admin.jsx'])
</head>
<body class="admin-body">
    <div id="admin-app"></div>
</body>
</html>
