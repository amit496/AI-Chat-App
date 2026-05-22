export default function StatCard({ card, value, onOpen }) {
    const Icon = card.Icon;
    return (
        <article className="stat-card-pro">
            <div className="stat-card-top">
                <span className="stat-card-icon-wrap">
                    <Icon />
                </span>
                <span className="stat-card-label">{card.label}</span>
            </div>
            <strong className="stat-value">{value ?? 0}</strong>
            <p className="stat-card-hint">{card.hint}</p>
            <button type="button" className="stat-card-link" onClick={() => onOpen(card.tab)}>
                View details →
            </button>
        </article>
    );
}
