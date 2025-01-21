<template>
  <div>
    <div class="flex justify-content-between align-items-center mb-4">
      <h2 class="page-title m-0">Upcoming Events</h2>
      <div class="flex gap-2">
        <Button icon="pi pi-th-large" @click="viewMode = 'grid'" :class="{ 'p-button-outlined': viewMode !== 'grid' }" />
        <Button icon="pi pi-list" @click="viewMode = 'list'" :class="{ 'p-button-outlined': viewMode !== 'list' }" />
      </div>
    </div>
    
    <!-- Grid View -->
    <div v-if="viewMode === 'grid'" class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 xl:grid-cols-5 gap-4">
      <div v-for="event in events" :key="event.id">
        <Card class="event-card h-full">
          <template #header>
            <div class="relative">
              <img :src="event.image_url" :alt="event.title" class="w-full h-12rem object-cover" />
              <div class="absolute top-0 right-0 m-2">
                <span class="text-xl font-bold bg-primary-100 text-primary-900 p-2 border-round">{{ event.price }} ₽</span>
              </div>
            </div>
          </template>
          <template #title>
            <div class="text-xl font-bold text-900">{{ event.title }}</div>
          </template>
          <template #subtitle>
            <div class="flex align-items-center text-500">
              <i class="pi pi-calendar mr-2"></i>
              {{ new Date(event.date).toLocaleDateString() }}
            </div>
          </template>
          <template #content>
            <p class="line-clamp-3 text-700">{{ event.description }}</p>
          </template>
          <template #footer>
            <Button label="Buy Tickets" class="p-button-raised w-full" @click="openTicketDialog(event)" />
          </template>
        </Card>
      </div>
    </div>

    <!-- List View -->
    <div v-else>
      <DataTable :value="events" 
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
            <Button label="Buy Tickets" 
                    class="p-button-raised" 
                    @click="openTicketDialog(slotProps.data)" />
          </template>
        </Column>
      </DataTable>
    </div>

    <!-- Ticket Dialog -->
    <Dialog v-model:visible="ticketDialogVisible" :header="selectedEvent?.title" modal>
      <div class="flex flex-column gap-3">
        <div class="flex align-items-center justify-content-between">
          <span>Quantity:</span>
          <div class="flex align-items-center gap-2">
            <Button icon="pi pi-minus" @click="decrementQuantity" :disabled="quantity <= 1" />
            <span class="text-xl">{{ quantity }}</span>
            <Button icon="pi pi-plus" @click="incrementQuantity" />
          </div>
        </div>
        <div class="text-right">
          <span class="text-xl font-bold">Total: {{ calculateTotal }} ₽</span>
        </div>
      </div>
      <template #footer>
        <Button label="Cancel" icon="pi pi-times" @click="closeTicketDialog" class="p-button-text" />
        <Button label="Purchase" icon="pi pi-check" @click="purchaseTickets" autofocus />
      </template>
    </Dialog>
  </div>
</template>

<script setup>
const client = useSupabaseClient()
const user = useSupabaseUser()
const toast = useToast()

const viewMode = ref('grid') // 'grid' или 'list'

const { data: events } = await useAsyncData('events', async () => {
  const { data } = await client
    .from('events')
    .select('*')
    .order('date', { ascending: true })
  return data
})

const ticketDialogVisible = ref(false)
const selectedEvent = ref(null)
const quantity = ref(1)

const openTicketDialog = (event) => {
  if (!user.value) {
    toast.add({
      severity: 'info',
      summary: 'Login Required',
      detail: 'Please login to purchase tickets',
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
      summary: 'Error',
      detail: 'Please login to purchase tickets',
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
      summary: 'Success',
      detail: 'Tickets purchased successfully!',
      life: 3000
    })
    
    closeTicketDialog()
  } catch (error) {
    toast.add({
      severity: 'error',
      summary: 'Error',
      detail: 'Failed to purchase tickets. Please try again.',
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
  transition: transform 0.2s, box-shadow 0.2s;
  margin: 0;
}

.event-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
}

.event-card :deep(.p-card-body) {
  flex: 1;
  display: flex;
  flex-direction: column;
  padding: 1rem;
}

.event-card :deep(.p-card-content) {
  flex: 1;
  padding: 1rem 0;
}

.event-card :deep(.p-card-footer) {
  margin-top: auto;
  padding: 0;
}
</style>
