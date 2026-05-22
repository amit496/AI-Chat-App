import { IconBack } from './Icons';

export default function DetailHeader({ title, subtitle, onBack }) {
    return (
        <div className="detail-header">
            <button type="button" className="btn-back" onClick={onBack}>
                <IconBack />
                Back
            </button>
            <div>
                <h2>{title}</h2>
                {subtitle && <p className="detail-subtitle">{subtitle}</p>}
            </div>
        </div>
    );
}
