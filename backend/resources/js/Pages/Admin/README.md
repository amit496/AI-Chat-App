# Pages/Admin — Back Office React

| File | What you see |
|------|----------------|
| `App.jsx` | Root: login vs dashboard |
| `Login.jsx` | Admin sign-in |
| `BackOffice.jsx` | Loads data, picks which page |
| `Dashboard/Overview.jsx` | Dashboard + stats |
| `Users/List.jsx` | Users table |
| `Users/Show.jsx` | Single user detail |
| `Chats/Show.jsx` | Chat messages |
| `AiUsage/List.jsx` | AI usage table |
| `AiUsage/Show.jsx` | AI log detail |
| `Errors/List.jsx` | Errors table |
| `Errors/Show.jsx` | Error detail |

Layout (sidebar): `resources/js/Layouts/Admin/BackOfficeLayout.jsx`

API: `resources/js/lib/adminApi.js` → `/api/admin/*`
