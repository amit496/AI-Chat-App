{{--
  STOREFRONT layout — public website for users
  URL: /
  React entry: resources/js/storefront.jsx → Pages/Storefront/Home.jsx
--}}
<!DOCTYPE html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>{{ $title ?? config('app.name') }}</title>
    <link rel="icon" type="image/svg+xml" href="/favicon.svg">
    <script>window.__BRAND__ = { name: @json(config('app.name')) };</script>
    @vite(['resources/css/storefront.css', 'resources/js/storefront.jsx'])
</head>
<body class="antialiased">
    @yield('content')
</body>
</html>
