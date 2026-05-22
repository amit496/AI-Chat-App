/** Admin panel API — calls /api/admin/* only */

export const API_BASE = '/api';

export const brandName = () => window.__BRAND__?.name ?? 'App';

export function getToken() {
    return localStorage.getItem('admin_token');
}

export async function adminRequest(path, options = {}) {
    const headers = {
        Accept: 'application/json',
        'Content-Type': 'application/json',
        ...(options.headers || {}),
    };
    const token = getToken();
    if (token) headers.Authorization = `Bearer ${token}`;

    const res = await fetch(`${API_BASE}${path}`, { ...options, headers });
    const data = await res.json().catch(() => ({}));

    if (res.status === 401 || res.status === 403) {
        localStorage.removeItem('admin_token');
        throw new Error(data.message || 'Session expired. Please login again.');
    }

    if (!res.ok) throw new Error(data.message || 'Request failed');
    return data;
}

export function formatDate(value) {
    if (!value) return '—';
    return new Date(value).toLocaleString();
}

export function refId(row) {
    return row?.eid ?? row?.id;
}

export function detailPath(segment, id) {
    return `/admin/${segment}/${encodeURIComponent(String(id))}`;
}
