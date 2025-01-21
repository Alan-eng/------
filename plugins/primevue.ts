import { defineNuxtPlugin } from '#app'
import PrimeVue from 'primevue/config'
import Button from 'primevue/button'
import Card from 'primevue/card'
import DataTable from 'primevue/datatable'
import Column from 'primevue/column'
import InputText from 'primevue/inputtext'
import Calendar from 'primevue/calendar'
import Dialog from 'primevue/dialog'
import Toast from 'primevue/toast'
import ToastService from 'primevue/toastservice'
import Dropdown from 'primevue/dropdown'
import InputNumber from 'primevue/inputnumber'
import FloatLabel from 'primevue/floatlabel'

// Import themes
import 'primevue/resources/themes/lara-light-blue/theme.css'
import 'primevue/resources/themes/lara-dark-blue/theme.css'
import 'primevue/resources/primevue.css'
import 'primeicons/primeicons.css'

export default defineNuxtPlugin((nuxtApp) => {
    nuxtApp.vueApp.use(PrimeVue, {
        ripple: true,
        unstyled: false,
        pt: {
            card: {
                root: { class: 'backdrop-blur-sm bg-white/80 dark:bg-gray-900/80' }
            }
        }
    })
    nuxtApp.vueApp.use(ToastService)
    
    nuxtApp.vueApp.component('Button', Button)
    nuxtApp.vueApp.component('Card', Card)
    nuxtApp.vueApp.component('DataTable', DataTable)
    nuxtApp.vueApp.component('Column', Column)
    nuxtApp.vueApp.component('InputText', InputText)
    nuxtApp.vueApp.component('Calendar', Calendar)
    nuxtApp.vueApp.component('Dialog', Dialog)
    nuxtApp.vueApp.component('Toast', Toast)
    nuxtApp.vueApp.component('Dropdown', Dropdown)
    nuxtApp.vueApp.component('InputNumber', InputNumber)
    nuxtApp.vueApp.component('FloatLabel', FloatLabel)
})
