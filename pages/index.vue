<template>
  <div>
    <h2 class="page-title">Upcoming Events</h2>
    
    <div class="grid">
      <div v-for="event in events" :key="event.id" class="col-12 md:col-6 lg:col-4 xl:col-3">
        <Card class="event-card m-2">
          <template #header>
            <img :src="event.image_url" :alt="event.title" class="w-full h-12rem object-cover" />
          </template>
          <template #title>
            {{ event.title }}
          </template>
          <template #subtitle>
            <div class="flex align-items-center">
              <i class="pi pi-calendar mr-2"></i>
              {{ new Date(event.date).toLocaleDateString() }}
            </div>
          </template>
          <template #content>
            <p>{{ event.description }}</p>
            <p class="text-xl font-bold mt-3">{{ event.price }} ₽</p>
          </template>
          <template #footer>
            <Button label="Buy Tickets" class="p-button-raised" @click="openTicketDialog(event)" />
          </template>
        </Card>
      </div>
    </div>

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
