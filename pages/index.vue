<template>
  <div>
    <div class="flex justify-content-between align-items-center mb-4">
      <h2 class="page-title m-0">Предстоящие события</h2>
      <div class="flex gap-2">
        <Button icon="pi pi-th-large" @click="viewMode = 'grid'" :class="{ 'p-button-outlined': viewMode !== 'grid' }" />
        <Button icon="pi pi-list" @click="viewMode = 'list'" :class="{ 'p-button-outlined': viewMode !== 'list' }" />
      </div>
    </div>

    <!-- Фильтры -->
    <EventFilters @update:filters="applyFilters" />
    
    <!-- Вид сеткой -->
    <div v-if="viewMode === 'grid'" class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 xl:grid-cols-5 gap-4">
      <div v-for="event in filteredEvents" :key="event.id">
        <Card class="event-card h-full rounded-xl cursor-pointer bg-white/80 dark:bg-gray-900/80 backdrop-blur-sm" @click="openTicketDialog(event)">
          <template #header>
            <div class="relative">
              <img :src="event.image_url" :alt="event.title" class="w-full h-48 object-cover rounded-t-xl" />
              <div class="absolute top-0 right-0 m-3">
                <span class="text-xl font-bold bg-white/90 dark:bg-gray-900/90 backdrop-blur-sm text-primary-900 dark:text-primary-100 px-4 py-2 rounded-full shadow-sm">{{ event.price }} ₽</span>
              </div>
            </div>
          </template>
          <template #title>
            <div class="text-xl font-bold text-gray-900 dark:text-white">{{ event.title }}</div>
          </template>
          <template #subtitle>
            <div class="flex align-items-center text-gray-500 dark:text-gray-400">
              <i class="pi pi-calendar mr-2"></i>
              {{ new Date(event.date).toLocaleDateString() }}
            </div>
          </template>
          <template #content>
            <p class="line-clamp-3 text-gray-600 dark:text-gray-300">{{ event.description }}</p>
          </template>
        </Card>
      </div>
    </div>

    <!-- Вид списком -->
    <div v-else>
      <DataTable :value="filteredEvents" 
                 :paginator="true" 
                 :rows="10"
                 :rowsPerPageOptions="[5,10,20,50]"
                 stripedRows
                 class="p-datatable-lg">
        <Column field="image_url" header="Изображение" style="width: 150px">
          <template #body="slotProps">
            <img :src="slotProps.data.image_url" :alt="slotProps.data.title" class="w-full h-20 object-cover shadow-1 border-round" />
          </template>
        </Column>
        
        <Column field="title" header="Название" sortable>
          <template #body="slotProps">
            <div class="font-bold">{{ slotProps.data.title }}</div>
            <div class="text-sm text-500 line-clamp-2">{{ slotProps.data.description }}</div>
          </template>
        </Column>
        
        <Column field="date" header="Дата" sortable style="width: 200px">
          <template #body="slotProps">
            <div class="flex align-items-center">
              <i class="pi pi-calendar mr-2"></i>
              {{ new Date(slotProps.data.date).toLocaleString() }}
            </div>
          </template>
        </Column>
        
        <Column field="price" header="Цена" sortable style="width: 150px">
          <template #body="slotProps">
            <div class="text-xl font-bold">{{ slotProps.data.price }} ₽</div>
          </template>
        </Column>
        
        <Column style="width: 150px">
          <template #body="slotProps">
            <Button label="Купить билеты" 
                    class="p-button-raised" 
                    @click="openTicketDialog(slotProps.data)" />
          </template>
        </Column>
      </DataTable>
    </div>

    <!-- Диалог покупки билетов -->
    <Dialog v-model:visible="ticketDialogVisible" :header="selectedEvent?.title" modal>
      <div class="flex flex-column gap-3">
        <div class="flex align-items-center justify-content-between">
          <span>Количество:</span>
          <div class="flex align-items-center gap-2">
            <Button icon="pi pi-minus" @click="decrementQuantity" :disabled="quantity <= 1" />
            <span class="text-xl">{{ quantity }}</span>
            <Button icon="pi pi-plus" @click="incrementQuantity" />
          </div>
        </div>
        <div class="text-right">
          <span class="text-xl font-bold">Итого: {{ calculateTotal }} ₽</span>
        </div>
      </div>
      <template #footer>
        <Button label="Отмена" icon="pi pi-times" @click="closeTicketDialog" class="p-button-text" />
        <Button label="Купить" icon="pi pi-check" @click="purchaseTickets" autofocus />
      </template>
    </Dialog>
  </div>
</template>

<script setup>
import EventFilters from '~/components/EventFilters.vue'

const client = useSupabaseClient()
const user = useSupabaseUser()
const toast = useToast()

const viewMode = ref('grid') // 'grid' или 'list'
const activeFilters = ref({})

// Функция применения фильтров
const applyFilters = (filters) => {
  activeFilters.value = { ...filters }
  refreshEvents()
}

