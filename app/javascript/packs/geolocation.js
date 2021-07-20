import Vue from 'vue'
import App from '../geolocation_button.vue'

Vue.config.productionTip = false

document.addEventListener('DOMContentLoaded', () => {
  const app = new Vue({
    el: '#geolocation_button',
    render: h => h(App)
  })
})