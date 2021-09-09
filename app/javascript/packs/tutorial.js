import Vue from 'vue'
import App from '../tutorial.vue'

Vue.config.productionTip = false

document.addEventListener('DOMContentLoaded', () => {
  const app = new Vue({
    el: '#tutorial',
    render: h => h(App)
  })
})

