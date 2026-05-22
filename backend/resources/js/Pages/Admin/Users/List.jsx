import { useState } from 'react';
import DataTable from '../../../Components/Admin/DataTable';
import { formatDate, refId } from '../../../lib/adminApi';

/** Back office → Users table */
export default function UsersList({ users, onOpenUser }) {
    const [search, setSearch] = useState('');

    const filtered = users.filter((u) => {
        const q = search.trim().toLowerCase();
        if (!q) return true;
        return (
            String(u.name || '').toLowerCase().includes(q) ||
            String(u.email || '').toLowerCase().includes(q) ||
            String(u.id).includes(q)
        );
    });

    const viewBtn = (onClick) => (
        <button type="button" className="btn-link" onClick={onClick}>
            View →
        </button>
    );

    return (
        <section className="panel">
            <div className="panel-toolbar">
                <p className="panel-desc">App users who registered via Flutter mobile.</p>
                <input
                    type="search"
                    className="search-input"
                    placeholder="Search name, email, ID…"
                    value={search}
                    onChange={(e) => setSearch(e.target.value)}
                />
            </div>
            <p className="panel-meta">{filtered.length} user(s)</p>
            <DataTable
                emptyText="No users match your search."
                rows={filtered}
                onRowClick={(r) => onOpenUser(refId(r))}
                columns={[
                    { key: 'id', label: 'ID' },
                    { key: 'name', label: 'Name' },
                    { key: 'email', label: 'Email' },
                    { key: 'chats_count', label: 'Chats', render: (r) => r.chats_count ?? 0 },
                    { key: 'created_at', label: 'Joined', render: (r) => formatDate(r.created_at) },
                    {
                        key: 'actions',
                        label: '',
                        stopRowClick: true,
                        render: (r) => viewBtn(() => onOpenUser(refId(r))),
                    },
                ]}
            />
        </section>
    );
}
