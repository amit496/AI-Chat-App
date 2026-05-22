import { StrictMode } from 'react';
import { createRoot } from 'react-dom/client';
import Welcome from './components/Welcome';

const el = document.getElementById('app');

if (el) {
    createRoot(el).render(
        <StrictMode>
            <Welcome />
        </StrictMode>,
    );
}
