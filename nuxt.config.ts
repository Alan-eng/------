// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  compatibilityDate: '2024-11-01',
  devtools: { enabled: true },
  ssr: false,
  modules: [
    '@nuxtjs/supabase',
    '@nuxt/ui',
    'nuxt-primevue'
  ],
  primevue: {
    theme: 'aura-light-green',
    components: {
      include: ['Button', 'Dropdown', 'Calendar', 'InputNumber', 'DataTable', 'Column', 'Card', 'Dialog', 'Toast', 'Slider']
    },
    options: {
      unstyled: false,
      ripple: true
    }
  },
  css: [
    'primevue/resources/themes/aura-light-green/theme.css',
    'primevue/resources/primevue.css',
    'primeicons/primeicons.css',
    '@/assets/styles/main.scss'
  ],
  build: {
    transpile: ['primevue']
  },
  supabase: {
    url: 'https://ukqxkbbwffcmtwmmwuxx.supabase.co',
    key: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVrcXhrYmJ3ZmZjbXR3bW13dXh4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzc0NTU1MTMsImV4cCI6MjA1MzAzMTUxM30.lDNoX109o9ya-txwENcmEAtGajzwRN1u7rai5ZFw1hA',
    redirect: false,
    cookieOptions: {
      secure: process.env.NODE_ENV === 'production'
    }
  }
})
