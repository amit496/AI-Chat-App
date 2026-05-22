/** Inline SVG icons for admin panel */

export function IconDashboard({ className = 'nav-svg' }) {
    return (
        <svg className={className} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" aria-hidden>
            <rect x="3" y="3" width="7" height="9" rx="1" />
            <rect x="14" y="3" width="7" height="5" rx="1" />
            <rect x="14" y="12" width="7" height="9" rx="1" />
            <rect x="3" y="16" width="7" height="5" rx="1" />
        </svg>
    );
}

export function IconUsers({ className = 'nav-svg' }) {
    return (
        <svg className={className} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" aria-hidden>
            <circle cx="9" cy="8" r="3" />
            <path d="M3 20c0-3.3 2.7-6 6-6s6 2.7 6 6" />
            <circle cx="17" cy="9" r="2.5" />
            <path d="M14 20c0-2.5 1.8-4.5 4-4.5" />
        </svg>
    );
}

export function IconAi({ className = 'nav-svg' }) {
    return (
        <svg className={className} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" aria-hidden>
            <path d="M12 3v3M12 18v3M3 12h3M18 12h3" />
            <circle cx="12" cy="12" r="4" />
            <path d="M8 8l2 2M14 14l2 2M16 8l-2 2M8 16l2-2" />
        </svg>
    );
}

export function IconErrors({ className = 'nav-svg' }) {
    return (
        <svg className={className} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" aria-hidden>
            <path d="M12 9v4M12 17h.01" />
            <path d="M10.3 4.3h3.4L22 20H2L10.3 4.3z" />
        </svg>
    );
}

export function IconRefresh({ className = 'nav-svg' }) {
    return (
        <svg className={className} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" aria-hidden>
            <path d="M4 12a8 8 0 0 1 14-5M20 12a8 8 0 0 1-14 5" />
            <path d="M20 4v5h-5M4 20v-5h5" />
        </svg>
    );
}

export function IconBack({ className = 'nav-svg' }) {
    return (
        <svg className={className} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" aria-hidden>
            <path d="M15 18l-6-6 6-6" />
        </svg>
    );
}

export function IconLogout({ className = 'nav-svg' }) {
    return (
        <svg className={className} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" aria-hidden>
            <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4" />
            <path d="M16 17l5-5-5-5M21 12H9" />
        </svg>
    );
}

export function IconChats({ className = 'stat-svg' }) {
    return (
        <svg className={className} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" aria-hidden>
            <path d="M21 15a4 4 0 0 1-4 4H8l-5 3V7a4 4 0 0 1 4-4h10a4 4 0 0 1 4 4z" />
        </svg>
    );
}

export function IconMessages({ className = 'stat-svg' }) {
    return (
        <svg className={className} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" aria-hidden>
            <path d="M4 6h16M4 12h10M4 18h6" />
        </svg>
    );
}

export function IconBolt({ className = 'stat-svg' }) {
    return (
        <svg className={className} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" aria-hidden>
            <path d="M13 2L4 14h7l-1 8 9-12h-7l1-8z" />
        </svg>
    );
}
