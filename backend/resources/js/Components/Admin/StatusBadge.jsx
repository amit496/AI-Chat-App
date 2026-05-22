export default function StatusBadge({ status }) {
    const s = String(status || '').toLowerCase();
    const ok = s === 'success' || s === 'ok' || s === '200';
    return <span className={`status-pill ${ok ? 'status-ok' : 'status-fail'}`}>{status || '—'}</span>;
}
