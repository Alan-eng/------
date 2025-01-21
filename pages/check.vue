<template>
  <div class="container">
    <h2 class="page-title">Проверка данных в базе</h2>
    
    <DataTable :value="events" :paginator="true" :rows="10" tableStyle="min-width: 50rem">
      <Column field="id" header="ID" style="width: 25%"></Column>
      <Column field="title" header="Название" style="width: 25%"></Column>
      <Column field="price" header="Цена" style="width: 25%">
        <template #body="slotProps">
          {{ slotProps.data.price }} ₽
        </template>
      </Column>
      <Column field="date" header="Дата" style="width: 25%">
        <template #body="slotProps">
          {{ new Date(slotProps.data.date).toLocaleString() }}
        </template>
      </Column>
    </DataTable>

    <div v-if="error" class="error-message">
      <p>Ошибка: {{ error }}</p>
    </div>

    <div v-if="events.length === 0" class="no-data">
      <p>Данные не найдены. Убедитесь, что вы выполнили SQL-скрипт в Supabase.</p>
    </div>
  </div>
</template>

<script setup>
const client = useSupabaseClient()
const events = ref([])
const error = ref(null)

// Загрузка данных при монтировании компонента
onMounted(async () => {
  try {
    const { data, error: err } = await client
      .from('events')
      .select('*')
      .order('date', { ascending: true })

    if (err) throw err

    events.value = data
    console.log('Загруженные мероприятия:', data)
  } catch (err) {
    error.value = err.message
    console.error('Ошибка при загрузке данных:', err)
  }
})
</script>

<style scoped>
.error-message {
  color: red;
  padding: 1rem;
  margin: 1rem 0;
  background-color: #ffebee;
  border-radius: 4px;
}

.no-data {
  padding: 1rem;
  margin: 1rem 0;
  background-color: #f5f5f5;
  border-radius: 4px;
  text-align: center;
}
</style>
