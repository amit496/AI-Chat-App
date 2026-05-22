export default function BrandMark({ size = 'md', variant = 'default' }) {
    const cls = ['brand-mark', `brand-mark-${size}`, variant !== 'default' ? `brand-mark-${variant}` : '']
        .filter(Boolean)
        .join(' ');
    return (
        <div className={cls} aria-hidden>
            <span className="brand-mark-icon">✦</span>
        </div>
    );
}
