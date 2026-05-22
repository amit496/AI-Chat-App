import { useState } from 'react';
import BrandMark from '../../Components/Admin/BrandMark';
import { adminRequest, brandName } from '../../lib/adminApi';

/** Back office login — shown before admin token exists */
export default function Login({ onSuccess }) {
    const [email, setEmail] = useState('admin@zynthio.test');
    const [password, setPassword] = useState('password');
    const [error, setError] = useState('');
    const [loading, setLoading] = useState(false);

    async function submit(e) {
        e.preventDefault();
        setLoading(true);
        setError('');
        try {
            const data = await adminRequest('/admin/login', {
                method: 'POST',
                body: JSON.stringify({ email, password }),
            });
            localStorage.setItem('admin_token', data.token);
            if (data.admin) localStorage.setItem('admin_user', JSON.stringify(data.admin));
            onSuccess(data.admin);
        } catch (err) {
            setError(err.message);
        } finally {
            setLoading(false);
        }
    }

    return (
        <div className="admin-login-wrap">
            <form className="login-card" onSubmit={submit}>
                <BrandMark size="lg" variant="login" />
                <h1>{brandName()} — Back Office</h1>
                <p className="muted">Admin only · manage users, chats, AI logs</p>
                <label>
                    Email
                    <input type="email" value={email} onChange={(e) => setEmail(e.target.value)} required autoComplete="username" />
                </label>
                <label>
                    Password
                    <input
                        type="password"
                        value={password}
                        onChange={(e) => setPassword(e.target.value)}
                        required
                        autoComplete="current-password"
                    />
                </label>
                {error && <p className="error">{error}</p>}
                <button type="submit" className="btn-primary" disabled={loading}>
                    {loading ? 'Signing in…' : 'Sign in'}
                </button>
            </form>
        </div>
    );
}
