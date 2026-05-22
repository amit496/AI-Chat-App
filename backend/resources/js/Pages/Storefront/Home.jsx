const brandName = () => window.__BRAND__?.name ?? 'App';

/**
 * Storefront home — public website for end users (/).
 * Not the admin panel. Not the Flutter app.
 */
export default function StorefrontHome() {
    return (
        <div className="welcome">
            <img src="/logo.png" alt={brandName()} width="96" height="96" style={{ borderRadius: 20 }} />
            <h1>{brandName()}</h1>
            <p>AI Chat — download the mobile app or visit back office.</p>
            <ul>
                <li>
                    <a href="/admin">Back office (admin login)</a>
                </li>
                <li>
                    <a href="/api/up">API health check</a>
                </li>
            </ul>
        </div>
    );
}
