import Vue from 'vue'
import App from '../scroll_top.vue'

Vue.config.productionTip = false

document.addEventListener('DOMContentLoaded', () => {
  const app = new Vue({
    el: '#scrollTop',
    render: h => h(App)
  })
})