import { useEffect, useState } from 'react';

const API_BASE = '/api';
const brandName = () => window.__BRAND__?.name ?? 'App';

function getToken() {
    return localStorage.getItem('admin_token');
}

async function request(path, options = {}) {
    const headers = {
        Accept: 'application/json',
        'Content-Type': 'application/json',
        ...(options.headers || {}),
    };
    const token = getToken();
    if (token) headers.Authorization = `Bearer ${token}`;

    const res = await fetch(`${API_BASE}${path}`, { ...options, headers });
    const data = await res.json().catch(() => ({}));
    if (!res.ok) throw new Error(data.message || 'Request failed');
    return data;
}

function LoginForm({ onSuccess }) {
    const [email, setEmail] = useState('admin@zynthio.test');
    const [password, setPassword] = useState('password');
    const [error, setError] = useState('');
    const [loading, setLoading] = useState(false);

    async function submit(e) {
        e.preventDefault();
        setLoading(true);
        setError('');
        try {
            const data = await request('/admin/login', {
                method: 'POST',
                body: JSON.stringify({ email, password }),
            });
            localStorage.setItem('admin_token', data.token);
            onSuccess();
        } catch (err) {
            setError(err.message);
        } finally {
            setLoading(false);
        }
    }

    return (
        <form className="login-card" onSubmit={submit}>
            <img src="/logo.png" alt={brandName()} width="72" height="72" style={{ borderRadius: 16, alignSelf: 'center' }} />
            <h1>{brandName()} Admin</h1>
            <p>Laravel Blade view + React component</p>
            <label>
                Email
                <input type="email" value={email} onChange={(e) => setEmail(e.target.value)} required />
            </label>
            <label>
                Password
                <input type="password" value={password} onChange={(e) => setPassword(e.target.value)} required />
            </label>
            {error && <p className="error">{error}</p>}
            <button type="submit" disabled={loading}>
                {loading ? 'Signing in...' : 'Sign in'}
            </button>
        </form>
    );
}

function Dashboard() {
    const [stats, setStats] = useState(null);
    const [users, setUsers] = useState([]);
    const [usage, setUsage] = useState([]);
    const [errors, setErrors] = useState([]);
    const [tab, setTab] = useState('overview');
    const [loadError, setLoadError] = useState('');

    useEffect(() => {
        async function load() {
            try {
                const [s, u, a, e] = await Promise.all([
                    request('/admin/stats'),
                    request('/admin/users'),
                    request('/admin/ai-usage'),
                    request('/admin/errors'),
                ]);
                setStats(s);
                setUsers(u.data || []);
                setUsage(a.data || []);
                setErrors(e.data || []);
            } catch (err) {
                setLoadError(err.message);
            }
        }
        load();
    }, []);

    return (
        <div className="dashboard">
            <header className="dash-header">
                <div style={{ display: 'flex', alignItems: 'center', gap: 12 }}>
                    <img src="/logo.png" alt={brandName()} width="40" height="40" style={{ borderRadius: 10 }} />
                    <h1>Admin Dashboard</h1>
                </div>
                <button
                    type="button"
                    onClick={() => {
                        localStorage.removeItem('admin_token');
                        window.location.reload();
                    }}
                >
                    Logout
                </button>
            </header>

            <nav className="tabs">
                {['overview', 'users', 'ai', 'errors'].map((t) => (
                    <button key={t} type="button" className={tab === t ? 'active' : ''} onClick={() => setTab(t)}>
                        {t}
                    </button>
                ))}
            </nav>

            {loadError && <p className="error">{loadError}</p>}

            {tab === 'overview' && stats && (
                <div className="stats-grid">
                    {Object.entries(stats).map(([key, value]) => (
                        <div key={key} className="stat-card">
                            <span>{key.replace(/_/g, ' ')}</span>
                            <strong>{value}</strong>
                        </div>
                    ))}
                </div>
            )}

            {tab === 'users' && (
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Name</th>
                            <th>Email</th>
                        </tr>
                    </thead>
                    <tbody>
                        {users.map((u) => (
                            <tr key={u.id}>
                                <td>{u.id}</td>
                                <td>{u.name}</td>
                                <td>{u.email}</td>
                            </tr>
                        ))}
                    </tbody>
                </table>
            )}

            {tab === 'ai' && (
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>User</th>
                            <th>Model</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        {usage.map((l) => (
                            <tr key={l.id}>
                                <td>{l.id}</td>
                                <td>{l.user_id}</td>
                                <td>{l.model}</td>
                                <td>{l.status}</td>
                            </tr>
                        ))}
                    </tbody>
                </table>
            )}

            {tab === 'errors' && (
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Endpoint</th>
                            <th>Message</th>
                        </tr>
                    </thead>
                    <tbody>
                        {errors.map((e) => (
                            <tr key={e.id}>
                                <td>{e.id}</td>
                                <td>{e.endpoint}</td>
                                <td>{e.message}</td>
                            </tr>
                        ))}
                    </tbody>
                </table>
            )}
        </div>
    );
}

export default function AdminApp() {
    const [authed, setAuthed] = useState(!!getToken());

    if (!authed) {
        return <LoginForm onSuccess={() => setAuthed(true)} />;
    }

    return <Dashboard />;
}
