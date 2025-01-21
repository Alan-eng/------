<template>
  <div>
    <Toast />
    <nav class="bg-white shadow-sm p-4 mb-4">
      <div class="container flex justify-content-between align-items-center">
        <h1 class="text-xl font-bold text-primary">EventTickets</h1>
        <div>
          <Button label="Login" class="p-button-text mr-2" />
          <Button label="Register" class="p-button-outlined" />
        </div>
      </div>
    </nav>
    <main class="container">
      <NuxtPage />
    </main>
  </div>
</template>

<script setup>
</script>
