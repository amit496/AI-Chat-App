import { useEffect, useState } from 'react';
import DetailHeader from '../../../Components/Admin/DetailHeader';
import InfoGrid from '../../../Components/Admin/InfoGrid';
import StatusBadge from '../../../Components/Admin/StatusBadge';
import { adminRequest, detailPath, formatDate } from '../../../lib/adminApi';

export default function AiUsageShow({ logId, onBack }) {
    const [log, setLog] = useState(null);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState('');

    useEffect(() => {
        let cancelled = false;
        (async () => {
            setLoading(true);
            try {
                const res = await adminRequest(detailPath('ai-usage', logId));
                if (!cancelled) setLog(res.log);
            } catch (e) {
                if (!cancelled) setError(e.message);
            } finally {
                if (!cancelled) setLoading(false);
            }
        })();
        return () => {
            cancelled = true;
        };
    }, [logId]);

    if (loading) return <p className="panel-meta">Loading…</p>;
    if (error) return <div className="alert error">{error}</div>;
    if (!log) return null;

    return (
        <section className="panel detail-panel">
            <DetailHeader title={`AI request #${log.id}`} subtitle={log.model} onBack={onBack} />
            <InfoGrid
                items={[
                    { label: 'User', value: log.user?.email ?? log.user_id ?? '—' },
                    { label: 'Chat', value: log.chat?.title ?? log.chat_id ?? '—' },
                    { label: 'Status', value: <StatusBadge status={log.status} /> },
                    { label: 'Prompt tokens', value: log.prompt_tokens ?? 0 },
                    { label: 'Response tokens', value: log.response_tokens ?? 0 },
                    { label: 'Time', value: formatDate(log.created_at) },
                ]}
            />
        </section>
    );
}
