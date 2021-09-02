import Vue from 'vue'
import App from '../image_preview.vue'

Vue.config.productionTip = false

document.addEventListener('DOMContentLoaded', () => {
  const app = new Vue({
    el: '#imageSwiper',
    render: h => h(App)
  })
})