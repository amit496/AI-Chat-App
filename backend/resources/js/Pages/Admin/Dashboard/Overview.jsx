import BrandMark from '../../../Components/Admin/BrandMark';
import DataTable from '../../../Components/Admin/DataTable';
import StatCard from '../../../Components/Admin/StatCard';
import {
    IconAi,
    IconBolt,
    IconChats,
    IconErrors,
    IconMessages,
    IconUsers,
} from '../../../Components/Admin/Icons';
import { formatDate, refId } from '../../../lib/adminApi';

const STAT_CARDS = [
    { key: 'users', label: 'Total users', Icon: IconUsers, tab: 'users', hint: 'Registered accounts' },
    { key: 'chats', label: 'Total chats', Icon: IconChats, tab: 'users', hint: 'All conversations' },
    { key: 'messages', label: 'Messages', Icon: IconMessages, tab: 'users', hint: 'User + AI messages' },
    { key: 'ai_requests', label: 'AI requests', Icon: IconAi, tab: 'ai', hint: 'Gemini API calls' },
    { key: 'ai_usage_today', label: 'AI today', Icon: IconBolt, tab: 'ai', hint: "Today's usage" },
    { key: 'errors', label: 'Error logs', Icon: IconErrors, tab: 'errors', hint: 'Failed API calls' },
];

export default function DashboardOverview({ stats, users, adminUser, onOpenTab, onOpenUser }) {
    const viewBtn = (onClick) => (
        <button type="button" className="btn-link" onClick={onClick}>
            View →
        </button>
    );

    return (
        <>
            <section className="welcome-banner">
                <div>
                    <h2>Welcome back{adminUser?.name ? `, ${adminUser.name}` : ''}</h2>
                    <p>Back office overview — users, chats, AI usage, errors.</p>
                </div>
                <BrandMark size="md" variant="welcome" />
            </section>
            <div className="stats-grid">
                {STAT_CARDS.map((card) => (
                    <StatCard key={card.key} card={card} value={stats[card.key]} onOpen={onOpenTab} />
                ))}
            </div>
            <section className="panel">
                <div className="panel-header-row">
                    <h2>Recent users</h2>
                    <button type="button" className="link-btn" onClick={() => onOpenTab('users')}>
                        View all users →
                    </button>
                </div>
                <DataTable
                    emptyText="No users registered yet."
                    rows={users.slice(0, 8)}
                    columns={[
                        { key: 'id', label: 'ID' },
                        { key: 'name', label: 'Name' },
                        { key: 'email', label: 'Email' },
                        { key: 'chats_count', label: 'Chats', render: (r) => r.chats_count ?? 0 },
                        { key: 'created_at', label: 'Joined', render: (r) => formatDate(r.created_at) },
                        {
                            key: 'actions',
                            label: '',
                            stopRowClick: true,
                            render: (r) => viewBtn(() => onOpenUser(refId(r))),
                        },
                    ]}
                />
            </section>
        </>
    );
}
