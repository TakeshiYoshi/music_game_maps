import Vue from 'vue'
import App from '../app.vue'

Vue.config.productionTip = false

document.addEventListener('DOMContentLoaded', () => {
  const app = new Vue({
    el: '#form-select',
    render: h => h(App)
  })
})