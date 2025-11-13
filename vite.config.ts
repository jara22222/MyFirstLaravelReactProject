import tailwindcss from '@tailwindcss/vite';
import react from '@vitejs/plugin-react';
import laravel from 'laravel-vite-plugin';
import { defineConfig, Plugin } from 'vite';

// Import only when PHP is available (locally)
let wayfinderPlugin: Plugin<any>[] = [];
if (process.env.NODE_ENV !== 'production') {
    try {
        const { wayfinder } = await import('@laravel/vite-plugin-wayfinder');
        wayfinderPlugin = [
            wayfinder({
                formVariants: true,
            }),
        ];
    } catch (e) {
        console.warn('Wayfinder not loaded: PHP may not be available.');
    }
}

export default defineConfig({
    plugins: [
        laravel({
            input: ['resources/css/app.css', 'resources/js/app.tsx'],
            ssr: 'resources/js/ssr.tsx',
            refresh: true,
        }),
        react(),
        tailwindcss(),
        ...wayfinderPlugin, // 👈 only added if local
    ],
    esbuild: {
        jsx: 'automatic',
    },
});
