<template>
  <swiper :options="swiperOption" ref="swiper" id="previewImages">
    <swiper-slide class="glass-text userReview-image">
      swiper 1
      <img src="">
    </swiper-slide>
    <swiper-slide class="glass-text userReview-image">
      swiper 2
      <img src="">
    </swiper-slide>
    <swiper-slide class="glass-text userReview-image">
      swiper 3
      <img src="">
    </swiper-slide>
    <div class="swiper-button-prev" slot="button-prev"></div>
    <div class="swiper-button-next" slot="button-next"></div>
  </swiper>
</template>

<script>
import { Swiper, SwiperSlide } from 'vue-awesome-swiper'
import 'swiper/css/swiper.css'
import 'swiper/swiper.scss'

export default {
  data: function () {
    return {
      swiperOption: {
        navigation: {
          nextEl: '.swiper-button-next',
          prevEl: '.swiper-button-prev'
        },
        observer: true,
        observeParents: true,
      }
    }
  },
  components: {
    Swiper,
    SwiperSlide,
  }
};
</script>