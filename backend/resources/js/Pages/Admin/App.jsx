import { useState } from 'react';
import { getToken } from '../../lib/adminApi';
import BackOffice from './BackOffice';
import Login from './Login';

/**
 * Back office root — /admin
 * Login.jsx → BackOffice.jsx (dashboard, users, …)
 */
export default function AdminApp() {
    const [authed, setAuthed] = useState(!!getToken());
    const [adminUser, setAdminUser] = useState(() => {
        try {
            const raw = localStorage.getItem('admin_user');
            return raw ? JSON.parse(raw) : null;
        } catch {
            return null;
        }
    });

    function handleLogout(clearOnly) {
        localStorage.removeItem('admin_token');
        localStorage.removeItem('admin_user');
        setAuthed(false);
        setAdminUser(null);
        if (clearOnly) window.location.reload();
    }

    if (!authed) {
        return (
            <Login
                onSuccess={(admin) => {
                    setAdminUser(admin);
                    setAuthed(true);
                }}
            />
        );
    }

    return <BackOffice adminUser={adminUser} onLogout={handleLogout} />;
}
