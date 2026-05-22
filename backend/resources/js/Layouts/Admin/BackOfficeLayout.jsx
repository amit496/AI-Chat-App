import BrandMark from '../../Components/Admin/BrandMark';
import {
    IconAi,
    IconDashboard,
    IconErrors,
    IconLogout,
    IconRefresh,
    IconUsers,
} from '../../Components/Admin/Icons';
import { brandName } from '../../lib/adminApi';

export const ADMIN_NAV = [
    { id: 'overview', label: 'Dashboard', Icon: IconDashboard },
    { id: 'users', label: 'Users', Icon: IconUsers },
    { id: 'ai', label: 'AI Usage', Icon: IconAi },
    { id: 'errors', label: 'Errors', Icon: IconErrors },
];

/**
 * Back office shell: sidebar + top bar.
 * Children = page content (dashboard, user list, details, …)
 */
export default function BackOfficeLayout({
    adminUser,
    tab,
    detail,
    usersCount,
    pageTitle,
    loading,
    onTab,
    onLogout,
    onRefresh,
    children,
}) {
    return (
        <div className="admin-shell">
            <aside className="admin-sidebar">
                <div className="sidebar-brand">
                    <BrandMark size="sm" variant="sidebar" />
                    <div>
                        <strong>{brandName()}</strong>
                        <span>Back Office</span>
                    </div>
                </div>
                <nav>
                    {ADMIN_NAV.map((item) => (
                        <button
                            key={item.id}
                            type="button"
                            className={`nav-item ${tab === item.id && !detail ? 'active' : ''}`}
                            onClick={() => onTab(item.id)}
                        >
                            <item.Icon />
                            {item.label}
                            {item.id === 'users' && usersCount > 0 && (
                                <span className="nav-badge">{usersCount}</span>
                            )}
                        </button>
                    ))}
                </nav>
                <div className="sidebar-footer">
                    {adminUser && (
                        <p className="sidebar-admin">
                            <strong>{adminUser.name}</strong>
                            <span>{adminUser.email}</span>
                        </p>
                    )}
                    <button type="button" className="nav-logout" onClick={onLogout}>
                        <IconLogout />
                        Logout
                    </button>
                </div>
            </aside>

            <main className="admin-main">
                <header className="admin-topbar">
                    <h1>{pageTitle}</h1>
                    <div className="topbar-actions">
                        <button type="button" className="btn-ghost btn-with-icon" onClick={onRefresh} disabled={loading}>
                            <IconRefresh />
                            {loading ? 'Refreshing…' : 'Refresh'}
                        </button>
                    </div>
                </header>
                {children}
            </main>
        </div>
    );
}
