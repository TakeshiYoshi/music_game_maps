<template>
  <transition>
    <img src="./images/page_top.png" class="scroll-top" v-show="visible" @click="scrollTop">
  </transition>
</template>

<script>
export default {
  data: function () {
    return {
      visible: false
    }
  },
  created: function() {
    window.addEventListener('scroll', this.handleScroll);
  },
  methods: {
    scrollTop: function() {
      window.scrollTo({
        top: 0,
        behavior: 'smooth'
      });
    },
    handleScroll: function() {
      let html = window.document.documentElement;
      let scrollBottomY = html.scrollHeight - html.clientHeight - window.scrollY;

      if(window.scrollY > 200 && scrollBottomY > 60) {
        this.visible = true;
      } else {
        this.visible = false;
      }
    }
  }
}
</script>

<style lang="scss" scoped>
.scroll-top {
  position: fixed;
  right: 10px;
  bottom: 10px;
  transition: all 0.2s;
}

.v-enter-active {
  animation: slide-in 0.3s ease-out;
}

.v-leave-active {
  opacity: 0;
}

@keyframes slide-in {
    0% { right: -200px; }
   85% { right:   30px; }
  100% { right:   10px; }
}
</style>