# NovaAI — AI Chat App

> **Dummy API keys** are in `backend/.env` for local run. Replace `GEMINI_API_KEY` with your real key from [Google AI Studio](https://aistudio.google.com/apikey).

## Branding / Logo

- Shared logo: `flutter_app/assets/logo/logo.png`
- Flutter: `AppLogo` widget on every screen (splash, onboarding, auth, home, chat, settings)
- Web admin: `/logo.png` on home + React admin (`/admin`)

## Project structure

```text
flutter_app/     # NovaAI mobile app (Flutter)
backend/         # Laravel API + React admin (Blade + Vite)
screenshots/     # Portfolio screenshots
```

## Quick start

### Backend (Laravel + React views)

```bash
cd backend
cp .env.example .env
# Add GEMINI_API_KEY from https://aistudio.google.com/apikey
composer install
php artisan key:generate
php artisan migrate --seed
php artisan storage:link
npm install && npm run build
php artisan serve
```

- Home (React): http://127.0.0.1:8000/
- Admin (React in Blade): http://127.0.0.1:8000/admin
- API base: http://127.0.0.1:8000/api

Admin login: `admin@novaai.test` / `password` (run `php artisan db:seed` if missing)

Dev with hot reload: `npm run dev` + `php artisan serve`

### Flutter app

```bash
cd flutter_app
flutter pub get
flutter run
# Android emulator:
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8000/api
```

## Laravel + React setup

React components live in `backend/resources/js/`:

- `app.jsx` → mounted in `resources/views/home.blade.php`
- `admin.jsx` → mounted in `resources/views/admin.blade.php`

Blade layouts use `@vite()` to load React bundles.

## Tech stack

Flutter · Laravel · Sanctum · Gemini API · Firebase Auth (optional) · SQLite
