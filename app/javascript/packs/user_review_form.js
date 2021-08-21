import Vue from 'vue/dist/vue.esm';

new Vue({
  el: '#userReviewForm',
  data: {
    bodyError: '',
    bodyField: document.getElementById('userReviewBody').value
  },
  methods: {
    bodyValid: function() {
      this.bodyNullCheck
      this.bodyError ? false : this.bodyValidCheck
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