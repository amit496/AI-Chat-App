export default function DataTable({ columns, rows, emptyText, onRowClick }) {
    if (!rows.length) return <p className="empty-state">{emptyText}</p>;
    return (
        <div className="table-wrap">
            <table>
                <thead>
                    <tr>
                        {columns.map((c) => (
                            <th key={c.key}>{c.label}</th>
                        ))}
                    </tr>
                </thead>
                <tbody>
                    {rows.map((row) => (
                        <tr
                            key={row.id ?? row.key}
                            className={onRowClick ? 'row-clickable' : ''}
                            onClick={onRowClick ? () => onRowClick(row) : undefined}
                        >
                            {columns.map((c) => (
                                <td key={c.key} onClick={c.stopRowClick ? (e) => e.stopPropagation() : undefined}>
                                    {c.render ? c.render(row) : row[c.key] ?? '—'}
                                </td>
                            ))}
                        </tr>
                    ))}
                </tbody>
            </table>
        </div>
    );
}
