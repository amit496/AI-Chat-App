import { useEffect, useState } from 'react';
import DataTable from '../../../Components/Admin/DataTable';
import DetailHeader from '../../../Components/Admin/DetailHeader';
import InfoGrid from '../../../Components/Admin/InfoGrid';
import { adminRequest, detailPath, formatDate, refId } from '../../../lib/adminApi';

/** Back office → User detail (from Users list) */
export default function UserShow({ userId, onBack, onOpenChat }) {
    const [data, setData] = useState(null);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState('');

    useEffect(() => {
        let cancelled = false;
        (async () => {
            setLoading(true);
            setError('');
            try {
                const res = await adminRequest(detailPath('users', userId));
                if (!cancelled) setData(res);
            } catch (e) {
                if (!cancelled) setError(e.message);
            } finally {
                if (!cancelled) setLoading(false);
            }
        })();
        return () => {
            cancelled = true;
        };
    }, [userId]);

    if (loading) return <p className="panel-meta">Loading user…</p>;
    if (error) return <div className="alert error">{error}</div>;
    if (!data?.user) return <p className="empty-state">User not found.</p>;

    const u = data.user;

    return (
        <section className="panel detail-panel">
            <DetailHeader title={u.name || 'User'} subtitle={u.email} onBack={onBack} />
            <InfoGrid
                items={[
                    { label: 'User ID', value: u.id },
                    { label: 'Email', value: u.email },
                    { label: 'Total chats', value: u.chats_count ?? 0 },
                    { label: 'Joined', value: formatDate(u.created_at) },
                    { label: 'Firebase UID', value: u.firebase_uid || '—' },
                    { label: 'Last updated', value: formatDate(u.updated_at) },
                ]}
            />
            <h3 className="detail-section-title">Conversations ({data.chats?.length ?? 0})</h3>
            <DataTable
                emptyText="No chats for this user."
                rows={data.chats || []}
                columns={[
                    { key: 'id', label: 'Chat ID' },
                    { key: 'title', label: 'Title' },
                    { key: 'messages_count', label: 'Messages', render: (r) => r.messages_count ?? 0 },
                    { key: 'created_at', label: 'Created', render: (r) => formatDate(r.created_at) },
                    {
                        key: 'actions',
                        label: '',
                        stopRowClick: true,
                        render: (r) => (
                            <button type="button" className="btn-link" onClick={() => onOpenChat(refId(r))}>
                                View chat →
                            </button>
                        ),
                    },
                ]}
            />
        </section>
    );
}
