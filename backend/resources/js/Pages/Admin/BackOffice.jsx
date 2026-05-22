import { useCallback, useEffect, useState } from 'react';
import BackOfficeLayout, { ADMIN_NAV } from '../../Layouts/Admin/BackOfficeLayout';
import { adminRequest } from '../../lib/adminApi';
import AiUsageList from './AiUsage/List';
import AiUsageShow from './AiUsage/Show';
import ChatShow from './Chats/Show';
import DashboardOverview from './Dashboard/Overview';
import ErrorsList from './Errors/List';
import ErrorShow from './Errors/Show';
import UsersList from './Users/List';
import UserShow from './Users/Show';

/** Back office main app (after login) */
export default function BackOffice({ adminUser, onLogout }) {
    const [stats, setStats] = useState(null);
    const [users, setUsers] = useState([]);
    const [usage, setUsage] = useState([]);
    const [errors, setErrors] = useState([]);
    const [tab, setTab] = useState('overview');
    const [loadError, setLoadError] = useState('');
    const [loading, setLoading] = useState(true);
    const [detail, setDetail] = useState(null);

    const load = useCallback(async () => {
        setLoading(true);
        setLoadError('');
        try {
            const [s, u, a, e] = await Promise.all([
                adminRequest('/admin/stats'),
                adminRequest('/admin/users'),
                adminRequest('/admin/ai-usage'),
                adminRequest('/admin/errors'),
            ]);
            setStats(s);
            setUsers(u.data || []);
            setUsage(a.data || []);
            setErrors(e.data || []);
        } catch (err) {
            setLoadError(err.message);
            if (err.message.includes('Session expired') || err.message.includes('Unauthorized')) {
                onLogout(false);
            }
        } finally {
            setLoading(false);
        }
    }, [onLogout]);

    useEffect(() => {
        load();
    }, [load]);

    async function logout() {
        try {
            await adminRequest('/admin/logout', { method: 'POST' });
        } catch (_) {
            /* ignore */
        }
        onLogout(true);
    }

    function openTab(id) {
        setDetail(null);
        setTab(id);
    }

    function closeDetail() {
        if (detail?.type === 'chat' && detail.fromUser) {
            setDetail({ type: 'user', id: detail.fromUser });
            return;
        }
        setDetail(null);
    }

    const pageTitle = detail
        ? { user: 'User details', chat: 'Chat details', ai: 'AI request', error: 'Error details' }[detail.type]
        : ADMIN_NAV.find((n) => n.id === tab)?.label ?? 'Dashboard';

    let content = null;

    if (detail?.type === 'user') {
        content = (
            <UserShow
                userId={detail.id}
                onBack={closeDetail}
                onOpenChat={(chatEid) => setDetail({ type: 'chat', id: chatEid, fromUser: detail.id })}
            />
        );
    } else if (detail?.type === 'chat') {
        content = <ChatShow chatId={detail.id} onBack={closeDetail} />;
    } else if (detail?.type === 'ai') {
        content = <AiUsageShow logId={detail.id} onBack={closeDetail} />;
    } else if (detail?.type === 'error') {
        content = <ErrorShow logId={detail.id} onBack={closeDetail} />;
    } else if (loading) {
        content = (
            <div className="loading-grid">
                {[1, 2, 3, 4, 5, 6].map((i) => (
                    <div key={i} className="stat-card-pro skeleton" />
                ))}
            </div>
        );
    } else if (tab === 'overview' && stats) {
        content = (
            <DashboardOverview
                stats={stats}
                users={users}
                adminUser={adminUser}
                onOpenTab={openTab}
                onOpenUser={(id) => setDetail({ type: 'user', id })}
            />
        );
    } else if (tab === 'users') {
        content = <UsersList users={users} onOpenUser={(id) => setDetail({ type: 'user', id })} />;
    } else if (tab === 'ai') {
        content = <AiUsageList usage={usage} onOpen={(id) => setDetail({ type: 'ai', id })} />;
    } else if (tab === 'errors') {
        content = <ErrorsList errors={errors} onOpen={(id) => setDetail({ type: 'error', id })} />;
    }

    return (
        <BackOfficeLayout
            adminUser={adminUser}
            tab={tab}
            detail={detail}
            usersCount={users.length}
            pageTitle={pageTitle}
            loading={loading}
            onTab={openTab}
            onLogout={logout}
            onRefresh={load}
        >
            {loadError && <div className="alert error">{loadError}</div>}
            {content}
        </BackOfficeLayout>
    );
}
