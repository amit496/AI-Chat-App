const brandName = () => window.__BRAND__?.name ?? 'App';

export default function Welcome() {
    return (
        <div className="welcome">
            <img src="/logo.png" alt={brandName()} width="96" height="96" style={{ borderRadius: 20 }} />
            <h1>{brandName()}</h1>
            <p>AI Chat API — Laravel + React views</p>
            <ul>
                <li>
                    <a href="/admin">Admin dashboard (React)</a>
                </li>
                <li>
                    <a href="/api/up">API health</a>
                </li>
            </ul>
        </div>
    );
}