// Получаем события с учетом фильтров
const { data: events, refresh: refreshEvents } = await useAsyncData(
  'events',
  async () => {
    let query = client.from('events').select('*')

    // Применяем фильтры
    if (activeFilters.value.category) {
      query = query.eq('category', activeFilters.value.category)
    }
    if (activeFilters.value.genre) {
      query = query.eq('genre', activeFilters.value.genre)
    }
    if (activeFilters.value.priceMin) {
      query = query.gte('price', activeFilters.value.priceMin)
    }
    if (activeFilters.value.priceMax) {
      query = query.lte('price', activeFilters.value.priceMax)
    }
    if (activeFilters.value.dateStart) {
      query = query.gte('date', activeFilters.value.dateStart.toISOString())
    }
    if (activeFilters.value.dateEnd) {
      query = query.lte('date', activeFilters.value.dateEnd.toISOString())
    }

    query = query.order('date', { ascending: true })
    
    const { data, error } = await query
    
    if (error) {
      console.error('Error fetching events:', error)
      return []
    }
    
    return data
  }
)

const filteredEvents = computed(() => {
  if (!events.value) return []
  
  return events.value.filter(event => {
    // Фильтр по категории
    if (activeFilters.value.category && event.category !== activeFilters.value.category) {
      return false
    }
    
    // Фильтр по жанру
    if (activeFilters.value.genre && event.genre !== activeFilters.value.genre) {
      return false
    }
    
    // Фильтр по цене
    if (activeFilters.value.price) {
      const { min, max } = activeFilters.value.price
      if (event.price < min || event.price > max) {
        return false
      }
    }
    
    // Фильтр по дате
    if (activeFilters.value.date) {
      const eventDate = new Date(event.date)
      const startDate = new Date(activeFilters.value.date[0])
      const endDate = new Date(activeFilters.value.date[1])
      
      if (eventDate < startDate || eventDate > endDate) {
        return false
      }
    }
    
    return true
  })
})

const ticketDialogVisible = ref(false)
const selectedEvent = ref(null)
const quantity = ref(1)

const openTicketDialog = (event) => {
  if (!user.value) {
    toast.add({
      severity: 'info',
      summary: 'Требуется авторизация',
      detail: 'Пожалуйста, войдите в систему для покупки билетов',
      life: 3000
    })
    return
  }
  selectedEvent.value = event
  quantity.value = 1
  ticketDialogVisible.value = true
}

const closeTicketDialog = () => {
  ticketDialogVisible.value = false
  selectedEvent.value = null
}

const incrementQuantity = () => {
  quantity.value++
}

const decrementQuantity = () => {
  if (quantity.value > 1) {
    quantity.value--
  }
}

const calculateTotal = computed(() => {
  if (!selectedEvent.value) return 0
  return (selectedEvent.value.price * quantity.value).toFixed(2)
})

const purchaseTickets = async () => {
  if (!user.value) {
    toast.add({
      severity: 'error',
      summary: 'Ошибка',
      detail: 'Пожалуйста, войдите в систему для покупки билетов',
      life: 3000
    })
    return
  }

  try {
    await client.from('tickets').insert({
      event_id: selectedEvent.value.id,
      user_id: user.value.id,
      quantity: quantity.value,
      total_price: calculateTotal.value,
      status: 'pending'
    })
    
    toast.add({
      severity: 'success',
      summary: 'Успешно',
      detail: 'Билеты успешно куплены!',
      life: 3000
    })
    
    closeTicketDialog()
  } catch (error) {
    toast.add({
      severity: 'error',
      summary: 'Ошибка',
      detail: 'Не удалось купить билеты. Пожалуйста, попробуйте снова.',
      life: 3000
    })
  }
}
</script>

<style scoped>
.line-clamp-3 {
  display: -webkit-box;
  -webkit-line-clamp: 3;
  -webkit-box-orient: vertical;
  overflow: hidden;
  margin: 0;
}

.event-card {
  display: flex;
  flex-direction: column;
  transition: all 0.2s ease-in-out;
  margin: 0;
}

.event-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
}

.event-card :deep(.p-card-body) {
  flex: 1;
  display: flex;
  flex-direction: column;
  padding: 1.25rem;
}

.event-card :deep(.p-card-content) {
  flex: 1;
  padding: 1.25rem 0;
}

.event-card :deep(.p-card-header) {
  padding: 0;
  margin: 0;
}

.event-card :deep(.p-card-header img) {
  display: block;
  width: 100%;
}

:deep(.p-float-label) {
  display: block;
  margin-bottom: 0.5rem;
}

:deep(.p-float-label label) {
  background: var(--surface-card);
}

:deep(.p-inputtext),
:deep(.p-dropdown),
:deep(.p-calendar),
:deep(.p-inputnumber) {
  width: 100%;
}

:deep(.dark .p-float-label label) {
  background: var(--surface-card);
  color: var(--text-color);
}

:deep(.p-datatable.p-datatable-lg) {
  font-size: 1rem;
}

:deep(.p-dropdown-panel) {
  z-index: 1000;
}

:deep(.p-calendar-panel) {
  z-index: 1000;
}

:deep(.p-inputnumber-buttons-stacked .p-button.p-inputnumber-button-up) {
  border-top-right-radius: var(--border-radius);
}

:deep(.p-inputnumber-buttons-stacked .p-button.p-inputnumber-button-down) {
  border-bottom-right-radius: var(--border-radius);
}
</style>
