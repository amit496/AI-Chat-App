import { StrictMode } from 'react';
import { createRoot } from 'react-dom/client';
import AdminApp from './components/AdminApp';

const el = document.getElementById('admin-app');

if (el) {
    createRoot(el).render(
        <StrictMode>
            <AdminApp />
        </StrictMode>,
    );
}
