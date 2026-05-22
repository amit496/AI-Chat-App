import { useEffect, useState } from 'react';
import DetailHeader from '../../../Components/Admin/DetailHeader';
import InfoGrid from '../../../Components/Admin/InfoGrid';
import { adminRequest, detailPath, formatDate } from '../../../lib/adminApi';

/** Back office → Chat messages detail */
export default function ChatShow({ chatId, onBack }) {
    const [data, setData] = useState(null);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState('');

    useEffect(() => {
        let cancelled = false;
        (async () => {
            setLoading(true);
            setError('');
            try {
                const res = await adminRequest(detailPath('chats', chatId));
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
    }, [chatId]);

    if (loading) return <p className="panel-meta">Loading chat…</p>;
    if (error) return <div className="alert error">{error}</div>;
    if (!data?.chat) return <p className="empty-state">Chat not found.</p>;

    const c = data.chat;

    return (
        <section className="panel detail-panel">
            <DetailHeader
                title={c.title || `Chat #${c.id}`}
                subtitle={c.user ? `${c.user.name} · ${c.user.email}` : `User #${c.user_id}`}
                onBack={onBack}
            />
            <InfoGrid
                items={[
                    { label: 'Chat ID', value: c.id },
                    { label: 'Messages', value: data.messages?.length ?? 0 },
                    { label: 'Created', value: formatDate(c.created_at) },
                ]}
            />
            <h3 className="detail-section-title">Messages</h3>
            <div className="message-list">
                {(data.messages || []).map((m) => (
                    <article key={m.id} className={`message-item message-${m.sender_type}`}>
                        <header>
                            <span className="message-role">{m.sender_type === 'user' ? 'User' : 'AI'}</span>
                            <time>{formatDate(m.created_at)}</time>
                        </header>
                        <p>{m.message || (m.image_path ? '[Image attachment]' : '—')}</p>
                    </article>
                ))}
                {!data.messages?.length && <p className="empty-state">No messages in this chat.</p>}
            </div>
        </section>
    );
}
