import { ref, watch } from 'vue'

export const useTheme = () => {
    const isDark = ref(false)

    // Initialize theme from localStorage or system preference
    if (process.client) {
        isDark.value = localStorage.getItem('theme') === 'dark' || 
            (!localStorage.getItem('theme') && window.matchMedia('(prefers-color-scheme: dark)').matches)
        
        // Apply theme on initialization
        applyTheme(isDark.value)
    }

    // Watch for changes and update
    watch(isDark, (newValue) => {
        applyTheme(newValue)
        localStorage.setItem('theme', newValue ? 'dark' : 'light')
    })

    function applyTheme(dark: boolean) {
        const html = document.documentElement
        if (dark) {
            html.classList.add('dark')
            document.body.setAttribute('data-theme-mode', 'dark')
            html.style.colorScheme = 'dark'
        } else {
            html.classList.remove('dark')
            document.body.setAttribute('data-theme-mode', 'light')
            html.style.colorScheme = 'light'
        }
    }

    function toggleTheme() {
        isDark.value = !isDark.value
    }

    return {
        isDark,
        toggleTheme
    }
}
