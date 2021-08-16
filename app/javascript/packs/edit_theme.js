import Vue from 'vue'
import App from '../edit_theme.vue'

Vue.config.productionTip = false

document.addEventListener('DOMContentLoaded', () => {
  const app = new Vue({
    el: '#editTheme',
    render: h => h(App)
  })
})