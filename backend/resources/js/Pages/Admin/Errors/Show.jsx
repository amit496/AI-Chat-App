import { useEffect, useState } from 'react';
import DetailHeader from '../../../Components/Admin/DetailHeader';
import InfoGrid from '../../../Components/Admin/InfoGrid';
import { adminRequest, detailPath, formatDate } from '../../../lib/adminApi';

export default function ErrorShow({ logId, onBack }) {
    const [log, setLog] = useState(null);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState('');

    useEffect(() => {
        let cancelled = false;
        (async () => {
            setLoading(true);
            try {
                const res = await adminRequest(detailPath('errors', logId));
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
            <DetailHeader title={`Error #${log.id}`} subtitle={log.endpoint} onBack={onBack} />
            <InfoGrid
                items={[
                    { label: 'User', value: log.user?.email ?? log.user_id ?? '—' },
                    { label: 'Source', value: log.source || '—' },
                    { label: 'Endpoint', value: log.endpoint || '—' },
                    { label: 'Time', value: formatDate(log.created_at) },
                ]}
            />
            <h3 className="detail-section-title">Message</h3>
            <pre className="code-block">{log.message}</pre>
            {log.context && (
                <>
                    <h3 className="detail-section-title">Context</h3>
                    <pre className="code-block">{JSON.stringify(log.context, null, 2)}</pre>
                </>
            )}
        </section>
    );
}
