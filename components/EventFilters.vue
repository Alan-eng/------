<template>
  <div class="p-4 bg-white/80 dark:bg-gray-900/80 backdrop-blur-sm rounded-xl mb-4 w-full">
    <h3 class="text-lg font-semibold mb-4">Фильтры событий</h3>
    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
      <!-- Категория -->
      <div class="flex flex-col gap-2">
        <label class="font-medium">Выберите категорию события</label>
        <Dropdown
          v-model="selectedCategory"
          :options="categories"
          optionLabel="name"
          placeholder="Выберите категорию"
          class="w-full"
          @change="updateFilters"
        />
      </div>

      <!-- Жанр -->
      <div class="flex flex-col gap-2">
        <label class="font-medium">Выберите жанр события</label>
        <Dropdown
          v-model="selectedGenre"
          :options="filteredGenres"
          optionLabel="name"
          placeholder="Выберите жанр"
          class="w-full"
          @change="updateFilters"
        />
      </div>

      <!-- Цена -->
      <div class="flex flex-col gap-2">
        <label class="font-medium">Цена</label>
        <div class="flex flex-col gap-2 w-full">
          <div class="flex justify-between gap-2 align-items-center">
            <InputNumber 
              v-model="priceRange[0]" 
              :min="0" 
              :max="priceRange[1]" 
              :step="100"
              mode="currency" 
              currency="RUB"
              locale="ru-RU"
              class="w-full"
              @update:model-value="updateFilters"
            />
            <InputNumber 
              v-model="priceRange[1]" 
              :min="priceRange[0]" 
              :max="10000" 
              :step="100"
              mode="currency" 
              currency="RUB"
              locale="ru-RU"
              class="w-full"
              :inputStyle="{ textAlign: 'right' }"
              @update:model-value="updateFilters"
            />
          </div>
          <Slider 
            v-model="priceRange" 
            range 
            :min="0" 
            :max="10000" 
            :step="100"
            class="w-full" 
            @change="updateFilters"
          />
        </div>
      </div>

      <!-- Дата -->
      <div class="flex flex-col gap-2">
        <label class="font-medium">Выберите даты проведения</label>
        <Calendar
          v-model="selectedDate"
          selectionMode="range"
          dateFormat="dd.mm.yy"
          placeholder="Выберите период"
          class="w-full"
          @date-select="updateFilters"
        />
      </div>
    </div>

    <!-- Кнопки управления -->
    <div class="flex justify-content-end gap-2 mt-4">
      <Button
        label="Сбросить фильтры"
        class="p-button-text"
        @click="resetFilters"
      />
      <Button
        label="Применить фильтры"
        @click="applyFilters"
      />
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import Slider from 'primevue/slider'
import InputNumber from 'primevue/inputnumber'

const categories = ref([
  { name: 'Все категории', value: null },
  { name: 'Фестивали', value: 'festival' },
  { name: 'Ретриты', value: 'retreat' },
  { name: 'Концерты', value: 'concert' }
])

const genres = ref([
  { name: 'Все жанры', value: null },
  // Фестивали
  { name: 'Культурный', value: 'cultural', category: 'festival' },
  { name: 'Еда и напитки', value: 'food', category: 'festival' },
  { name: 'Развлечения', value: 'entertainment', category: 'festival' },
  { name: 'Искусство', value: 'art', category: 'festival' },
  { name: 'Музыка', value: 'music', category: 'festival' },
  { name: 'Образование', value: 'education', category: 'festival' },
  { name: 'Кино', value: 'cinema', category: 'festival' },
  { name: 'Спорт', value: 'sport', category: 'festival' },
  // Ретриты
  { name: 'Йога', value: 'yoga', category: 'retreat' },
  { name: 'Здоровье', value: 'health', category: 'retreat' },
  { name: 'Медитация', value: 'meditation', category: 'retreat' },
  { name: 'Духовные практики', value: 'spiritual', category: 'retreat' },
  { name: 'Арт-терапия', value: 'art', category: 'retreat' },
  { name: 'Экология', value: 'eco', category: 'retreat' },
  { name: 'Осознанность', value: 'mindfulness', category: 'retreat' },
  { name: 'Танец', value: 'dance', category: 'retreat' },
  // Концерты
  { name: 'Классическая музыка', value: 'classical', category: 'concert' },
  { name: 'Рок', value: 'rock', category: 'concert' },
  { name: 'Джаз', value: 'jazz', category: 'concert' },
  { name: 'Электронная музыка', value: 'electronic', category: 'concert' },
  { name: 'Романс', value: 'romance', category: 'concert' },
  { name: 'Хип-хоп', value: 'hip-hop', category: 'concert' },
  { name: 'Фолк', value: 'folk', category: 'concert' },
  { name: 'Поп', value: 'pop', category: 'concert' },
  { name: 'Блюз', value: 'blues', category: 'concert' },
  { name: 'Металл', value: 'metal', category: 'concert' }
])

const selectedCategory = ref(null)
const selectedGenre = ref(null)
const priceRange = ref([0, 10000])
const selectedDate = ref(null)

// Computed property для отфильтрованных жанров на основе выбранной категории
const filteredGenres = computed(() => {
  if (!selectedCategory.value?.value) {
    return genres.value
  }
  return genres.value.filter(genre => 
    !genre.category || genre.category === selectedCategory.value.value
  )
})

// Emit события для обновления фильтров
const emit = defineEmits(['update:filters'])

// Функция обновления фильтров
const updateFilters = () => {
  emit('update:filters', {
    category: selectedCategory.value?.value,
    genre: selectedGenre.value?.value,
    price: {
      min: priceRange.value[0],
      max: priceRange.value[1]
    },
    date: selectedDate.value
  })
}

// Сброс фильтров
const resetFilters = () => {
  selectedCategory.value = categories.value[0]
  selectedGenre.value = genres.value[0]
  priceRange.value = [0, 10000]
  selectedDate.value = null
  updateFilters()
}

// Применение фильтров
const applyFilters = () => {
  updateFilters()
}
</script>
