import DataTable from '../../../Components/Admin/DataTable';
import StatusBadge from '../../../Components/Admin/StatusBadge';
import { formatDate, refId } from '../../../lib/adminApi';

export default function AiUsageList({ usage, onOpen }) {
    const viewBtn = (onClick) => (
        <button type="button" className="btn-link" onClick={onClick}>
            View →
        </button>
    );

    return (
        <section className="panel">
            <p className="panel-meta">{usage.length} log(s)</p>
            <DataTable
                emptyText="No AI usage logged yet."
                rows={usage}
                onRowClick={(r) => onOpen(refId(r))}
                columns={[
                    { key: 'id', label: 'ID' },
                    { key: 'user', label: 'User', render: (r) => r.user?.email ?? r.user_id ?? '—' },
                    { key: 'model', label: 'Model' },
                    { key: 'status', label: 'Status', render: (r) => <StatusBadge status={r.status} /> },
                    { key: 'prompt_tokens', label: 'Prompt', render: (r) => r.prompt_tokens ?? 0 },
                    { key: 'response_tokens', label: 'Response', render: (r) => r.response_tokens ?? 0 },
                    { key: 'created_at', label: 'Time', render: (r) => formatDate(r.created_at) },
                    {
                        key: 'actions',
                        label: '',
                        stopRowClick: true,
                        render: (r) => viewBtn(() => onOpen(refId(r))),
                    },
                ]}
            />
        </section>
    );
}
