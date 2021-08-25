import Vue from 'vue/dist/vue.esm';

new Vue({
  el: '#userReviewForm',
  data: {
    bodyError: '',
    imagesError: '',
    images: [],
    bodyField: document.getElementById('userReviewBody').value
  },
  methods: {
    bodyValid: function() {
      this.bodyNullCheck
      this.bodyError ? false : this.bodyValidCheck
    },
    previewImages: function(e) {
      const images = e.target.files;
      this.checkLength(images)
      for(const image of images) {
        this.images.push(window.URL.createObjectURL(image))
      }
    },
    checkLength: function(images) {
      this.imagesError = images.length <= 4 ? '' : '添付画像の枚数を4枚以下にしてください。'
    }
  },
  computed: {
    bodyValidCheck: function() {
      const bodyReg = /^.{1,1000}$/;
      this.bodyError = bodyReg.test(this.bodyField) ? '' : '本文は1~1000文字で入力してください。'
    },
    bodyNullCheck: function() {
      this.bodyError = this.bodyField ? '' : '本文を入力してください。'
    }
  }
});