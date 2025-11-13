import tailwindcss from '@tailwindcss/vite';
import react from '@vitejs/plugin-react';
import laravel from 'laravel-vite-plugin';
import { defineConfig } from 'vite';

// Detect if running on Vercel
const isVercel = process.env.VERCEL === '1';
const isProduction = process.env.NODE_ENV === 'production';

// Plugins that always load
const plugins: any[] = [
    laravel({
        input: ['resources/css/app.css', 'resources/js/app.tsx'],
        ssr: 'resources/js/ssr.tsx',
        refresh: true,
    }),
    react(),
    tailwindcss(),
];

// ✅ Only include Wayfinder locally (not on Vercel or production)
if (!isVercel && !isProduction) {
    const { wayfinder } = await import('@laravel/vite-plugin-wayfinder');
    plugins.push(
        wayfinder({
            formVariants: true,
        }),
    );
}

export default defineConfig({
    plugins,
    esbuild: {
        jsx: 'automatic',
    },
});
