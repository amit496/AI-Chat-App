export default function InfoGrid({ items }) {
    return (
        <div className="info-grid">
            {items.map((item) => (
                <div key={item.label} className="info-cell">
                    <span className="info-label">{item.label}</span>
                    <span className="info-value">{item.value}</span>
                </div>
            ))}
        </div>
    );
}
