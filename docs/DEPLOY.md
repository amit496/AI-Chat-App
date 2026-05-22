# Deploy Voxera (Render + GitHub)

## GitHub

```bash
git init
git add .
git commit -m "Voxera — AI chat app"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/voxera-chat.git
git push -u origin main
```

## Render (free tier)

1. [render.com](https://render.com) → **New Web Service**
2. Connect GitHub repo
3. **Root Directory:** `backend`
4. **Runtime:** PHP
5. **Build Command:**
   ```bash
   composer install --no-dev --optimize-autoloader && php artisan migrate --force && php artisan storage:link && php artisan optimize
   ```
6. **Start Command:**
   ```bash
   php artisan serve --host=0.0.0.0 --port=$PORT
   ```
7. **Environment variables:**
   - `APP_KEY` (generate)
   - `APP_URL` = your Render URL
   - `GEMINI_API_KEY` = real key from AI Studio
   - `APP_ENV=production`
   - `APP_DEBUG=false`

Or use `backend/render.yaml` with Blueprint deploy.

## Flutter app API URL

After deploy:

```bash
flutter run --dart-define=API_BASE_URL=https://YOUR-APP.onrender.com/api
```

## Demo video & screenshots

1. Run app on emulator/device
2. Capture: Login, Register, Chat, Dark mode, Settings, Profile
3. Save to `/screenshots/`
4. Record 2–3 min demo for YouTube/LinkedIn

Replace placeholder PNGs in `screenshots/` with real captures.
