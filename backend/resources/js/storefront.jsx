import { StrictMode } from 'react';
import { createRoot } from 'react-dom/client';
import StorefrontHome from './Pages/Storefront/Home';

const el = document.getElementById('app');

if (el) {
    createRoot(el).render(
        <StrictMode>
            <StorefrontHome />
        </StrictMode>,
    );
}
