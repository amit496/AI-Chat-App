{{--
  BACK OFFICE layout — admin only
  URL: /admin
  React entry: resources/js/admin.jsx → Pages/Admin/App.jsx
--}}
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>{{ config('app.name') }} — Back Office</title>
    <link rel="icon" type="image/svg+xml" href="/favicon.svg">
    <script>window.__BRAND__ = { name: @json(config('app.name')) };</script>
    @vite(['resources/css/admin.css', 'resources/js/admin.jsx'])
</head>
<body class="admin-body">
    @yield('content')
</body>
</html>
