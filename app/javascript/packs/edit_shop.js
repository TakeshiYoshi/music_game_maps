import Vue from 'vue/dist/vue.esm';

new Vue({
  el: '#edit_shop_form',
  data: {
    nameError: '',
    websiteError: '',
    nameField: document.getElementById('shopName').value,
    websiteField: document.getElementById('shopWebsite').value
  },
  methods: {
    nameValid: function() {
      this.nameNullCheck
    },
    websiteValid: function() {
      this.websiteError = ''
      this.websiteError ? false : this.websiteValidCheck
    },
    imagePreview: function(e) {
      const file = e.target.files[0];
      const url = window.URL.createObjectURL(file);
      document.getElementById('shopImg').src = url;
    }
  },
  computed: {
    websiteValidCheck: function() {
      const websiteReg = /^https?:\/\/[\w!\?/\+\-_~=;\.,\*&@#\$%\(\)'\[\]]+$/;
      this.websiteError = websiteReg.test(this.websiteField) ? '' : '正しいフォーマットでURLを入力してください。'
    },
    nameNullCheck: function() {
      this.nameError = this.nameField ? '' : '店舗名を入力してください。'
    }
  }
});