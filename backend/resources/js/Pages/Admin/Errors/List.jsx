import DataTable from '../../../Components/Admin/DataTable';
import { formatDate, refId } from '../../../lib/adminApi';

export default function ErrorsList({ errors, onOpen }) {
    const viewBtn = (onClick) => (
        <button type="button" className="btn-link" onClick={onClick}>
            View →
        </button>
    );

    return (
        <section className="panel">
            <p className="panel-meta">{errors.length} error(s)</p>
            <DataTable
                emptyText="No errors logged."
                rows={errors}
                onRowClick={(r) => onOpen(refId(r))}
                columns={[
                    { key: 'id', label: 'ID' },
                    { key: 'user', label: 'User', render: (r) => r.user?.email ?? r.user_id ?? '—' },
                    { key: 'endpoint', label: 'Endpoint' },
                    {
                        key: 'message',
                        label: 'Message',
                        render: (r) => (
                            <span className="cell-truncate" title={r.message}>
                                {r.message}
                            </span>
                        ),
                    },
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
