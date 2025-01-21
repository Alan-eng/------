<template>
  <div class="min-h-screen transition-colors duration-300" :class="{ 'dark': isDark }">
    <Toast />
    <nav class="bg-white/80 dark:bg-gray-900/80 shadow-sm backdrop-blur-sm sticky top-0 z-50 transition-colors duration-300">
      <div class="container flex justify-content-between align-items-center p-4">
        <h1 class="text-xl font-bold text-gray-900 dark:text-white">ТуСам!</h1>
        <div class="flex gap-4 items-center">
          <Button icon="pi pi-sun" v-if="isDark" @click="toggleTheme" class="p-button-rounded p-button-text" />
          <Button icon="pi pi-moon" v-else @click="toggleTheme" class="p-button-rounded p-button-text" />
          <Button label="Войти" class="p-button-text" />
          <Button label="Регистрация" class="p-button-outlined" />
        </div>
      </div>
    </nav>
    <main class="container mx-auto p-4">
      <NuxtPage />
    </main>
  </div>
</template>

<script setup>
import './assets/css/primevue-dark.css'
import { ref } from 'vue'
import Button from 'primevue/button'
import Dropdown from 'primevue/dropdown'
import Calendar from 'primevue/calendar'
import InputNumber from 'primevue/inputnumber'
import DataTable from 'primevue/datatable'
import Column from 'primevue/column'
import Card from 'primevue/card'
import Dialog from 'primevue/dialog'
import Toast from 'primevue/toast'
import Slider from 'primevue/slider'
import { useTheme } from './composables/useTheme'

const { isDark, toggleTheme } = useTheme()
</script>

<style>
:root {
  color-scheme: light;
}

:root.dark {
  color-scheme: dark;
}

.dark body {
  background-color: #1a1a1a;
  color: #ffffff;
}

body {
  margin: 0;
  padding: 0;
  font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
  background-color: #f3f4f6;
  transition: background-color 0.3s;
}

.container {
  max-width: 1400px;
  margin: 0 auto;
  padding: 0 1rem;
}
</style>
